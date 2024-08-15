import 'package:equatable/equatable.dart';

class UserAuth extends Equatable {
  final String? idToken;
  final String? email;
  final String? localId;

  const UserAuth({
    required this.idToken,
    required this.email,
    required this.localId,
  });

  @override
  List<Object> get props => [];

  static const empty = UserAuth(
    idToken: '',
    email: '',
    localId: '',
  );

  factory UserAuth.fromList(List<dynamic> json, String? idToken) {
    return UserAuth(
      idToken: idToken?? "",
      email: json.first['email']??"",
      localId: json.first['localId']??"",
    );
  }

  factory UserAuth.fromJson(Map<String,dynamic> json){
      return UserAuth(
      idToken: json["idToken"]?? "",
      email: json['email'] ?? "",
      localId: json['localId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken??"",
      'email': email??"",
      'localId': localId??"",
    };
  }
}

