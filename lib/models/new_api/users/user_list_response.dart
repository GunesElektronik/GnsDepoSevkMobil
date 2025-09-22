class UserListResponse {
  String? userId;
  String? code;
  String? name;
  String? surname;
  String? userName;

  UserListResponse(
      {this.userId, this.code, this.name, this.surname, this.userName});

  UserListResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    code = json['code'];
    name = json['name'];
    surname = json['surname'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['userName'] = this.userName;
    return data;
  }
}
