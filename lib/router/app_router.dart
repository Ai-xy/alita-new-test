import 'package:alita/pages/about_us/about_us_binding.dart';
import 'package:alita/pages/about_us/about_us_page.dart';
import 'package:alita/pages/anchor_center/anchor_center_binding.dart';
import 'package:alita/pages/anchor_center/anchor_center_page.dart';
import 'package:alita/pages/anchor_live_end/anchor_live_end_page.dart';
import 'package:alita/pages/anchor_profile/anchor_profile_binding.dart';
import 'package:alita/pages/anchor_profile/anchor_profile_page.dart';
import 'package:alita/pages/block_list/block_list_binding.dart';
import 'package:alita/pages/block_list/block_list_page.dart';
import 'package:alita/pages/chat/chat_binding.dart';
import 'package:alita/pages/chat/chat_page.dart';
import 'package:alita/pages/edit_profile/edit_profile_page.dart';
import 'package:alita/pages/feedback/feedback_binding.dart';
import 'package:alita/pages/feedback/feedback_page.dart';
import 'package:alita/pages/follow/create_moments/create_moments_binding.dart';
import 'package:alita/pages/forget_password/forget_password_binding.dart';
import 'package:alita/pages/forget_password/forget_password_page.dart';
import 'package:alita/pages/home/home_binding.dart';
import 'package:alita/pages/home/home_page.dart';
import 'package:alita/pages/live_data/live_data_binding.dart';
import 'package:alita/pages/live_data/live_data_page.dart';
import 'package:alita/pages/anchor_live_end/anchor_live_end_binding.dart';
import 'package:alita/pages/live_room/live_room_binding.dart';
import 'package:alita/pages/live_room/live_room_page.dart';
import 'package:alita/pages/live_stream_end/live_stream_end_binding.dart';
import 'package:alita/pages/live_stream_end/live_stream_end_page.dart';
import 'package:alita/pages/login/login_binding.dart';
import 'package:alita/pages/login/login_page.dart';
import 'package:alita/pages/my_live_room/my_live_room_binding.dart';
import 'package:alita/pages/my_live_room/my_live_room_page.dart';
import 'package:alita/pages/session_list/session_list_binding.dart';
import 'package:alita/pages/session_list/session_list_page.dart';
import 'package:alita/pages/my_following/my_following_binding.dart';
import 'package:alita/pages/my_following/my_following_page.dart';
import 'package:alita/pages/photo_viewer/photo_viewer_page.dart';
import 'package:alita/pages/register/register_binding.dart';
import 'package:alita/pages/register/register_page.dart';
import 'package:alita/pages/set_my_signature/set_my_signature_page.dart';
import 'package:alita/pages/set_profile/set_profile_binding.dart';
import 'package:alita/pages/set_profile/set_profile_page.dart';
import 'package:alita/pages/start_live/start_live_binding.dart';
import 'package:alita/pages/start_live/start_live_page.dart';
import 'package:alita/pages/vip/vip_page.dart';
import 'package:alita/pages/wallet/wallet_binding.dart';
import 'package:alita/pages/wallet/wallet_page.dart';
import 'package:get/get.dart';

import '../pages/follow/create_moments/create_moments_view.dart';
import 'app_path.dart';
import 'middlewares/auth_middleware.dart';

abstract class AppRouter {
  static final pages = [
    GetPage(
      name: AppPath.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppPath.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppPath.forgetPassword,
      page: () => const ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: AppPath.setProfile,
      page: () => const SetProfilePage(),
      binding: SetProfileBinding(),
    ),
    GetPage(
        name: AppPath.home,
        page: () => const HomePage(),
        binding: HomeBinding(),
        middlewares: [
          AuthMiddleware(),
        ]),
    GetPage(
      name: AppPath.startLive,
      page: () => const StartLivePage(),
      binding: StartLiveBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppPath.liveRoom,
      page: () => LiveRoomPage(),
      binding: LiveRoomBinding(),
    ),
    GetPage(
      name: AppPath.aboutUs,
      page: () => const AboutUsPage(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: AppPath.editProfile,
      page: () =>  EditProfilePage(),
    ),
    GetPage(
      name: AppPath.setMySignature,
      page: () => const SetMySignaturePage(),
    ),
    GetPage(
      name: AppPath.myFollowing,
      page: () => const MyFollowingPage(),
      binding: MyFollowingBinding(),
    ),
    GetPage(
      name: AppPath.feedback,
      page: () => const FeedbackPage(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: AppPath.sessionList,
      page: () =>  SessionListPage(),
      binding: SessionListBinding(),
    ),
    GetPage(
      name: AppPath.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppPath.myLiveRoom,
      page: () => const MyLiveRoomPage(),
      binding: MyLiveRoomBinding(),
    ),
    GetPage(
      name: AppPath.vip,
      page: () => const VipPage(),
    ),
    GetPage(
      name: AppPath.wallet,
      page: () => const WalletPage(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppPath.anchorCenter,
      binding: AnchorCenterBinding(),
      page: () => const AnchorCenterPage(),
    ),
    GetPage(
      name: AppPath.liveData,
      binding: LiveDataBinding(),
      page: () => const LiveDataPage(),
    ),
    GetPage(
      name: AppPath.blockList,
      binding: BlockListBinding(),
      page: () => const BlockListPage(),
    ),
    GetPage(
      name: AppPath.anchorLiveEnd,
      binding: AnchorLiveEndBinding(),
      page: () => const AnchorLiveEndPage(),
    ),
    GetPage(
      name: AppPath.liveStreamEnd,
      binding: LiveStreamEndBinding(),
      page: () => const LiveStreamEndPage(),
    ),
    GetPage(
      name: AppPath.anchorProfile,
      binding: AnchorProfileBinding(),
      page: () => const AnchorProfilePage(),
    ),
    GetPage(
      name: AppPath.addMoments,
      page: () => const CreateMomentsView(),
      binding: CreateMomentsBinding(),
    ),
  ];
}
