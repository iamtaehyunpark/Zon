import 'package:json_annotation/json_annotation.dart';

/// Category of a Badge, used to determine award logic.
@JsonEnum(fieldRename: FieldRename.snake)
enum BadgeType {
  placeSignature,
  seasonal,
  pioneer,
  founder,
  confirmer,
  quest,
  brand,
}
