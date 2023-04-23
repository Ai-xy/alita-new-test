import 'dart:async';
import 'dart:io';

import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/generated/json/base/json_convert_content.dart';
import 'package:alita/http/http.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/model/api/wallet_item_entity.dart';
import 'package:alita/util/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:alita/util/log.dart';

/// 自动收费
final bool _kAutoConsume = Platform.isIOS || true;

///产品列表id
/// 正式
const List<String> _kProductIds = <String>[
  'sTHHVVqFDxhNKiCe', //1450 coins  <Apple ID： 1645862025>
  'NbffhXzpWxNJunpk', //2450 coins  <Apple ID： 1645862730>
  'vCxCJChdMBdJDtuw', //4900 coins  <Apple ID： 1645863228>
  'vjgYFjImlmmBtKtx', //9800 coins <Apple ID： 1645863250>
  'nItRLZzIDJRCGnXj', //24500 coins <Apple ID： 1645863739>
  'CSUZqqtexlsTBbPs', //49000 coins <Apple ID： 1645864060>
];
// const List<String> _kProductIds = <String>[
//   'vRaSlMftcFlQUTmD', //1450 coins  <Apple ID： 1645862025>
//   'WONrOtNGazriKfhD', //2450 coins  <Apple ID： 1645862730>
//   'uUNtbSaBzvFMyQaL', //5150 coins  <Apple ID： 1645863228>
//   'wnFInQjOCUDVrcQa', //10600 coins <Apple ID： 1645863250>
//   'mWRlIggQGObvHKtX', //27200 coins <Apple ID： 1645863739>
//   'simlUfPKnZyidHQg', //56300 coins <Apple ID： 1645864060>
// ];

class WalletController extends GetxController {
  // userEntity? user;
  UserProfileModel? get user => UserProfileModel.fromJson(
      AppLocalStorage.getJson(AppStorageKey.user) ?? {});

  int index = 0; //当前选中的充值目标

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  // 监听商品详情数据流
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  // ignore: unused_field
  List<String> _notFoundIds = <String>[];

  /// 选中的商品id（默认为第一个）
  late String selectProductId;
  var cancelFun;

  /// 商品列表
  List<ProductDetails> _products = <ProductDetails>[];

  List<ProductDetails> get products => _products;

  /// 已购买商品详情列表
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  // ignore: unused_field
  bool _isAvailable = false;
  // ignore: unused_field
  bool _purchasePending = false;
  // ignore: unused_field
  bool _loading = true;
  String? _queryProductError;
  String tag = '充值页';

