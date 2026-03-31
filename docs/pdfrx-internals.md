# pdfrx Package Internals — Knowledge Base

> **Package:** `pdfrx` v2.2.24 + `pdfrx_engine` v0.3.9 **Source location:**
> `C:\Users\Truly\AppData\Local\Pub\Cache\hosted\pub.dev\pdfrx-2.2.24` **Engine
> location:**
> `C:\Users\Truly\AppData\Local\Pub\Cache\hosted\pub.dev\pdfrx_engine-0.3.9`

---

## Table of Contents

1. [Package Structure](#1-package-structure)
2. [Coordinate Systems](#2-coordinate-systems)
3. [Core Engine Types](#3-core-engine-types-pdfrx_engine)
4. [Document Loading](#4-document-loading)
5. [PdfViewer Widget](#5-pdfviewer-widget)
6. [PdfViewerParams](#6-pdfviewerparams)
7. [PdfViewerController](#7-pdfviewercontroller)
8. [Text Handling & Selection](#8-text-handling--selection)
9. [Text Search](#9-text-search)
10. [Page Layout & Rendering](#10-page-layout--rendering)
11. [Gesture Handling](#11-gesture-handling)
12. [Overlays & Custom Painting](#12-overlays--custom-painting)
13. [Link Handling](#13-link-handling)
14. [Keyboard Handling](#14-keyboard-handling)
15. [Standalone Widgets](#15-standalone-widgets)
16. [Common Patterns & Gotchas](#16-common-patterns--gotchas)

---

## 1. Package Structure

### `lib/pdfrx.dart` — Barrel file

Exports everything from:

- `package:pdfrx_engine/pdfrx_engine.dart` — Core engine types
- `src/pdf_document_ref.dart` — Document lifecycle & caching
- `src/pdfrx_flutter.dart` — Flutter initialization & coordinate conversion
  extensions
- `src/widgets/pdf_viewer.dart` — Main viewer widget + controller
- `src/widgets/pdf_viewer_params.dart` — Configuration params
- `src/widgets/pdf_widgets.dart` — `PdfDocumentViewBuilder`, `PdfPageView`
- `src/widgets/pdf_text_searcher.dart` — Text search API
- `src/widgets/pdf_page_links_overlay.dart` — Link overlay widget

### Key source files

| File                      | Lines | Purpose                                                                                                                                                               |
| ------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `pdf_viewer.dart`         | 4367  | `PdfViewer`, `_PdfViewerState`, `PdfViewerController`, `PdfPageLayout`, `PdfTextSelectionRange`, `PdfTextSelectionAnchor`, image cache                                |
| `pdf_viewer_params.dart`  | 1710  | `PdfViewerParams` (60+ fields), all typedefs, `PdfTextSelectionParams`, `PdfViewerSelectionMagnifierParams`, `PdfLinkHandlerParams`, `PdfViewerBehaviorControlParams` |
| `interactive_viewer.dart` | 1729  | Forked `InteractiveViewer` optimized for PDF pan/zoom/scroll physics                                                                                                  |
| `pdf_document_ref.dart`   | 580   | `PdfDocumentRef` subclasses, `PdfDocumentListenable`, caching system                                                                                                  |
| `pdf_text_searcher.dart`  | 325   | `PdfTextSearcher` with progress, paint callbacks                                                                                                                      |
| `pdf_widgets.dart`        | 461   | `PdfDocumentViewBuilder`, `PdfPageView` (standalone)                                                                                                                  |
| `pdfrx_flutter.dart`      | 183   | `PdfRect`→`Rect`, `PdfPoint`→`Offset` extensions, `pdfrxFlutterInitialize()`                                                                                          |

---

## 2. Coordinate Systems

> [!CAUTION]
> **PDF coordinates ≠ Flutter coordinates.** This is the #1 source of bugs.

### PDF Page Coordinates (`PdfRect`, `PdfPoint`)

- **Origin:** Bottom-left corner
- **Y-axis:** Points **upward** (bottom < top)
- **Units:** Points (1/72 inch)
- `PdfRect(left, top, right, bottom)` where `top >= bottom` and `left <= right`

### Flutter/Document Layout Coordinates

- **Origin:** Top-left corner
- **Y-axis:** Points **downward** (standard Flutter)
- Used by `PdfPageLayout`, viewer overlays, and all Flutter widgets

### Conversion Extensions (in `pdfrx_flutter.dart`)

```dart
// PdfRect → Flutter Rect (in document coordinates relative to page)
extension PdfRectFlutterExtensions on PdfRect {
  Rect toRect({required PdfPage page, Size? scaledPageSize});
  // Converts PDF coords → Flutter coords, flipping Y and scaling
  
  Rect toRectInDocument({required PdfPage page, required Rect pageRect});
  // Rect in full document layout space (accounts for page position)
}

// PdfPoint → Flutter Offset
extension PdfPointFlutterExtension on PdfPoint {
  Offset toOffset({required PdfPage page, Size? scaledPageSize});
}

// Flutter Offset → PdfPoint
extension OffsetToPdfPointExtension on Offset {
  PdfPoint toPdfPoint({required PdfPage page, required Size scaledPageSize});
}
```

### Coordinate Converter Interface

```dart
abstract class PdfViewerCoordinateConverter {
  Offset? offsetToLocal(BuildContext context, Offset? position);
  Rect? rectToLocal(BuildContext context, Rect? rect);
  Offset? offsetToDocument(BuildContext context, Offset? position);
  Rect? rectToDocument(BuildContext context, Rect? rect);
}
```

The `_PdfViewerState` implements this. Access it indirectly via
`PdfViewerController.doc2local`.

### Controller Coordinate Methods

```dart
controller.globalToLocal(Offset global)     // Global → widget-local
controller.localToGlobal(Offset local)      // Widget-local → global
controller.globalToDocument(Offset global)  // Global → document layout
controller.documentToGlobal(Offset doc)     // Document layout → global
controller.localToDocument(Offset local)    // Widget-local → document layout
controller.documentToLocal(Offset doc)      // Document layout → widget-local
```

---

## 3. Core Engine Types (`pdfrx_engine`)

### `PdfDocument`

```dart
class PdfDocument {
  String get sourceName;
  List<PdfPage> get pages;        // 0-indexed list of pages
  PdfPermissions? get permissions;
  Stream<PdfDocumentEvent> get events;
  
  void dispose();
  Future<List<PdfOutlineNode>?> loadOutline();
  Future<void> loadPagesProgressively({...});
  Future<Uint8List> encodePdf({bool incremental, bool removeSecurity});
  
  // Static factory methods:
  static Future<PdfDocument> openFile(String filePath, {...});
  static Future<PdfDocument> openAsset(String name, {...});
  static Future<PdfDocument> openData(Uint8List data, {...});
  static Future<PdfDocument> openUri(Uri uri, {...});
  static Future<PdfDocument> openCustom({...});
  static Future<PdfDocument> createNew({required String sourceName});
}
```

### `PdfPage`

```dart
class PdfPage {
  int get pageNumber;          // 1-based
  double get width;            // In PDF points
  double get height;           // In PDF points
  PdfPageRotation get rotation;
  PdfDocument get document;
  bool get isPageSizeAvailable;
  
  Future<PdfImage?> render({
    int x, int y, int? width, int? height,
    double? fullWidth, double? fullHeight,
    int? backgroundColor,
    PdfPageRotation? rotationOverride,
    PdfAnnotationRenderingMode annotationRenderingMode,
    PdfPageRenderCancellationToken? cancellationToken,
  });
  
  Future<PdfPageText?> loadText();
  Future<List<PdfLink>?> loadLinks({bool compact, bool enableAutoLinkDetection});
  PdfPageRenderCancellationToken createCancellationToken();
}

// Extension:
extension PdfPageBaseExtensions on PdfPage {
  Future<PdfPageText?> loadStructuredText({bool ensureLoaded = true});
  // ^ Does text flow analysis & line segmentation (reading order)
}
```

### `PdfPageText`

```dart
class PdfPageText {
  int pageNumber;
  String fullText;                        // Full page text
  List<PdfRect> charRects;                // Bounding rect per character (PDF coords)
  List<PdfPageTextFragment> fragments;    // Structured text fragments
  
  int getFragmentIndexForTextIndex(int textIndex);
  PdfPageTextFragment? getFragmentForTextIndex(int textIndex);
  Stream<PdfPageTextRange> allMatches(Pattern pattern, {bool caseInsensitive});
  PdfPageTextRange getRangeFromAB(int a, int b);  // Both indices inclusive
}
```

### `PdfPageTextFragment`

Represents a contiguous block of text with uniform direction.

```dart
class PdfPageTextFragment {
  PdfPageText pageText;
  int index;                    // Start index in fullText
  int length;
  int get end => index + length;
  PdfRect bounds;               // Bounding rect (PDF coords)
  List<PdfRect> charRects;      // Per-character rects (PDF coords)
  PdfTextDirection direction;   // ltr, rtl, vrtl, unknown
  String get text;              // Substring of fullText
}
```

### `PdfPageTextRange`

```dart
class PdfPageTextRange {
  PdfPageText pageText;
  int start;               // Inclusive index in fullText
  int end;                 // Exclusive index in fullText
  int get pageNumber;
  String get text;
  PdfRect get bounds;      // Bounding rect (PDF coords)
  int get firstFragmentIndex;
  int get lastFragmentIndex;
  Iterable<PdfTextFragmentBoundingRect> enumerateFragmentBoundingRects();
}
```

### `PdfRect`

```dart
class PdfRect {
  // PDF coordinates: origin bottom-left, Y up
  const PdfRect(left, top, right, bottom);
  // Invariants: left <= right, top >= bottom
  
  double get width => right - left;
  double get height => top - bottom;
  PdfPoint get center;
  PdfRect merge(PdfRect other);
  bool containsPoint(PdfPoint offset, {double margin});
  PdfRect inflate(double dx, double dy);
  PdfRect translate(double dx, double dy);
  PdfRect rotate(int rotation, PdfPage page);
  static const empty = PdfRect(0, 0, 0, 0);
}

extension PdfRectsExt on Iterable<PdfRect> {
  PdfRect boundingRect({int? start, int? end});
}
```

### `PdfPoint`

```dart
class PdfPoint {
  const PdfPoint(x, y);  // PDF coords (origin bottom-left, Y up)
  PdfPoint rotate(int rotation, PdfPage page);
  PdfPoint translate(double dx, double dy);
  double distanceSquaredTo(PdfPoint other);
}
```

### `PdfLink`

```dart
class PdfLink {
  Uri? url;                     // External URL (if web link)
  PdfDest? dest;                // Internal destination (if page link)
  List<PdfRect> rects;          // Location(s) on the page
  PdfAnnotation? annotation;
}
```

### `PdfDest`

```dart
class PdfDest {
  int pageNumber;
  PdfDestCommand command;     // xyz, fit, fitH, fitV, fitR, fitB, fitBH, fitBV
  List<double?>? params;
}
```

---

## 4. Document Loading

### `PdfDocumentRef` — Lifecycle Management

All subclasses of `PdfDocumentRef` provide a `key` for deduplication/caching:

| Constructor                         | Ref Class              | Key based on        |
| ----------------------------------- | ---------------------- | ------------------- |
| `PdfViewer(ref)`                    | `PdfDocumentRef` (any) | Depends on subclass |
| `PdfViewer.asset(name)`             | `PdfDocumentRefAsset`  | Asset name          |
| `PdfViewer.file(path)`              | `PdfDocumentRefFile`   | File path           |
| `PdfViewer.uri(uri)`                | `PdfDocumentRefUri`    | URI string          |
| `PdfViewer.data(data, sourceName:)` | `PdfDocumentRefData`   | `sourceName`        |
| `PdfViewer.custom(...)`             | `PdfDocumentRefCustom` | `sourceName`        |

**Key concept:** `PdfDocumentRefKey` makes multiple refs with the same key share
one `PdfDocumentListenable`, which holds the actual loaded `PdfDocument`.

```dart
// Get the listenable (shared instance manager):
final listenable = ref.resolveListenable();

// Safe async usage of document:
await listenable.useDocument((document) async {
  // document guaranteed alive during this callback
});
```

### `PdfDocumentListenable`

```dart
class PdfDocumentListenable extends ChangeNotifier {
  PdfDocument? get document;
  Object? get error;
  StackTrace? get stackTrace;
  int get bytesDownloaded;
  int? get totalBytes;
  
  void load();
  FutureOr<T?> useDocument<T>(FutureOr<T> Function(PdfDocument) task, {...});
}
```

---

## 5. PdfViewer Widget

### Constructors

```dart
PdfViewer(PdfDocumentRef ref, {controller, params, initialPageNumber})
PdfViewer.asset(String assetName, {...})
PdfViewer.file(String path, {...})
PdfViewer.uri(Uri uri, {preferRangeAccess, headers, withCredentials, timeout, ...})
PdfViewer.data(Uint8List data, {required String sourceName, ...})
PdfViewer.custom({required int fileSize, required read, required String sourceName, ...})
```

### Widget Tree (build method)

```
Container (backgroundColor)
└─ PdfViewerKeyHandler
   └─ StreamBuilder (_updateStream)
      └─ LayoutBuilder
         └─ Listener (pointer events)
            └─ Stack
               ├─ InteractiveViewer (pan/zoom)
               │  └─ GestureDetector (tap/doubleTap/longPress/secondaryTap)
               │     └─ [if textSelection disabled] CustomPaint (pages)
               │     └─ [if textSelection enabled] MouseRegion + GestureDetector (pan) + CustomPaint (pages+hitTest)
               ├─ [if links under overlays] Link handling overlay
               ├─ Page overlay widgets (_buildPageOverlayWidgets)
               ├─ [if links over overlays] Link handling overlay
               ├─ [viewerOverlayBuilder] Viewer-level overlays
               └─ Text selection widgets (handles, magnifier, context menu)
```

### Internal State (`_PdfViewerState`)

Key internal fields:

- `_document: PdfDocument?` — Current loaded document
- `_layout: PdfPageLayout?` — Computed page layout
- `_viewSize: Size?` — Viewer widget size
- `_coverScale: double?` — Zoom to cover the viewport
- `_alternativeFitScale: double?` — Zoom to fit entire page
- `_pageNumber: int?` — Current page number
- `_txController: TransformationController` — pan/zoom matrix
- `_imageCache: _PdfPageImageCache` — Rendered page image cache
- `_textCache: Map<int, PdfPageText?>` — Extracted text cache
- `_selA, _selB: PdfTextSelectionPoint?` — Selection endpoints
- `_textSelA, _textSelB: PdfTextSelectionAnchor?` — Selection anchors (with
  rects)

---

## 6. PdfViewerParams

Full configuration class with 60+ fields. Key groups:

### Layout & Appearance

```dart
PdfViewerParams({
  double margin = 8,                            // Page margin
  Color backgroundColor = Color(0xFF303030),    // Viewer background
  double maxScale = 8,                          // Max zoom
  PanAxis panAxis = PanAxis.free,               // Pan axis constraint
  bool panEnabled = true,
  bool scaleEnabled = true,
  EdgeInsets? boundaryMargin,                    // Scroll boundary
  double interactionEndFrictionCoefficient,      // Fling deceleration
  ScrollPhysics? scrollPhysics,                  // Custom scroll physics
  double? scrollPhysicsScale,
  PdfPageLayoutFunction? layoutPages,            // Custom page layout
  PdfMatrixNormalizeFunction? normalizeMatrix,   // Matrix post-processing
  PdfViewerGetPageRenderingScale? getPageRenderingScale, // DPI control
})
```

### Decoration & Overlays

```dart
PdfViewerParams({
  PdfPageDecorationBuilder? pageDecorationBuilder,    // Wrap individual pages
  PdfPageOverlaysBuilder? pageOverlaysBuilder,        // Per-page overlays
  PdfViewerOverlaysBuilder? viewerOverlayBuilder,     // Global viewer overlays
  List<PdfViewerPagePaintCallback>? pagePaintCallbacks,          // Paint ON pages (foreground)
  List<PdfViewerPagePaintCallback>? pageBackgroundPaintCallbacks, // Paint BEHIND pages
  PdfAnnotationRenderingMode annotationRenderingMode,
  bool enableRealSizeRendering = true,                // High-res tile rendering
})
```

### Text Selection

```dart
PdfViewerParams({
  PdfTextSelectionParams? textSelectionParams,
  // Contains:
  //   bool enableTextSelection = false
  //   PdfTextSelectionHandleBuilder? selectionHandleBuilder
  //   PdfTextSelectionContextMenuBuilder? contextMenuBuilder
  //   PdfViewerTextSelectionChangedCallback? onTextSelectionChange
  //   bool enableSelectionHandles = true
  //   Color selectionColor
  //   PdfViewerSelectionMagnifierParams magnifierParams
})
```

### Events & Callbacks

```dart
PdfViewerParams({
  PdfViewerDocumentChangedCallback? onDocumentChanged,
  PdfViewerReadyCallback? onViewerReady,
  PdfDocumentLoadFinished? onDocumentLoadFinished,
  PdfPageChangedCallback? onPageChanged,
  PdfViewerViewSizeChanged? onViewSizeChanged,
  PdfViewerGeneralTapHandler? onGeneralTap, // ← Critical for custom gestures
  PdfViewerCalculateInitialPageNumberFunction? calculateInitialPageNumber,
  PdfViewerCalculateZoomFunction? calculateInitialZoom,
  PdfViewerCalculateCurrentPageNumberFunction? calculateCurrentPageNumber,
  PdfLinkHandlerParams? linkHandlerParams,
})
```

### `onGeneralTap` — Details Object

```dart
class PdfViewerGeneralTapHandlerDetails {
  Offset localPosition;         // Tap position in viewer-local coords
  Offset documentPosition;      // Tap position in document layout coords
  PdfViewerGeneralTapType type; // tap | doubleTap | longPress | secondaryTap
  PdfViewerPart tapOn;          // selectedText | nonSelectedText | background
}
```

> [!IMPORTANT]
> Return `true` from `onGeneralTap` to consume the event and prevent default
> handling. Return `false` to let the viewer process it normally (e.g., word
> selection on long press).

---

## 7. PdfViewerController

Extends `ValueListenable<Matrix4>`. Controls the viewer programmatically.

### Properties

```dart
bool get isReady;
PdfDocument get document;
List<PdfPage> get pages;
int get pageCount;
int? get pageNumber;           // Current page number
double get currentZoom;
Size get viewSize;             // Widget viewport size
Size get documentSize;         // Full document layout size
Rect get visibleRect;          // Currently visible area in doc coords
double get coverScale;         // Zoom to fit page width
double? get alternativeFitScale; // Zoom to fit entire page
PdfPageLayout get layout;
PdfDocumentRef get documentRef;
PdfTextSelectionDelegate get textSelectionDelegate;
```

### Navigation

```dart
Future<void> goToPage({required int pageNumber, PdfPageAnchor? anchor, Duration duration});
Future<void> goToArea({required Rect rect, PdfPageAnchor? anchor, Duration duration});
Future<void> goToRectInsidePage({required int pageNumber, required PdfRect rect, ...});
Future<bool> goToDest(PdfDest? dest, {Duration duration});
Future<void> goTo(Matrix4? destination, {Duration duration}); // Low-level
Future<void> ensureVisible(Rect rect, {Duration duration, double margin});
```

### Zoom

```dart
Future<void> setZoom(Offset position, double zoom, {Duration duration});
Future<void> zoomUp({bool loop, Offset? zoomCenter, Duration duration});
Future<void> zoomDown({bool loop, Offset? zoomCenter, Duration duration});
Future<void> zoomOnLocalPosition({required Offset localPosition, required double newZoom, ...});
Future<void> zoomUpOnLocalPosition({required Offset localPosition, ...});
Future<void> zoomDownOnLocalPosition({required Offset localPosition, ...});
double getNextZoom({bool loop});
double getPreviousZoom({bool loop});
```

### Matrix Calculations

```dart
Matrix4 calcMatrixFor(Offset position, {double? zoom, Size? viewSize});
Matrix4 calcMatrixForPage({required int pageNumber, PdfPageAnchor? anchor});
Matrix4 calcMatrixForArea({required Rect rect, PdfPageAnchor? anchor});
Matrix4 calcMatrixForRectInsidePage({required int pageNumber, required PdfRect rect, ...});
Matrix4? calcMatrixForDest(PdfDest? dest);
Matrix4? calcMatrixForFit({required int pageNumber});
Matrix4? calcMatrixFitWidthForPage({required int pageNumber});
Matrix4? calcMatrixFitHeightForPage({required int pageNumber});
Matrix4 calcMatrixForRect(Rect rect, {double? zoomMax, double? margin});
Matrix4 calcMatrixToEnsureRectVisible(Rect rect, {double margin});
List<PdfPageFitInfo> calcFitZoomMatrices({bool sortInSuitableOrder});
```

### Hit Testing

```dart
PdfPageHitTestResult? getPdfPageHitTestResult(
  Offset offset, 
  {required bool useDocumentLayoutCoordinates}
);
// Returns page + PDF offset for the point, or null if not on a page
```

```dart
class PdfPageHitTestResult {
  PdfPage page;
  PdfPoint offset;  // Position in PDF page coordinates
}
```

### Other

```dart
void invalidate();                         // Force redraw
void setCurrentPageNumber(int pageNumber); // Set without scrolling
void forceRepaintAllPageImages();          // Re-render all page images
void handlePointerSignalEvent(PointerSignalEvent event); // Wheel event passthrough
FocusNode? get focusNode;
void requestFocus();
```

---

## 8. Text Handling & Selection

### Text Extraction Pipeline

```
PdfPage.loadText()  →  PdfPageText (raw text + charRects + fragments)
PdfPage.loadStructuredText()  →  PdfPageText (with reading order analysis)
```

The `_PdfViewerState` caches text in `_textCache: Map<int, PdfPageText?>`.

### `PdfTextSelectionDelegate`

Interface implemented by `_PdfViewerState`, accessed via
`controller.textSelectionDelegate`:

```dart
abstract class PdfTextSelectionDelegate {
  void clearTextSelection();
  void setTextSelectionPointRange(PdfTextSelectionRange range);
  List<PdfTextSelectionRange> getSelectedTextRanges();
  String? getSelectedText();
  void selectAllText();
  void selectWord(Offset offset, {PointerDeviceKind? deviceKind});
  void copyTextSelection();
}
```

### `PdfTextSelectionRange` (in pdf_viewer.dart)

```dart
class PdfTextSelectionRange {
  PdfTextSelectionPoint start;
  PdfTextSelectionPoint end;
}
```

### `PdfTextSelectionPoint`

```dart
class PdfTextSelectionPoint {
  PdfPageText text;   // The page's text object
  int index;          // Character index in fullText
}
```

### `PdfTextSelectionAnchor`

Visual anchor point with screen rectangle:

```dart
class PdfTextSelectionAnchor {
  Rect rect;                          // In document layout coordinates
  PdfTextDirection direction;
  PdfTextSelectionAnchorType type;    // a or b
  PdfPageText page;
  int index;                          // Character index
  Offset get anchorPoint;             // Anchor position derived from rect+type
  PdfTextSelectionAnchor copyWith({...});
}
```

### `PdfTextSelectionParams`

```dart
class PdfTextSelectionParams {
  bool enableTextSelection = false;
  bool enableSelectionHandles = true;         // Show drag handles
  Color selectionColor = Color(0x880000FF);
  PdfTextSelectionHandleBuilder? selectionHandleBuilder;
  PdfTextSelectionContextMenuBuilder? contextMenuBuilder;
  PdfViewerTextSelectionChangedCallback? onTextSelectionChange;
  PdfViewerSelectionMagnifierParams magnifierParams;
}
```

### Setting Text Selection Programmatically

To select text programmatically (e.g., for custom gestures):

```dart
// 1. Get the page text
final pageText = await page.loadText();

// 2. Find character indices for your selection
// (use PdfPageText.charRects for hit-testing with PDF coordinates)

// 3. Create a PdfTextSelectionRange
final range = PdfTextSelectionRange(
  start: PdfTextSelectionPoint(text: pageText, index: startIndex),
  end: PdfTextSelectionPoint(text: pageText, index: endIndex),
);

// 4. Set the selection
controller.textSelectionDelegate.setTextSelectionPointRange(range);
```

### Internal Text Selection Flow

```
Long press → selectWord() → finds nearest word boundaries → sets _selA/_selB
Pan gesture → _onTextPanStart/_onTextPanUpdate → _updateTextSelectRectTo()
             → _updateTextSelection() → finds text point for offset
             → _notifyTextSelectionChange()
```

Key internal method (text hit testing):

```dart
_findTextAndIndexForPoint(Offset? point, {double hitTestMargin = 8})
// point is in document coordinates
// Returns (PdfPageText, int charIndex) or null
```

---

## 9. Text Search

### `PdfTextSearcher`

```dart
class PdfTextSearcher extends ChangeNotifier {
  PdfTextSearcher(PdfViewerController controller);
  
  // Properties
  bool get isSearching;
  List<PdfTextRangeWithFragments> get matches;
  int? get currentIndex;
  double get searchProgress;        // 0.0 → 1.0
  
  // Methods
  void startTextSearch(Pattern searchText, {bool caseInsensitive = true, bool goToFirstMatch = true});
  void resetTextSearch();
  Future<void> goToMatchOfIndex(int index);
  Future<void> goToNextMatch();
  Future<void> goToPrevMatch();
  
  // Paint callback for highlighting (add to pagePaintCallbacks)
  List<PdfViewerPagePaintCallback> get pageTextMatchPaintCallbacks;
}
```

### Usage Pattern

```dart
final controller = PdfViewerController();
late final textSearcher = PdfTextSearcher(controller);

// In PdfViewer:
PdfViewer(
  ref,
  controller: controller,
  params: PdfViewerParams(
    pagePaintCallbacks: [
      ...textSearcher.pageTextMatchPaintCallbacks,
    ],
  ),
)

// Start search
textSearcher.startTextSearch('keyword');

// Navigate matches
textSearcher.goToNextMatch();
textSearcher.goToPrevMatch();
```

---

## 10. Page Layout & Rendering

### `PdfPageLayout`

```dart
class PdfPageLayout {
  Size documentSize;            // Total document layout size
  List<Rect> pageLayouts;       // Layout rect for each page (0-indexed)
  // Each Rect is in document coordinates (Flutter: top-left origin, Y down)
}
```

### Custom Layout Function

```dart
PdfViewerParams(
  layoutPages: (pages, params) {
    // Return custom PdfPageLayout
    // pages: List<PdfPage> (first loaded pages)
    // Must return PdfPageLayout with documentSize and pageLayouts
  },
)
```

### Rendering Pipeline

1. `_updateLayout(viewSize)` called on every rebuild
2. `_relayoutPages()` computes `PdfPageLayout` (uses `layoutPages` callback or
   default)
3. `_paintPages()` draws visible pages via `CustomPaint`
4. For each visible page:
   - Low-res preview rendered immediately
   - Full-res image cached asynchronously (`_imageCache`)
   - Real-size partial tiles rendered when zoomed in (`enableRealSizeRendering`)
5. `pageBackgroundPaintCallbacks` → page image → `pagePaintCallbacks` → overlays

### Page Decoration

```dart
PdfViewerParams(
  pageDecorationBuilder: (context, pageSize, page, pageImage) {
    // Return widget that wraps the raw page image
    // pageImage may be null during loading
    return Stack(children: [
      Container(decoration: /* shadow/border */),
      if (pageImage != null) pageImage,
    ]);
  },
)
```

### Custom Paint on Pages

```dart
PdfViewerParams(
  pagePaintCallbacks: [
    (Canvas canvas, Rect pageRect, PdfPage page) {
      // pageRect: page position/size in document layout coordinates
      // Draw OVER the page content
      
      // To draw a PdfRect on the canvas:
      PdfRect pdfRect = /*...*/;
      canvas.drawRect(
        pdfRect.toRectInDocument(page: page, pageRect: pageRect),
        Paint()..color = Colors.red.withOpacity(0.3),
      );
    },
  ],
  pageBackgroundPaintCallbacks: [
    (Canvas canvas, Rect pageRect, PdfPage page) {
      // Draw BEHIND the page content
    },
  ],
)
```

---

## 11. Gesture Handling

### Gesture Architecture

The viewer uses a layered gesture system:

```
Listener (raw pointer events: down/move/up/hover)
└─ InteractiveViewer (pan/zoom/fling)
   └─ GestureDetector (tap classification)
      ├─ onTapUp → _handleGeneralTap(globalPos, .tap)
      ├─ onDoubleTapDown → _handleGeneralTap(globalPos, .doubleTap)
      ├─ onLongPressStart → _handleGeneralTap(globalPos, .longPress)
      └─ onSecondaryTapUp → _handleGeneralTap(globalPos, .secondaryTap)
```

### `_handleGeneralTap` Flow

1. Converts global position → document position
2. Hit-tests against pages to determine `PdfViewerPart`:
   - `selectedText` — tap is on already-selected text
   - `nonSelectedText` — tap is on un-selected text
   - `background` — tap is not on any page
3. Calls `onGeneralTap` callback if provided
4. If `onGeneralTap` returns `true`, event is consumed
5. If `false`, default behavior:
   - **tap on selectedText**: Shows context menu
   - **doubleTap**: Cycles zoom levels (via `_findNextZoomStop`)
   - **longPress**: Selects word at position (`selectWord`)
   - **secondaryTap**: Shows context menu

### Custom Gesture Implementation Pattern

```dart
PdfViewerParams(
  onGeneralTap: (context, controller, details) {
    if (details.type == PdfViewerGeneralTapType.tap) {
      // Single tap: custom sentence selection
      // Use details.documentPosition for hit-testing
      // Use controller.getPdfPageHitTestResult() to find page & PDF coords
      // Load text, find boundaries, set selection
      return true; // consume event
    }
    return false; // let viewer handle other taps
  },
)
```

### Text Selection Gesture Flow (when enabled)

With `enableSelectionHandles = true`:

- Long press → `selectWord()` → shows handles
- Handle drag → `_onSelectionHandlePanStart/Update/End` →
  `_updateSelectionHandlesPan`

With `enableSelectionHandles = false` (desktop-style):

- Pan gesture → `_onTextPanStart/Update/End` → `_updateTextSelectRectTo`

---

## 12. Overlays & Custom Painting

### Page Overlays (per-page Flutter widgets)

```dart
PdfViewerParams(
  pageOverlaysBuilder: (context, Rect pageRectInViewer, PdfPage page) {
    // pageRectInViewer: position/size of page in VIEWER coordinates
    // Return list of widgets positioned relative to the page
    return [
      Positioned(
        left: pageRectInViewer.left + 10,
        top: pageRectInViewer.top + 10,
        child: Text('Page ${page.pageNumber}'),
      ),
    ];
  },
)
```

### Viewer Overlays (global, above all pages)

```dart
PdfViewerParams(
  viewerOverlayBuilder: (context, Size viewerSize, handleLinkTap) {
    // viewerSize: total viewer widget size
    // handleLinkTap: function to forward link taps
    return [
      Positioned(
        bottom: 10,
        right: 10,
        child: PageNumberIndicator(),
      ),
    ];
  },
)
```

---

## 13. Link Handling

### `PdfLinkHandlerParams`

```dart
PdfViewerParams(
  linkHandlerParams: PdfLinkHandlerParams(
    onLinkTap: (PdfLink link) {
      if (link.url != null) {
        launchUrl(link.url!);
      } else if (link.dest != null) {
        controller.goToDest(link.dest);
      }
    },
    linkColor: Colors.blue.withOpacity(0.2),
    customPainter: (canvas, pageRect, page, links) { /* custom drawing */ },
    enableAutoLinkDetection: true,
    laidOverPageOverlays: true,  // Links above or below page overlays
  ),
)
```

---

## 14. Keyboard Handling

```dart
PdfViewerParams(
  keyHandlerParams: PdfViewerKeyHandlerParams(
    enabled: true,
    autofocus: false,
    canRequestFocus: true,
    focusNode: myFocusNode,
  ),
  onKey: (params, key, isRealKeyPress) {
    // Return true: consumed, false: ignored, null: default handling
    // Default handles: arrows, page up/down, home/end  
    return null;
  },
)
```

---

## 15. Standalone Widgets

### `PdfDocumentViewBuilder`

Low-level widget for custom PDF UI without the full viewer:

```dart
PdfDocumentViewBuilder.asset(
  'assets/sample.pdf',
  builder: (context, PdfDocument? document) {
    if (document == null) return CircularProgressIndicator();
    return ListView.builder(
      itemCount: document.pages.length,
      itemBuilder: (context, index) => PdfPageView(
        document: document,
        pageNumber: index + 1,
      ),
    );
  },
)
```

### `PdfPageView`

Renders a single PDF page:

```dart
PdfPageView(
  document: document,
  pageNumber: 1,
  maximumDpi: 300,
  alignment: Alignment.center,
  decoration: BoxDecoration(color: Colors.white),
  decorationBuilder: (context, pageSize, page, pageImage) { ... },
)
```

---

## 16. Common Patterns & Gotchas

### ⚠️ Coordinate Confusion

- `pageOverlaysBuilder` gives `Rect pageRectInViewer` in **viewer-local**
  coordinates
- `pagePaintCallbacks` gives `Rect pageRect` in **document layout** coordinates
- `PdfRect` and `PdfPoint` are in **PDF page** coordinates (origin bottom-left)
- Always use the conversion extensions when crossing between systems

### ⚠️ sourceName Must Be Unique

When using `PdfViewer.data()`, the `sourceName` parameter must be unique for
each distinct PDF. The caching system uses it as the key. Reusing the same
`sourceName` with different data will return the cached (old) document.

### ⚠️ Text Selection Must Be Explicitly Enabled

```dart
PdfViewerParams(
  textSelectionParams: PdfTextSelectionParams(
    enableTextSelection: true,  // Off by default!
  ),
)
```

### ⚠️ Document Lifecycle

- Use `controller.useDocument()` for async operations to ensure the document
  stays alive
- Never hold a reference to `controller.document` across async gaps
- `PdfDocumentRef.resolveListenable()` returns a shared listenable — multiple
  viewers can share one document

### ⚠️ InteractiveViewer is Forked

The `InteractiveViewer` in pdfrx is a **modified fork** of Flutter's built-in
version. Key differences:

- Custom scroll physics support (`scrollPhysics` param)
- Better boundary handling for PDF content
- `onWheelDelta` callback for mouse wheel scrolling
- `scrollPhysicsScale` for zoom-aware scroll speed

### ⚠️ Matrix Operations

The `PdfViewerController` extends `ValueListenable<Matrix4>`. The matrix encodes
both position and zoom:

- `value.zoom` extracts current zoom ratio
- `value.calcPosition(viewSize)` gets center position in document coords
- `value.calcVisibleRect(viewSize)` gets visible rectangle in document coords
- Setting `controller.value = newMatrix` directly is possible but use
  `makeMatrixInSafeRange()` to clamp

### Pattern: Hit-testing a tap to find page text

```dart
// In onGeneralTap callback:
final hit = controller.getPdfPageHitTestResult(
  details.documentPosition,
  useDocumentLayoutCoordinates: true,
);
if (hit != null) {
  final pageText = await hit.page.loadText();
  if (pageText != null) {
    // Find character at hit.offset (PDF coords)
    for (int i = 0; i < pageText.charRects.length; i++) {
      if (pageText.charRects[i].containsPoint(hit.offset, margin: 3)) {
        // Found character at index i
        break;
      }
    }
  }
}
```

### Pattern: Drawing highlight rectangles on pages

```dart
pagePaintCallbacks: [
  (canvas, pageRect, page) {
    // Assuming you have PdfPageTextRange ranges to highlight
    for (final range in myRanges) {
      if (range.pageNumber != page.pageNumber) continue;
      for (final fragBounds in range.enumerateFragmentBoundingRects()) {
        final flutterRect = fragBounds.bounds.toRectInDocument(
          page: page,
          pageRect: pageRect,
        );
        canvas.drawRect(flutterRect, highlightPaint);
      }
    }
  },
],
```

### `PdfPageAnchor` Enum

Controls how `goToPage`, `goToArea`, etc. position the view:

```dart
enum PdfPageAnchor {
  top, left, right, bottom,              // Edge anchors
  topLeft, topCenter, topRight,          // Corner/center anchors
  centerLeft, center, centerRight,
  bottomLeft, bottomCenter, bottomRight,
  all,                                    // Fit entire page in view
}
```
