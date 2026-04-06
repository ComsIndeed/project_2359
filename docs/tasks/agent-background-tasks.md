Task 1: Service Consolidation (Entry Point Unification) Objective: Move all
logic and primary service access into the AppController to provide a single
source of truth for the UI.

1.1 AppController Synchronization Logic: Ensure AppController holds the final
instances of: DraftService SourceService CardService StudyDatabaseService (As a
DAL) Refactor: Create direct property access so the UI can do
context.read<AppController>().draftService. 1.2 StudyDatabaseService Decoupling
Action: Move "Feature Logic" (e.g., Folder management orchestrations) out of the
mono-service and into the AppController . Goal: Transform StudyDatabaseService
into a pure Data Access Layer (DAL) for direct table CRUD only. 1.3 Context
Migration Search & Replace: Migrating all context.read<T>() calls for individual
services to the unified AppController access pattern. Verification: Ensure
main.dart only provides the AppDatabase and AppController , simplifying the
MultiProvider tree.
