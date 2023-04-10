import 'package:alita/http/http.dart';
import 'package:alita/model/api/dynamic_comment_model.dart';
import 'package:alita/model/api/moment_model.dart';

abstract class MomentApi {
  static Future<List<MomentModel>?> getMomentList(
      {int currentPage = 0,
      int pageSize = 10,
      String? endTime,
      String? startTime,
      bool onlineStatus = true,
      int? tagId}) {
    return Http.instance
        .post(ApiRequest(
            '/api/expand/friendsCircle/queryAnchorFriendsCircleList',
            formData: {
          'currentPage': currentPage,
          'pageSize': pageSize,
          'startTime': startTime,
          'endTime': endTime,
          'onlineStatus': onlineStatus ? 1 : 0,
          'tagId': tagId
        }))
        .then((value) {
      return MomentListModel.fromList(value.data);
    }).then((value) => value.momentList);
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

  static Future likeMoment({required String momentId, required bool like}) {
    return Http.instance.post(ApiRequest('/api/expand/friendsCircle/like',
        formData: {'id': momentId, 'optionType': like ? 1 : 0}));
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
}
