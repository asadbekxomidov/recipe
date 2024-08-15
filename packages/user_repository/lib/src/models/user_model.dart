import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';


@JsonSerializable()


class UserModel {
  String id;
  String name;
  String email;
  String imageUrl;
  String bio;
  List<String> likedReceiptsId;
  List<String> savedReceiptsId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.bio,
    required this.likedReceiptsId,
    required this.savedReceiptsId,
  });



  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserModelToJson(this);
  }
}
