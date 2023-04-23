import 'package:alita/generated/json/base/json_convert_content.dart';
import 'package:alita/model/api/wallet_item_entity.dart';

WalletItemEntity $WalletItemEntityFromJson(Map<String, dynamic> json) {
	final WalletItemEntity walletItemEntity = WalletItemEntity();
	final int? adRewardNum = jsonConvert.convert<int>(json['adRewardNum']);
	if (adRewardNum != null) {
		walletItemEntity.adRewardNum = adRewardNum;
	}
	final String? appId = jsonConvert.convert<String>(json['appId']);
	if (appId != null) {
		walletItemEntity.appId = appId;
	}
	final String? batchNo = jsonConvert.convert<String>(json['batchNo']);
	if (batchNo != null) {
		walletItemEntity.batchNo = batchNo;
	}
	final int? diamondNum = jsonConvert.convert<int>(json['diamondNum']);
	if (diamondNum != null) {
		walletItemEntity.diamondNum = diamondNum;
	}
	final int? firstChargeGive = jsonConvert.convert<int>(json['firstChargeGive']);
	if (firstChargeGive != null) {
		walletItemEntity.firstChargeGive = firstChargeGive;
	}
	final int? giveDiamondNum = jsonConvert.convert<int>(json['giveDiamondNum']);
	if (giveDiamondNum != null) {
		walletItemEntity.giveDiamondNum = giveDiamondNum;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		walletItemEntity.icon = icon;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		walletItemEntity.id = id;
	}
	final int? originalPrice = jsonConvert.convert<int>(json['originalPrice']);
	if (originalPrice != null) {
		walletItemEntity.originalPrice = originalPrice;
	}
	final String? platformType = jsonConvert.convert<String>(json['platformType']);
	if (platformType != null) {
		walletItemEntity.platformType = platformType;
	}
	final int? price = jsonConvert.convert<int>(json['price']);
	if (price != null) {
		walletItemEntity.price = price;
	}
	final bool? recommend = jsonConvert.convert<bool>(json['recommend']);
	if (recommend != null) {
		walletItemEntity.recommend = recommend;
	}
	final int? recommendSendPercent = jsonConvert.convert<int>(json['recommendSendPercent']);
	if (recommendSendPercent != null) {
		walletItemEntity.recommendSendPercent = recommendSendPercent;
	}
	final int? vaild = jsonConvert.convert<int>(json['vaild']);
	if (vaild != null) {
		walletItemEntity.vaild = vaild;
	}
	return walletItemEntity;
}

Map<String, dynamic> $WalletItemEntityToJson(WalletItemEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['adRewardNum'] = entity.adRewardNum;
	data['appId'] = entity.appId;
	data['batchNo'] = entity.batchNo;
	data['diamondNum'] = entity.diamondNum;
	data['firstChargeGive'] = entity.firstChargeGive;
	data['giveDiamondNum'] = entity.giveDiamondNum;
	data['icon'] = entity.icon;
	data['id'] = entity.id;
	data['originalPrice'] = entity.originalPrice;
	data['platformType'] = entity.platformType;
	data['price'] = entity.price;
	data['recommend'] = entity.recommend;
	data['recommendSendPercent'] = entity.recommendSendPercent;
	data['vaild'] = entity.vaild;
	return data;
}