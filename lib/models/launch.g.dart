// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Launch _$LaunchFromJson(Map<String, dynamic> json) => Launch(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date_local'] as String,
      payloads:
          (json['payloads'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LaunchToJson(Launch instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'payloads': instance.payloads,
      'date_local': instance.date,
    };
