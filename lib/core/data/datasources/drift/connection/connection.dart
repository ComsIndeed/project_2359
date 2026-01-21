/// Platform-agnostic database connection
///
/// Exports either native or web connection based on platform
library;

export 'native.dart' if (dart.library.html) 'web.dart';
