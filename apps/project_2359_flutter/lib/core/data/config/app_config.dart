/// App configuration for Project 2359
///
/// This file contains global configuration settings for the app,
/// including the data mode toggle for switching between test and production.
library;

/// Controls whether the app runs in test mode or production mode.
///
/// **Test Mode** (`true`):
/// - Uses in-memory mock data from predefined datasets
/// - Data can be modified during runtime but resets on app restart
/// - Useful for development, testing, and demos
///
/// **Production Mode** (`false`):
/// - Uses Drift (SQLite) for persistent local storage
/// - Data persists across app restarts
/// - Ready for Supabase cloud sync integration
const bool kTestMode = true;

/// App name for database and storage paths
const String kAppName = 'project_2359';

/// Database file name for Drift
const String kDatabaseName = 'project_2359.db';
