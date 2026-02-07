import 'dart:typed_data';

/// Utility class for source file operations.
/// Uses platform-agnostic types (Uint8List, String) for web compatibility.
class SourceUtils {
  /// Converts a PPTX file to PDF.
  /// [fileBytes] - The raw bytes of the pptx file.
  /// Returns a Future containing the PDF bytes.
  static Future<Uint8List> pptxToPdf(Uint8List fileBytes) async {
    throw UnimplementedError();
  }

  /// Converts a DOCX file to PDF.
  /// [fileBytes] - The raw bytes of the docx file.
  /// Returns a Future containing the PDF bytes.
  static Future<Uint8List> docxToPdf(Uint8List fileBytes) async {
    throw UnimplementedError();
  }

  /// Converts an XLSX file to PDF.
  /// [fileBytes] - The raw bytes of the xlsx file.
  /// Returns a Future containing the PDF bytes.
  static Future<Uint8List> xlsxToPdf(Uint8List fileBytes) async {
    throw UnimplementedError();
  }

  /// Extracts text content from a PDF.
  /// [fileBytes] - The raw bytes of the PDF file.
  /// Returns a Future containing the extracted text.
  static Future<String> extractTextFromPdf(Uint8List fileBytes) async {
    throw UnimplementedError();
  }
}
