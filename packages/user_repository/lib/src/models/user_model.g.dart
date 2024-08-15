// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl']==null?"": json['imageUrl'] as String,
      bio: json['bio']==null?"":json['bio'] as String,
      likedReceiptsId: json['likedReceiptsId']==null?[]: (json['likedReceiptsId'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      savedReceiptsId:json['savedReceiptsId'] ==null?[]: (json['savedReceiptsId'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'bio': instance.bio,
      'likedReceiptsId': instance.likedReceiptsId,
      'savedReceiptsId': instance.savedReceiptsId,
    };
