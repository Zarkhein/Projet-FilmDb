// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Film _$FilmFromJson(Map<String, dynamic> json) => Film()
  ..title = json['title'] as String
  ..year = json['year'] as String
  ..imdbID = json['imdbID'] as String
  ..type = json['type'] as String
  ..poster = json['poster'] as String
  ..Search = (json['Search'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$FilmToJson(Film instance) => <String, dynamic>{
      'title': instance.title,
      'year': instance.year,
      'imdbID': instance.imdbID,
      'type': instance.type,
      'poster': instance.poster,
      'Search': instance.Search,
    };
