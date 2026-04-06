import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pdfrx/pdfrx.dart';

/// A structured model for image occlusion rectangles.
/// Uses the [PdfRect] coordinate system (origin bottom-left, Y points up).
class CardOcclusion {
  final List<PdfRect> rects;

  const CardOcclusion({this.rects = const []});

  Map<String, dynamic> toJson() {
    return {
      'rects': rects
          .map((r) => {'l': r.left, 't': r.top, 'r': r.right, 'b': r.bottom})
          .toList(),
    };
  }

  factory CardOcclusion.fromJson(Map<String, dynamic> json) {
    final list = json['rects'] as List<dynamic>? ?? [];
    return CardOcclusion(
      rects: list.map((item) {
        final r = item as Map<String, dynamic>;
        return PdfRect(
          r['l'] as double,
          r['t'] as double,
          r['r'] as double,
          r['b'] as double,
        );
      }).toList(),
    );
  }
}

/// Drift converter to store [CardOcclusion] as a JSON string in the database.
class CardOcclusionConverter extends TypeConverter<CardOcclusion, String> {
  const CardOcclusionConverter();

  @override
  CardOcclusion fromSql(String fromDb) {
    return CardOcclusion.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(CardOcclusion value) {
    return json.encode(value.toJson());
  }
}
