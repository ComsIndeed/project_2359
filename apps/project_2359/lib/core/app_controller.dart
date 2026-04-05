import 'package:flutter/foundation.dart';
import 'package:project_2359/app_database.dart';
import 'package:project_2359/core/services/draft_service.dart';

// TODO: Refactor code to be put into this instead
class AppController extends ChangeNotifier {
  final AppDatabase _appDatabase;
  final DraftService draftService;

  AppController({required AppDatabase appDatabase})
    : _appDatabase = appDatabase,
      draftService = DraftService(appDatabase);
}
