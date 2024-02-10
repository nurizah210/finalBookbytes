class User {
  String? userid;
  String? useremail;
  String? username;
  String? userphone;
  String? userpass;
  String? userdatereg;
  String? useraddress;

  User(
      {this.userid,
      this.useremail,
      this.username,
      this.userphone,
      this.userpass,
      this.userdatereg,
      this.useraddress});

  User.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    useremail = json['useremail'];
    username = json['username'];
    userphone = json['userphone'];
    userpass = json['userpass'];
    userdatereg = json['userdatereg'];
    useraddress = json['useraddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['useremail'] = useremail;
    data['username'] = username;
    data['userphone'] = userphone;
    data['userpass'] = userpass;
    data['userdatereg'] = userdatereg;
    data['useraddress'] = useraddress;
    return data;
  }
}