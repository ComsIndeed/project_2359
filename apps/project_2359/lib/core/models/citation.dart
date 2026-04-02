import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

enum CitationType { text, image }

abstract class Citation {
  final CitationType type;
  final String sourceItemId;

  Citation({required this.type, required this.sourceItemId});

  Map<String, dynamic> toJson();

  factory Citation.fromJson(Map<String, dynamic> json) {
    final type = CitationType.values.byName(json['type']);
    final sourceItemId = json['sourceItemId'];
    switch (type) {
      case CitationType.text:
        return TextCitation(
          sourceItemId: sourceItemId,
          text: json['text'],
          selectionRange: json['selectionRange'] != null
              ? (
                  json['selectionRange'][0] as int,
                  json['selectionRange'][1] as int,
                )
              : null,
        );
      case CitationType.image:
        return ImageCitation(
          sourceItemId: sourceItemId,
          rect: Rect.fromLTRB(
            json['rect'][0],
            json['rect'][1],
            json['rect'][2],
            json['rect'][3],
          ),
          pageNumber: json['pageNumber'],
        );
    }
  }
}

class TextCitation extends Citation {
  final String text;
  final (int, int)? selectionRange;

  TextCitation({
    required super.sourceItemId,
    required this.text,
    this.selectionRange,
  }) : super(type: CitationType.text);

  @override
  Map<String, dynamic> toJson() => {
    'type': type.name,
    'sourceItemId': sourceItemId,
    'text': text,
    'selectionRange': selectionRange != null
        ? [selectionRange!.$1, selectionRange!.$2]
        : null,
  };
}

class ImageCitation extends Citation {
  final Rect rect;
  final int pageNumber;

  ImageCitation({
    required super.sourceItemId,
    required this.rect,
    required this.pageNumber,
  }) : super(type: CitationType.image);

  @override
  Map<String, dynamic> toJson() => {
    'type': type.name,
    'sourceItemId': sourceItemId,
    'rect': [rect.left, rect.top, rect.right, rect.bottom],
    'pageNumber': pageNumber,
  };
}

class CitationConverter extends TypeConverter<Citation, String> {
  const CitationConverter();

  @override
  Citation fromSql(String fromDb) {
    return Citation.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(Citation value) {
    return json.encode(value.toJson());
  }
}

class CitationListConverter extends TypeConverter<List<Citation>, String> {
  const CitationListConverter();

  @override
  List<Citation> fromSql(String fromDb) {
    final list = json.decode(fromDb) as List;
    return list
        .map((e) => Citation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  String toSql(List<Citation> value) {
    return json.encode(value.map((e) => e.toJson()).toList());
  }
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return (json.decode(fromDb) as List).cast<String>();
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}
