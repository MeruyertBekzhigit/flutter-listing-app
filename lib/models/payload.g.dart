// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payload _$PayloadFromJson(Map<String, dynamic> json) => Payload(
      name: json['name'] as String? ?? "",
      type: json['type'] as String? ?? "",
    );

Map<String, dynamic> _$PayloadToJson(Payload instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
    };
