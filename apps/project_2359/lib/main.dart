import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/features/home_page/home_page.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/features/sources_page/source_service.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_event.dart';
import 'package:project_2359/theme_notifier.dart';
import 'package:project_2359/features/sources_page/sources_page_bloc/sources_page_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final database = AppDatabase();
  final sourceService = SourceService(database);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SourcesPageBloc(sourceService)..add(const LoadSourcesEvent()),
        ),
      ],
      child: MainApp(sourceService: sourceService),
    ),
  );
}

class MainApp extends StatelessWidget {
  final SourceService sourceService;

  const MainApp({super.key, required this.sourceService});

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
          home: HomePage(),
        );
      },
    );
  }
}
