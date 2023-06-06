import 'package:alita/http/http.dart';
import 'package:alita/model/api/dynamic_comment_model.dart';
import 'package:alita/model/api/moment_model.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';

abstract class MomentApi {
  static Future<List<MomentModel>?> getMomentList(
      {int currentPage = 0,
      int pageSize = 10,
      String? endTime,
      String? startTime,
      String? userId,
      bool onlineStatus = true,
      int? tagId}) {
    return Http.instance
        .post(ApiRequest(
            '/api/expand/friendsCircle/queryAnchorFriendsCircleList',
            formData: {
          "currentPage": currentPage,
          "endTime": endTime,
          "keyword": userId,
          "pageSize": pageSize,
          "startTime": startTime,
          'onlineStatus': onlineStatus ? 1 : 0,
        }))
        // "userType": 1

        // .post(ApiRequest(
        // '/api/expand/friendsCircle/queryAnchorFriendsCircleList',
        // formData: {
        //   'currentPage': currentPage,
        //   'pageSize': pageSize,
        //   'startTime': startTime,
        //   'endTime': endTime,
        //   'onlineStatus': onlineStatus ? 1 : 0,
        //   'tagId': tagId
        // }))
        .then((value) {
      print('获取朋友圈');
      print(value);
      return MomentListModel.fromList(value.data);
      //     {
      //   'currentPage': currentPage,
      //   'pageSize': pageSize,
      //   'startTime': startTime,
      //   'endTime': endTime,
      //   'onlineStatus': onlineStatus ? 1 : 0,
      //   'tagId': tagId
      //       "currentPage": 0,
      //       "endTime": "",
      //       "keyword": "",
      //       "pageSize": 10,
      //       "startTime": "",
      //       "userType": 1
      // }
    }).then((value) => value.momentList);
  }

  static Future<List<MomentModel>?> getMyMomentList(
      {int currentPage = 0,
      int pageSize = 10,
      String? endTime,
      String? startTime,
      bool onlineStatus = true,
      int? tagId}) {
    return Http.instance
        .post(ApiRequest('/api/expand/friendsCircle/queryList', formData: {
      "currentPage": 0,
      "endTime": "",
      "keyword": "",
      "onlyImgFlag": 0,
      "pageSize": 100,
      "startTime": ""
    }))
        .then((value) {
      print('获取我的朋友圈');
      print(value);
      return MomentListModel.fromList(value.data);
    }).then((value) => value.momentList);
  }

  static Future addMoments({List<String?>? imgList, String? txt}) {
    return Http.instance
        .post(ApiRequest('/api/expand/friendsCircle/create', formData: {
      "displayRange": 1,
      "imgUrls": imgList,
      "textContent": txt
    }))
        .then((value) {
      AppToast.alert(message: '${value.message}');
    });
  }

  static Future<List<DynamicCommentModel>?> getCommentList(
      {int currentPage = 0,
      int pageSize = 10,
      String? endTime,
      String? startTime,
      required String momentId}) {
    return Http.instance
        .post(ApiRequest('/api/expand/friendsCircle/getComments', formData: {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'startTime': startTime,
      'endTime': endTime,
      'keyword': momentId,
    }))
        .then((value) {
      return DynamicCommentListModel.fromList(value.data);
    }).then((value) => value.commentList);
  }

  static Future likeMoment({required String momentId, required int like}) {
    return Http.instance.post(ApiRequest('/api/expand/friendsCircle/like',
        formData: {'id': momentId, 'optionType': like}));
  }

  static Future comment(
      {required String content,
      required String momentId,
      int? parentCommentId}) {
    return Http.instance
        .post(ApiRequest('/api/expand/friendsCircle/comment', formData: {
      'friendsCircleId': momentId,
      'commentContent': content,
      if (parentCommentId != null) 'parentCommentId': parentCommentId
    }));
  }

  static Future delete(String id) {
    return Http.instance.post(ApiRequest('/api/expand/friendsCircle/del',
        formData: {"searchValue": id}));
  }
}
