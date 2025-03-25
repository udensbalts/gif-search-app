// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gif_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifModel _$GifModelFromJson(Map<String, dynamic> json) => GifModel(
      id: json['id'] as String,
      title: json['title'] as String,
      images: json['images'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$GifModelToJson(GifModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'images': instance.images,
    };
