import 'package:json_annotation/json_annotation.dart';

/// Determines which AI verification route is used for a Place.
@JsonEnum(fieldRename: FieldRename.snake)
enum SpaceType {
  outdoorArtificial,
  outdoorNatural,
  indoorArtificial,
  indoorNatural,
}
