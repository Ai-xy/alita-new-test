import 'package:alita/generated/json/base/json_field.dart';
import 'package:alita/generated/json/wallet_item_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class WalletItemEntity {
	int? adRewardNum;
	String? appId;
	String? batchNo;
	int? diamondNum;
	int? firstChargeGive;
	int? giveDiamondNum;
	String? icon;
	int? id;
	int? originalPrice;
	String? platformType;
	int? price;
	bool? recommend;
	int? recommendSendPercent;
	int? vaild;

	WalletItemEntity();

	factory WalletItemEntity.fromJson(Map<String, dynamic> json) => $WalletItemEntityFromJson(json);

	Map<String, dynamic> toJson() => $WalletItemEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}