  @override
  void onInit() {
    print(1111);
    super.onInit();

    selectProductId = _kProductIds[index];
    // 初始化状态变量并创建InAppPurchase对象
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      // 在购买更新流完成后，取消流的订阅
      _subscription.cancel();
    }, onError: (error) {
      // 在购买更新流中出现错误时，输出错误信息
    });
    initStoreInfo();
    init();
  }

  /// 初始化商品信息
  Future<void> initStoreInfo() async {
    Log.e('初始化商店信息', tag: '充值页');
    // 获取应用内商品信息  如果支付平台准备就绪并可用，则返回“true”
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      // 如果应用内购买不可用，则输出错误信息并退出函数
      Log.e('连接到应用内购买服务失败', tag: tag);
      AppToast.alert(message: 'Connection to in-app purchase service failed');
      _isAvailable = isAvailable;
      _products = <ProductDetails>[];
      _purchases = <PurchaseDetails>[];
      _notFoundIds = <String>[];
      _purchasePending = false;
      _loading = false;
      update();
      return;
    }
    var cancel = AppToast.loading();

    if (Platform.isIOS) {
      // iOS 的应用内购买功能。
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      // 设置 [SKPaymentQueueDelegateWrapper] 的实现。
      //[SKPaymentQueueDelegateWrapper] 可用于通知 iOS 如果 当店面发生变化或价格同意时完成交易 当订阅价格发生变化时，应显示工作表。
      //如果 没有代理注册 iOS 将回退到它的默认配置。 请参阅有关 StoreKite 的 -[SKPaymentQueue delegate:] 的文档。
      // 当设置为“null”时，支付队列委托将被删除并且 默认行为将适用（参见 documentation）。
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    /// 获取所有可购买的商品信息并保存到_products列表中
    /// queryProductDetails：
    /// 查询给定 ID 集的产品详细信息。
    /// 底层支付平台中的标识符，例如，App Store Connect 适用于 iOS 和 Google Play 控制台 适用于 Android。
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      cancel();
      AppToast.alert(message: 'Failed to load');
      // 如果获取商品信息失败，则输出错误信息并退出函数
      _queryProductError = productDetailResponse.error!.message;
      Log.e('请求商品信息失败: $_queryProductError', tag: tag);
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
      update();
      return;
    }
    Log.e(
        'productDetailResponse.productDetails:${productDetailResponse.productDetails}',
        tag: '充值页');

    /// productDetails商品信息列表不为空时
    if (productDetailResponse.productDetails.isNotEmpty) {
      cancel();
      _queryProductError = null;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
      Log.e('获取到商品详情的列表数据长度:${_products.length}', tag: '充值页');
      // 排序
      _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
      for (ProductDetails e in _products) {
        Log.e(
            '获取到商品详情数据:id:${e.id}，title:${e.title}，描述description:${e.description}，price(string):${e.price}，rawPrice:${e.rawPrice}，currencyCode:${e.currencyCode}，currencySymbol:${e.currencySymbol}',
            tag: '充值页');
      }
      update();
      return;
    }

    /// 消耗品商店。
    /// 这是一个开发原型，将耗材优先存储在共享空间中。不要在现实世界的应用程序中使用它。
    _isAvailable = isAvailable;
    _products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    _purchasePending = false;
    _loading = false;
    update();
  }

  /// 显示挂起的用户界面
  void showPendingUI() {
    _purchasePending = true;
    // 打开弹窗 显示购买中。。。/处理中。。。
    cancelFun = AppToast.loading();
    update();
  }

  /// 交付产品
  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    cancelFun();
    // 重要的！！ 在交付产品之前，请务必核实购买细节。
    if (purchaseDetails.productID == selectProductId) {
      _purchasePending = false;
      update();
    } else {
      // 把已购买商品添加到purchaseDetails列表中
      _purchases.add(purchaseDetails);
      _purchasePending = false;

      update();
    }
  }

  /// 处理错误
  void handleError(IAPError error) {
    cancelFun();
    _purchasePending = false;
    // 可以提示购买失败
    AppToast.alert(message: 'Failed purchase: ${error.message}');
    Log.e(
        '充值失败，错误原因:${error.message},code:${error.code},detail:${error.details},source:${error.source}',
        tag: '充值页面');
    update();
  }

  /// 验证购买
  /// 重要的！！ 在交付产品之前始终验证购买。
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    //测试环境跳过测试
    // return Future<bool>.value(true);

    /// 服务端检查
    // 购买的唯一id（应该是order ID？）
    String? _purchaseID = purchaseDetails.purchaseID;
    // 产品id
    String _productID = purchaseDetails.productID;
    // 用户验证购买的数据
    PurchaseVerificationData _verificationData =
        purchaseDetails.verificationData;
    // InAppPurchasePlatform.completePurchase
    Log.e(
        '验证购买的产品数据:purchaseID：$_purchaseID，productID：$_productID，购买的来源source：${_verificationData.source}，verificationData.serverVerificationData：${_verificationData.serverVerificationData}，pendingCompletePurchase${purchaseDetails.pendingCompletePurchase}',
        tag: '充值页面');
    if (_purchaseID != null) {
      return await verifyOrder(
          _verificationData.serverVerificationData, _purchaseID);
    } else {
      return Future<bool>.value(false);
    }
  }

  /// 向服务端验证订单
  Future<bool> verifyOrder(String payload, String transactionId) {
    final cp = Completer<bool>();
    UserApi.rechargePay(
      password: "", //共享密钥
      // "password": "638a2445347440d885bd38c30e9199e2", //订阅共享密钥
      payload: payload, //交易单据
      transactionId: transactionId, //交易单号
      type: "direct", //充值类型 direct：直接充值，
    )
        .then((value) => {
              Log.e('通过服务端校验', tag: '充值页面'),
              cp.complete(true),
            })
        .onError((error, stackTrace) =>
            {Log.e('未通过服务端校验，msg:$error', tag: '充值页面'), cp.complete(false)});

    return cp.future;
  }

  /// 处理无效购买
  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // 如果 _verifyPurchase` 失败，请在此处处理无效购买。
    AppToast.alert(message: 'Failed to verify purchase');
    Log.e('验证购买失败', tag: tag);
  }

  /// 监听商品购买的更新 ，并将更新添加到
  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    // 处理每一笔购买详情
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 您可以更新 UI 以让您的用户知道购买正在等待处理。
        showPendingUI();
      } else {
        cancelFun();
        Log.e('返回的PurchaseStatus:${purchaseDetails.status}', tag: '充值页面');
        if (purchaseDetails.status == PurchaseStatus.error) {
          // 购买时发生了一些错误。 购买过程中止。
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // purchased:"购买完成并成功。更新您的 UI 以指示购买已完成并交付产品。"
          //restored:"购买已恢复到设备。您应该验证购买，如果有效则交付内容。
          //一旦 内容已交付，或者如果收据无效，您应该完成 通过调用 completePurchase 方法进行购买。
          //有关更多信息 可以在 here 找到验证购买。"
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
          if (Platform.isAndroid) {
            // 对于安卓平台，需要确认购买才算完成，否则需要继续处理
            if (!_kAutoConsume &&
                purchaseDetails.productID == _products[index].id) {
              final InAppPurchaseAndroidPlatformAddition androidAddition =
                  _inAppPurchase.getPlatformAddition<
                      InAppPurchaseAndroidPlatformAddition>();
              await androidAddition.consumePurchase(purchaseDetails);
            }
          }
          if (purchaseDetails.pendingCompletePurchase) {
            // 对于其他平台，确认购买即可
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          // 购买成功并完成所有操作确认
          AppToast.alert(message: 'purchase completed');
          // fetchuser();
          // 更新外面钱包数据
          // Get.find<UserCenterController>().init();
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          AppToast.alert(message: 'cancel payment');
        }
      }
    }
  }

  /// 确认价格变动
  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (context.mounted) {
        if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Price change accepted'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              priceChangeConfirmationResult.debugMessage ??
                  'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
            ),
          ));
        }
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  // GooglePlayPurchaseDetails? _getOldSubscription(
  //     ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
  //   //这只是为了演示订阅升级或降级。
  //   //此方法假设您在一个组下只有 2 个订阅，'subscription_silver' 和 'subscription_gold'。
  //   //'subscription_silver' 订阅可以升级到 'subscription_gold' 和
  //   //'subscription_gold' 订阅可以降级为 'subscription_silver'。
  //   //请记住根据您的应用替换查找旧订阅 ID 的逻辑。
  //   //旧订阅仅在 Android 上需要，因为 Apple 会在内部处理
  //   //通过使用 iTunesConnect 中的订阅组功能。
  //   GooglePlayPurchaseDetails? oldSubscription;
  //   if (productDetails.id == _kSilverSubscriptionId &&
  //       purchases[_kGoldSubscriptionId] != null) {
  //     oldSubscription =
  //         purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
  //   } else if (productDetails.id == _kGoldSubscriptionId &&
  //       purchases[_kSilverSubscriptionId] != null) {
  //     oldSubscription =
  //         purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
  //   }
  //   return oldSubscription;
  // }

  @override
  void onReady() {
    print(1212);
    super.onReady();
  }

  @override
  void onClose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    cancelFun();

    super.onClose();
  }

  void showBanance() {}

  void init() {
    // fetchuser();
    fetchRechargeList();
  }

  // void fetchuser() {
  //   userEntity? userData;
  //   HttpUtils.post(
  //     UserApis.getuser,
  //     success: (data) => {
  //       userData = JsonConvert.fromJsonAsT(data),
  //       user = userData!,
  //       update(),
  //     },
  //   );
  // }

  void fetchRechargeList() {
    List<WalletItemEntity>? tempList;
    // HttpUtils.post(
    //   RechargeApis.getList,
    //   success: (data) => {
    //     tempList = JsonConvert.fromJsonAsT(data),
    //     if (tempList != null && tempList!.isNotEmpty)
    //       {
    //         update(),
    //       }
    //   },
    // );
    Http.instance.post(ApiRequest('/api/wallet/rechargeListV2')).then((data) {
      tempList = JsonConvert.fromJsonAsT(data);
      if (tempList != null && tempList!.isNotEmpty) {
        update();
      }
    });
  }

  /// 选中要支付的商品
  onRecharge(int index) {
    late PurchaseParam purchaseParam;
    this.index = index;
    selectProductId = _kProductIds[index];
    purchaseParam = PurchaseParam(
      productDetails: _products[index],
    );
    // 调用发起支付
    _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
    update();
  }

  // Card _buildConnectionCheckTile() {
  //   if (_loading) {
  //     return const Card(child: ListTile(title: Text('Trying to connect...')));
  //   }
  //   final Widget storeHeader = ListTile(
  //     leading: Icon(_isAvailable ? Icons.check : Icons.block,
  //         color: _isAvailable
  //             ? Colors.green
  //             : ThemeData.light().colorScheme.error),
  //     title:
  //         Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
  //   );
  //   final List<Widget> children = <Widget>[storeHeader];

  //   if (!_isAvailable) {
  //     children.addAll(<Widget>[
  //       const Divider(),
  //       ListTile(
  //         title: Text('Not connected',
  //             style: TextStyle(color: ThemeData.light().colorScheme.error)),
  //         subtitle: const Text(
  //             'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
  //       ),
  //     ]);
  //   }
  //   return Card(child: Column(children: children));
  // }

  // // 显示应用内商品的方法
  // ListView _buildListView() {
  //   final Map<String, PurchaseDetails> purchases =
  //       Map<String, PurchaseDetails>.fromEntries(
  //           _purchases.map((PurchaseDetails purchase) {
  //     if (purchase.pendingCompletePurchase) {
  //       _inAppPurchase.completePurchase(purchase);
  //     }
  //     return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
  //   }));

  //   return ListView(
  //     padding: const EdgeInsets.all(8),
  //     children: _products
  //         .map(
  //           (ProductDetails productDetails) => ListTile(
  //             title: Text(productDetails.title),
  //             subtitle: Text(productDetails.description),
  //             trailing: Text(productDetails.price),
  //             onTap: () {
  //               //  购买商品
  //               late PurchaseParam purchaseParam;

  //               if (Platform.isAndroid) {
  //                 // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
  //                 // verify the latest status of you your subscription by using server side receipt validation
  //                 // and update the UI accordingly. The subscription purchase status shown
  //                 // inside the app may not be accurate.
  //                 final GooglePlayPurchaseDetails? oldSubscription =
  //                     _getOldSubscription(productDetails, purchases);

  //                 purchaseParam = GooglePlayPurchaseParam(
  //                     productDetails: productDetails,
  //                     changeSubscriptionParam: (oldSubscription != null)
  //                         ? ChangeSubscriptionParam(
  //                             oldPurchaseDetails: oldSubscription,
  //                             prorationMode:
  //                                 ProrationMode.immediateWithTimeProration,
  //                           )
  //                         : null);
  //               } else {
  //                 purchaseParam = PurchaseParam(
  //                   productDetails: productDetails,
  //                 );
  //               }

  //               if (productDetails.id == _kConsumableId) {
  //                 _inAppPurchase.buyConsumable(
  //                     purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
  //               } else {
  //                 _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  //               }
  //             },
  //           ),
  //         )
  //         .toList(),
  //   );
  // }

  // Card _buildConsumableBox() {
  //   if (_loading) {
  //     return const Card(
  //         child: ListTile(
  //             leading: CircularProgressIndicator(),
  //             title: Text('Fetching consumables...')));
  //   }
  //   if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
  //     return const Card();
  //   }
  //   const ListTile consumableHeader =
  //       ListTile(title: Text('Purchased consumables'));
  //   final List<Widget> tokens = _consumables.map((String id) {
  //     return GridTile(
  //       child: IconButton(
  //         icon: const Icon(
  //           Icons.stars,
  //           size: 42.0,
  //           color: Colors.orange,
  //         ),
  //         splashColor: Colors.yellowAccent,
  //         onPressed: () => consume(id),
  //       ),
  //     );
  //   }).toList();
  //   return Card(
  //       child: Column(children: <Widget>[
  //     consumableHeader,
  //     const Divider(),
  //     GridView.count(
  //       crossAxisCount: 5,
  //       shrinkWrap: true,
  //       padding: const EdgeInsets.all(16.0),
  //       children: tokens,
  //     )
  //   ]));
  // }

