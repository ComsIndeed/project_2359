import 'package:flutter/foundation.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/services/card_service.dart';
import 'package:project_2359/core/services/draft_service.dart';
import 'package:project_2359/core/services/scheduling_service.dart';
import 'package:project_2359/core/study_database_service.dart';
import 'package:project_2359/features/sources_page/source_service.dart';

// TODO: Refactor entire codebase to refer to the services from here instead of seperate via contexts
class AppController extends ChangeNotifier {
  final AppDatabase appDatabase;
  final DraftService draftService;
  final CardService cardService;
  final SourceService sourceService;
  final StudyDatabaseService studyDatabaseService;
  final SchedulingService schedulingService;

  AppController({required this.appDatabase})
    : draftService = DraftService(appDatabase),
      cardService = CardService(),
      sourceService = SourceService(appDatabase),
      studyDatabaseService = StudyDatabaseService(appDatabase),
      schedulingService = SchedulingService(appDatabase);
}
