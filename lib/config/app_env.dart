enum AppEnv {
  dev(
    neAppKey: '124f689baed25c488e1330bc42e528af',
    neAppSecret: '20d46b6740b0',
    baseUrl: 'http://8.134.216.253:8000',
    appId: '58426639',
    imgUrl: 'https://app-bucket-test.oss-cn-guangzhou.aliyuncs.com/',
    pushToken: 'KLSD9372ID90239DJ28YTY753',
  ),
  test(
    neAppKey: '124f689baed25c488e1330bc42e528af',
    neAppSecret: '',
    baseUrl: '',
    appId: '',
    imgUrl: 'https://app-bucket-test.oss-cn-guangzhou.aliyuncs.com/',
    pushToken: '',
  ),
  pro(
    neAppKey: '',
    neAppSecret: '',
    baseUrl: '',
    appId: '',
    imgUrl: '',
    pushToken: '',
  ),
  ;

  ///网易云信配置
  final String neAppKey;
  final String neAppSecret;
  final String baseUrl;
  final String appId;
  final String imgUrl;
  final String pushToken;
  const AppEnv({
    required this.neAppKey,
    required this.neAppSecret,
    required this.baseUrl,
    required this.appId,
    required this.imgUrl,
    required this.pushToken,
  });
}
