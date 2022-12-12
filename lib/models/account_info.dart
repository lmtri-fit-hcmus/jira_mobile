class AccountInfo {
  String? accountId;
  String? userName;
  String? password;

  AccountInfo({this.accountId, this.userName, this.password});

  AccountInfo.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    userName = json['userName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['userName'] = this.userName;
    data['password'] = this.password;
    return data;
  }
}