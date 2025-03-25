import 'package:json_annotation/json_annotation.dart';

part 'gif_model.g.dart';

@JsonSerializable()
class GifModel {
  final String id;
  final String title;
  @JsonKey(name: 'images')
  final Map<String, dynamic> images;

  GifModel({
    required this.id,
    required this.title,
    required this.images,
  });

  String get previewUrl => images['preview_gif']['url'];
  String get fullSizeUrl => images['original']['url'];

  factory GifModel.fromJson(Map<String, dynamic> json) =>
      _$GifModelFromJson(json);
  Map<String, dynamic> toJson() => _$GifModelToJson(this);
}
