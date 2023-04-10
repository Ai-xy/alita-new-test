import 'package:alita/event_bus/events/base/app_event.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class AppPurchaseEvent extends AppEvent {
  final List<PurchaseDetails> purchaseDetailsList;
  AppPurchaseEvent({required this.purchaseDetailsList});
}
