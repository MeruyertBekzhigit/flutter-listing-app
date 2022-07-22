import 'package:json_annotation/json_annotation.dart';

part 'payload.g.dart';

@JsonSerializable()
class Payload {
  final String name;
  final String type;

  const Payload({required this.name, required this.type});

  factory Payload.fromJson(Map<String, dynamic> json) =>
      _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}
