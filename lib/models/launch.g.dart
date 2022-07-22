// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Launch _$LaunchFromJson(Map<String, dynamic> json) => Launch(
      name: json['name'] as String,
      date: json['date_local'] as String,
    );

Map<String, dynamic> _$LaunchToJson(Launch instance) => <String, dynamic>{
      'name': instance.name,
      'date_local': instance.date,
    };
