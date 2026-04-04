import 'dart:convert';
import 'package:drift/drift.dart';

class JsonListConverter<T> extends TypeConverter<List<T>, String> {
  const JsonListConverter();
  @override
  List<T> fromSql(String fromDb) => (json.decode(fromDb) as List).cast<T>();
  @override
  String toSql(List<T> value) => json.encode(value);
}
