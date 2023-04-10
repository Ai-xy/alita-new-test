class OssCredentialsModel {
  String? statusCode;
  String? accessKeyId;
  String? accessKeySecret;
  String? securityToken;
  String? expiration;

  OssCredentialsModel.fromJson(Map json) {
    statusCode = json['StatusCode'];
    accessKeyId = json['AccessKeyId'];
    accessKeySecret = json['AccessKeySecret'];
    securityToken = json['SecurityToken'];
    expiration = json['Expiration'];
  }
}
