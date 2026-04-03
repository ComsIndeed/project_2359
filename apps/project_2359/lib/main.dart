import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/core/study_scheduler_service.dart';
import 'package:project_2359/features/home_page/home_page.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/theme_notifier.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:project_2359/core/utils/logger.dart';
import 'package:project_2359/core/settings/labs_settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:project_2359/core/utils/shortcut_system.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('--- Application starting ---', tag: 'Main');

  pdfrxInitialize();
  AppLogger.info('PDFRX initialized', tag: 'Main');

  AppLogger.info('Initializing Supabase...', tag: 'Main');
  await Supabase.initialize(
    url: 'https://digzsxnfivcmrsyzdnrb.supabase.co',
    anonKey: 'sb_publishable_moMCFpqrLfTXqWaJATrahQ_SUfKdwbm',
  );

  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (e) {
    debugPrint('Failed to set high refresh rate: $e');
  }

  await themeNotifier.init();
  await labsSettings.init();

  AppLogger.info('Initializing services...', tag: 'Main');
  final database = AppDatabase();
  final sourceService = SourceService(database);
  final studyMaterialService = StudyDatabaseService(database);
  final studySchedulerService = StudySchedulerService(database);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDatabase>.value(value: database),
        RepositoryProvider<SourceService>.value(value: sourceService),
        RepositoryProvider<StudyDatabaseService>.value(
          value: studyMaterialService,
        ),
        RepositoryProvider.value(value: studySchedulerService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SourcesPageBloc(sourceService)..add(const LoadSourcesEvent()),
          ),
        ],
        child: MainApp(sourceService: sourceService),
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  final SourceService sourceService;

  const MainApp({super.key, required this.sourceService});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleGlobalKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleGlobalKey);
    super.dispose();
  }

  bool _handleGlobalKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // TODO: UNDERSTAND THIS
    // Handle Esc bubbling logic specifically
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      final focus = FocusManager.instance.primaryFocus;

      // 1. Unfocus if in a TextField
      if (focus != null && focus.context != null) {
        final editable = focus.context!
            .findAncestorWidgetOfExactType<EditableText>();
        if (focus.hasPrimaryFocus &&
            focus.canRequestFocus &&
            (focus.debugLabel?.contains('EditableText') == true ||
                editable != null)) {
          focus.unfocus();
          return true;
        }
      }

      // Let it bubble up to ShortcutManager or Navigator if not handled
    }

    // Try ProjectShortcutManager
    return ProjectShortcutManager.handleKeyEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.themeMode,
          theme: AppTheme.buildTheme(
            Brightness.light,
            themeNotifier.accentColor,
            backgroundTone: themeNotifier.backgroundTone,
          ),
          darkTheme: AppTheme.buildTheme(
            Brightness.dark,
            themeNotifier.accentColor,
            backgroundTone: themeNotifier.backgroundTone,
          ),
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
