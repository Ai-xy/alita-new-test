import 'package:alita/http/http.dart';
import 'package:alita/model/api/anchor_model.dart';
import 'package:alita/model/api/gift_model.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/api/live_tag_model.dart';

abstract class LiveApi {
  static Future<List<LiveTagModel>?> getTags() {
    return Http.instance.post(ApiRequest('/api/index/indexTag')).then((value) {
      return LiveTagListModel.fromJson(value.data);
    }).then((value) => value.tagList);
  }

  static Future<List<AnchorModel>?> getAnchorList(
      {int currentPage = 0,
      int pageSize = 10,
      String? endTime,
      String? startTime,
      bool onlineStatus = true,
      int? tagId}) {
    return Http.instance
        .post(ApiRequest('/api/expand/wearLive/queryLiveList', formData: {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'startTime': startTime,
      'endTime': endTime,
      'onlineStatus': onlineStatus ? 1 : 0,
      'tagId': tagId
    }))
        .then((value) {
      return AnchorListModel.fromList(value.data);
    }).then((value) => value.anchorList);
  }

  static Future<List<LiveRoomModel>?> getLiveRoomList(
      {int currentPage = 0,
      int pageSize = 10,
      String? endTime,
      String? startTime,
      bool onlineStatus = true,
      int? tagId}) {
    return Http.instance
        .post(ApiRequest('/api/expand/wearLive/queryLiveList', formData: {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'startTime': startTime,
      'endTime': endTime,
      'onlineStatus': onlineStatus ? 1 : 0,
      'tagId': tagId
    }))
        .then((value) {
      return LiveRoomListModel.fromList(value.data);
    }).then((value) => value.liveRoomList);
  }

  static Future<String> getLiveStream(
      {required int id, required String password}) {
    return Http.instance
        .post(ApiRequest('/api/expand/wearLive/getPlayUrl',
            formData: {'id': id, 'password': password}))
        .then((value) => '${value.data}');
  }

  static Future<LiveRoomModel> createLiveRoom({
    required String cover,
    String? password,
    required bool isLocked,
    required String userIcon,
    required int userId,
    required String userNickname,
  }) {
    return Http.instance
        .post(ApiRequest('/api/expand/wearLive/saveLiveRoom', formData: {
          'coverImg': cover,
          'homeownerIcon': userIcon,
          'homeownerId': userId,
          'homeownerNickname': userNickname,
          'label': 'Hot',
          'liveRoomName': 'test',
          'liveState': 0,
          'lockFlag': '${isLocked ? 1 : 0}',
          'password': password,
          'sentiment': 0,
        }))
        .then((value) => LiveRoomModel.fromJson(value.data));
  }

  static Future<List<GiftModel>> getGiftList() {
    return Http.instance
        .post(ApiRequest('/api/gift/getGiftList'))
        .then((value) {
      return GiftListModel.fromList(value.data);
    }).then((value) => value.giftList);
  }

  static Future queryMyLiveRoomInfo() {
    return Http.instance.post(ApiRequest(
        '/api/expand/wearLive/queryMyRoomGiftStat',
        formData: {'searchValue': ''}));
  }
}