//   /// 恢复购买
//   Widget _buildRestoreButton() {
//     if (_loading) {
//       return Container();
//     }

//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           TextButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Theme.of(Get.context!).primaryColor,
//               // (darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
//               // ignore: deprecated_member_use
//               primary: Colors.white,
//             ),

//             ///恢复所有以前的购买。
//             ///applicationUserName 应该匹配初始发送的任何内容 PurchaseParam，如果有的话。如果在初始时没有指定 applicationUserName PurchaseParam，使用null。
//             ///恢复的购买通过 [purchaseStream] 交付 [PurchaseStatus.restored] 的状态。你应该听听这些购买， 验证他们的收据，交付内容并标记购买完成 通过为每次购买调用 [finishPurchase] 方法。
//             ///这不会返回消耗的产品。如果你想恢复未使用 消耗品，需要持久化消耗品信息 在您自己的服务器上为您的用户。
//             ///也可以看看：
//             ///[refreshPurchaseVerificationData]，重新加载失败 [PurchaseDetails.verificationData]。
//             onPressed: () => _inAppPurchase.restorePurchases(),
//             child: const Text('Restore purchases'),
//           ),
//         ],
//       ),
//     );
//   }
}

/// 示例实现
///[`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc)。
///
/// 可以实现支付队列委托来提供信息
/// 需要完成交易
/// 可以实现支付队列委托来提供信息 需要完成交易。
///[SKPaymentQueueDelegateWrapper] 在 macOS 和 iOS 13+ 上可用。 使用低于 iOS 13 和 macOS 的版本将被忽略。
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  /// shouldContinueTransaction：是否继续交易
  ///
  /// 由系统调用以检查交易是否应该继续，如果 设备的 App Store 店面在交易期间发生了变化。
  /// 如果事务应在更新后继续，则返回“true” 店面（默认行为）。
  /// 如果应该取消交易，则返回“false”。在这种情况下 事务将失败并出现错误 SKErrorStoreProductNotAvailable。
  /// 请参阅 StoreKit 的 [-SKPaymentQueueDelegate shouldContinueTransaction] 中的文档。
  /// 从 SKPaymentQueueDelegateWrapper 复制。
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  /// shouldShowPriceConsent：系统调用检查是否立即显示价格 同意书。
  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
