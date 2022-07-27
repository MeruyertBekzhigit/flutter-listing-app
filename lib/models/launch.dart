import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'launch.g.dart';

@JsonSerializable()
class Launch {
  final String id;
  final String name;

  @JsonKey(name: 'date_local')
  final String date;

  @JsonKey(name: 'payloads')
  final List<String> payloadIds;

  const Launch(
      {required this.id,
      required this.name,
      required this.date,
      required this.payloadIds});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$LaunchFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Launch.fromJson(Map<String, dynamic> json) => _$LaunchFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$LaunchToJson`.
  Map<String, dynamic> toJson() => _$LaunchToJson(this);
}
