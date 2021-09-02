class UserInfoModel {
  int id;
  String fName;
  String lName;
  String email;
  String image;
  int isPhoneVerified;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String emailVerificationToken;
  String phone;
  String cmFirebaseToken;
  String password;
  int orderCount;
  int memberSinceDays;

  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.emailVerificationToken,
        this.phone,
        this.password,
        this.orderCount,
        this.memberSinceDays,
        this.cmFirebaseToken});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    password = json['password'];
    cmFirebaseToken = json['cm_firebase_token'];
    orderCount = json['order_count'];
    memberSinceDays = json['member_since_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email_verification_token'] = this.emailVerificationToken;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    data['order_count'] = this.orderCount;
    data['member_since_days'] = this.memberSinceDays;
    return data;
  }
}
