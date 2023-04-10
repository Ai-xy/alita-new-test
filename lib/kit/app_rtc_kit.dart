// import 'package:alita/config/app_config.dart';
// import 'package:alita/local_storage/app_local_storge.dart';
// import 'package:alita/model/api/user_profile_model.dart';
// import 'package:alita/util/log.dart';
// import 'package:nertc/nertc.dart';

// class AppRtcEngineKit implements NERtcChannelEventCallback {
//   static AppRtcEngineKit? _instace;
//   static AppRtcEngineKit get instance {
//     _instace ??= AppRtcEngineKit._();
//     return _instace!;
//   }

//   AppRtcEngineKit._();

//   final NERtcEngine _engine = NERtcEngine();

//   NERtcVideoRenderer? _remoteVideoRenderer;

//   Future<int> initRtcEngine() {
//     return _engine.create(
//       appKey: AppConfig.env.neAppKey,
//       channelEventCallback: this,
//       options:
//           const NERtcOptions(audioAutoSubscribe: true, publishSelfStream: true),
//     );
//   }

//   Future<NERtcVideoRenderer> joinLiveRoom({String channelName = ''}) {
//     return initRtcEngine().catchError((err, s) {
//       Log.e('初始化engine出错', error: err, stackTrace: s);
//       throw err;
//     }).then((value) {
//       return _engine.setChannelProfile(1);
//     }).catchError((err, s) {
//       Log.e('设置直播模式出错', error: err, stackTrace: s);
//       throw err;
//     }).then((value) {
//       UserProfileModel user = UserProfileModel.fromJson(
//           AppLocalStorage.getJson(AppStorageKey.user) ?? {});
//       return _engine.joinChannel(null, channelName, user.userId ?? 0);
//     }).catchError((err, s) {
//       Log.e('加入直播间出错', error: err, stackTrace: s);
//       throw err;
//     }).then((value) {
//       return VideoRendererFactory.createVideoRenderer().then((renderer) {
//         // _remoteVideoRenderer?.dispose();
//         _remoteVideoRenderer = renderer;
//         return _engine.enableLocalVideo(true).then((value) {
//           return renderer.attachToLocalVideo();
//         }).then((value) {
//           return renderer;
//         });
//       });
//     }).catchError((err, s) {
//       Log.e('视频Render初始化错误', error: err, stackTrace: s);
//     });
//   }

//   Future leaveLiveRoom() {
//     return _engine.leaveChannel().catchError((err, s) {
//       Log.e('离开直播间出错', error: err, stackTrace: s);
//     }).then((value) {
//       return _remoteVideoRenderer?.dispose();
//     }).catchError((err, s) {
//       Log.e('释放Render出错', error: err, stackTrace: s);
//     }).then((value) {
//       return _engine.release();
//     }).catchError((err, s) {
//       Log.e('释放Engine出错', error: err, stackTrace: s);
//     });
//   }

//   Future onClose() {
//     return _engine.release();
//   }

//   @override
//   void onAudioHasHowling() {
//     // TODO: implement onAudioHasHowling
//   }

//   @override
//   void onAudioRecording(int code, String filePath) {
//     // TODO: implement onAudioRecording
//   }

//   @override
//   void onClientRoleChange(int oldRole, int newRole) {
//     // TODO: implement onClientRoleChange
//   }

//   @override
//   void onConnectionStateChanged(int state, int reason) {
//     // TODO: implement onConnectionStateChanged
//   }

//   @override
//   void onConnectionTypeChanged(int newConnectionType) {
//     // TODO: implement onConnectionTypeChanged
//   }

//   @override
//   void onDisconnect(int reason) {
//     // TODO: implement onDisconnect
//   }

//   @override
//   void onError(int code) {
//     // TODO: implement onError
//   }

//   @override
//   void onFirstAudioDataReceived(int uid) {
//     // TODO: implement onFirstAudioDataReceived
//   }

//   @override
//   void onFirstAudioFrameDecoded(int uid) {
//     // TODO: implement onFirstAudioFrameDecoded
//   }

//   @override
//   void onFirstVideoDataReceived(int uid) {
//     // TODO: implement onFirstVideoDataReceived
//   }

//   @override
//   void onFirstVideoFrameDecoded(int uid, int width, int height) {
//     // TODO: implement onFirstVideoFrameDecoded
//   }

//   @override
//   void onJoinChannel(int result, int channelId, int elapsed, int uid) {
//     // TODO: implement onJoinChannel
//   }

//   @override
//   void onLeaveChannel(int result) {
//     // TODO: implement onLeaveChannel
//   }

//   @override
//   void onLiveStreamState(String taskId, String pushUrl, int liveState) {
//     // TODO: implement onLiveStreamState
//   }

//   @override
//   void onLocalAudioVolumeIndication(int volume) {
//     // TODO: implement onLocalAudioVolumeIndication
//   }

//   @override
//   void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType) {
//     // TODO: implement onLocalPublishFallbackToAudioOnly
//   }

//   @override
//   void onMediaRelayReceiveEvent(int event, int code, String channelName) {
//     // TODO: implement onMediaRelayReceiveEvent
//   }

//   @override
//   void onMediaRelayStatesChange(int state, String channelName) {
//     // TODO: implement onMediaRelayStatesChange
//   }

//   @override
//   void onReJoinChannel(int result) {
//     // TODO: implement onReJoinChannel
//   }

//   @override
//   void onReceiveSEIMsg(int userID, String seiMsg) {
//     // TODO: implement onReceiveSEIMsg
//   }

//   @override
//   void onReconnectingStart() {
//     // TODO: implement onReconnectingStart
//   }

//   @override
//   void onRemoteAudioVolumeIndication(
//       List<NERtcAudioVolumeInfo> volumeList, int totalVolume) {
//     // TODO: implement onRemoteAudioVolumeIndication
//   }

//   @override
//   void onRemoteSubscribeFallbackToAudioOnly(
//       int uid, bool isFallback, int streamType) {
//     // TODO: implement onRemoteSubscribeFallbackToAudioOnly
//   }

//   @override
//   void onUserAudioMute(int uid, bool muted) {
//     // TODO: implement onUserAudioMute
//   }

//   @override
//   void onUserAudioStart(int uid) {
//     // TODO: implement onUserAudioStart
//   }

//   @override
//   void onUserAudioStop(int uid) {
//     // TODO: implement onUserAudioStop
//   }

//   @override
//   void onUserJoined(int uid) {
//     // TODO: implement onUserJoined
//   }

//   @override
//   void onUserLeave(int uid, int reason) {
//     // TODO: implement onUserLeave
//   }

//   @override
//   void onUserSubStreamVideoStart(int uid, int maxProfile) {
//     // TODO: implement onUserSubStreamVideoStart
//   }

//   @override
//   void onUserSubStreamVideoStop(int uid) {
//     // TODO: implement onUserSubStreamVideoStop
//   }

//   @override
//   void onUserVideoMute(int uid, bool muted) {
//     // TODO: implement onUserVideoMute
//   }

//   @override
//   void onUserVideoProfileUpdate(int uid, int maxProfile) {
//     // TODO: implement onUserVideoProfileUpdate
//   }

//   @override
//   void onUserVideoStart(int uid, int maxProfile) {
//     // TODO: implement onUserVideoStart
//   }

//   @override
//   void onUserVideoStop(int uid) {
//     // TODO: implement onUserVideoStop
//   }

//   @override
//   void onWarning(int code) {
//     // TODO: implement onWarning
//   }
// }
