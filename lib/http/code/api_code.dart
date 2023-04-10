part of http;

extension $ApiCode on ApiCode {
  String get tr => name.tr;

  String trParams([Map<String, String> params = const {}]) =>
      name.trParams(params);

  bool get isError => code != ApiCode.success.code;
}

enum ApiCode {
  success(code: '0000', comment: '请求成功'),
  failed(code: '1111', comment: '请求失败'),
  paramIsError(code: '1001', comment: '参数错误'),
  tokenExpired(code: '1002', comment: '系统token过期'),
  requestOften(code: '1003', comment: '请求过于频繁'),
  unauthorized(code: '1004', comment: '请求未授权'),
  useNotExist(code: '1005', comment: '用户不存在'),
  userIsInvalid(code: '1006', comment: '用户已被封禁'),
  pathNotExist(code: '1007', comment: '请求路径不存在'),
  duplicateKey(code: '1008', comment: '重复的记录'),
  getIosPublicKeyFailed(code: '1009', comment: '获取ios公钥失败'),
  iosTokenVerifyFailed(code: '1010', comment: '校验ios登录token失败'),
  iosTokenExipred(code: '1011', comment: 'iostoken过期'),
  abnormalIosLogin(code: '1012', comment: '非正常ios登录'),
  goggleIdTokenVerifyFailed(code: '1013', comment: '谷歌登录校验失败'),
  errorTagType(code: '1014', comment: '错误的首页标签类型'),
  alreadyFollowUser(code: '1015', comment: '已经关注过该用户'),
  notFollowUser(code: '1016', comment: '没有关注该用户'),
  serverBusy(code: '1017', comment: '服务器繁忙'),
  giftNotExist(code: '1018', comment: '礼物不存在'),
  diamondNotEnough(code: '1019', comment: '钻石不足'),
  couldNotFollowYourself(code: '1020', comment: '不能关注自己'),
  errorSign(code: '1021', comment: '错误的签名'),
  emptySign(code: '1022', comment: '签名为空'),
  paramTypeError(code: '1023', comment: '请求参数类型错误'),
  userInfoAlreadyUpdate(code: '1024', comment: '用户已经完善过用户信息'),
  couldNotSendGiftToSelf(code: '1025', comment: '不能给自己送礼物'),
  deviceInfoNotExist(code: '1026', comment: '设备信息不存在'),
  osTypeNotExist(code: '1027', comment: '操作系统类型不存在'),
  transactionIdAlreadyExist(code: '1028', comment: '第三交易流水号已存在'),
  gogglePlayErrorPackageName(code: '1029', comment: '谷歌支付错误的包名'),
  gogglePlayChargeFailed(code: '1030', comment: '谷歌支付校验失败'),
  gogglePlatProductNotExist(code: '1031', comment: '谷歌商品不存在'),
  iosPayVerifyFailed(code: '1032', comment: 'ios支付校验失败'),
  transactionIdNotExist(code: '1033', comment: '第三方交易流水号不存在'),
  iosProductNotExist(code: '1034', comment: 'ios商品不存在'),
  anchorIdListIsEmpty(code: '1035', comment: '主播的id列表为空'),
  noMatchUser(code: '1036', comment: '没有匹配的用户'),
  iosOnReview(code: '1037', comment: 'ios包正在审核中'),
  aosOnReview(code: '1038', comment: '安卓包正在审核'),
  notAcceptable(code: '1039', comment: '不允许重复请求'),
  methodNotAllowed(code: '1040', comment: '请求的方法不允许'),
  errorAppId(code: '1041', comment: '错误的appId'),
  errorCode(code: '1042', comment: '错误的验证码'),
  anchorTaskNotValid(code: '1043', comment: '任务配置尚未打开'),
  appIdNotExist(code: '1044', comment: 'appid不存在'),
  nicknameAlreadyExist(code: '1045', comment: '昵称已存在'),
  emailPasswordError(code: '1046', comment: '邮箱密码错误'),
  iosPayErrorPackageName(code: '1047', comment: 'ios包名错误'),
  cannotGetVipDiamond(code: '1048', comment: '不能获取vip钻石奖励'),
  cannotGetTaskReward(code: '1049', comment: '不能获取任务奖励'),
  cannotApplyAgain(code: '1050', comment: '不能重复申请'),
  noNeedUpdate(code: '1051', comment: '已经是最新的app版本'),
  duplicateHeatbeat(code: '1052', comment: '重复的心跳'),
  iosPayAlreadySubscribe(code: '1053', comment: 'ios已经订阅'),
  iosPaySubAppleIdHasBeenBound(
      code: '1054', comment: '订阅成功，但是订阅的appleID已经被绑定，订阅产品发生再第一个订阅的用户'),
  gogglePaySubNotExist(code: '1055', comment: '谷歌订阅商品不存在'),
  goggleProductNotExist(code: '1056', comment: '谷歌商品不存在'),
  notFollowedYet(code: '1057', comment: '还未关注用户'),
  blockedRecordAlreadyExist(code: '1058', comment: '拉黑记录已经存在'),
  alreadyBeBlocked(code: '1059', comment: '已被对方拉黑'),
  alreadyBeRemovedFromBlackList(code: '1060', comment: '已经被移除出黑名'),
  messagePackageNotExist(code: '1061', comment: '消息包产品不存在'),
  cannotRepeatBuy(code: '1062', comment: '不可重复购买'),
  messagePackageInvalid(code: '1063', comment: '用户消息包已过期或者没有购买'),
  anchorTaskInfoNotExisT(code: '1064', comment: ' 未初始化主播任务信息'),
  freeChatNumNotEnough(code: '1065', comment: '免费聊天次数已经用完'),
  massCountNumNotEnough(code: '1066', comment: '群发消息次数已用完'),
  alreadyUnlockMedia(code: '1067', comment: '已经解锁过'),
  levelNotEnough(code: '1068', comment: '等级不足通话'),
  functionDisabled(code: '1069', comment: '功能关闭'),
  abandonWord(code: '1070', comment: '违规词'),
  withdrawConfigNotExist(code: '1072', comment: '提现配置不存在'),
  lessThanMinWithdrawNum(code: '1073', comment: '低于最低提现金额'),
  withdrawOften(code: '1074', comment: ' 提现过于频繁'),
  inviteCodeAlreadyExist(code: '1075', comment: '邀请码已存在'),
  inviteCodeNotExist(code: '1076', comment: '邀请码不存在'),
  alreadyBeInvited(code: '1077', comment: '已经被邀请过了'),
  vipVideoNotExist(code: '1078', comment: '系统付费视频不存在'),
  lowerAppVersion(code: '1079', comment: '低版本的app版本'),
  balanceIsNotEnough(code: '1080', comment: '余额不足'),
  ;

  final String code;

  final String comment;

  const ApiCode({
    required this.code,
    required this.comment,
  });
}

ApiCode getApiCodeByString(String code) {
  for (ApiCode item in ApiCode.values) {
    if (item.code == code) return item;
  }
  return ApiCode.success;
}
