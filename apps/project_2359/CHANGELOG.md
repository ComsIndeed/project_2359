# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.1.0 - 2026-02-01

### Added
- Homepage with custom `SpecialNavigationBar` featuring animated page actions
- `SpecialSearchBar` widget with custom styling, recent search suggestions, and quick actions
- Study Page UI with popup navigation items
- Local database for study materials and sources using Drift
- `StudyMaterialPacks`, `StudyMaterialItems`, and `SourceItems` database tables
- Core `Source` and `StudyMaterial` models with serialization/deserialization
- App theming system with reusable widgets
- App logo in homepage header

### Changed
- Complete codebase cleanup and restructure (migrated from vibecoded branch)
- Refactored navigation bar into reusable `SpecialNavigationBar` component
- Homepage screen content refactored with navbar as overlay
- Tab switching now uses PageView for smoother transitions
- Renamed `homepage` directory to `home_page` for consistency

### Fixed
- Web build compilation issues
- Version mismatch errors
- Missing dependencies
- Broken navbar functionality

### Removed
- Legacy vibecoded implementations
- Unused imports and redundant code

## 1.0.0

- Initial release
- Basic app structure with Expo Router
- Tamagui UI framework integration

<!-- 
================================================================================
HOW TO USE THIS CHANGELOG:
================================================================================

When releasing a new version, add a new section ABOVE the previous version:

## X.Y.Z

- Added: New features
- Changed: Modified functionality  
- Fixed: Bug fixes
- Removed: Removed features
- Security: Security fixes

The GitHub Action will automatically extract the content below the version 
header (## X.Y.Z) up until the next version header and use it as the release 
notes.

Example:
---------
## 1.1.0

- Added new authentication system
- Fixed navigation bug on Android
- Improved performance on web

## 1.0.0

- Initial release
...

================================================================================
-->
