import 'package:try2win/business/configuration.dart';
import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/models/seller.dart';

class CouponBO {
  CouponBO({
    required this.coupon,
    required this.supplier,
    required this.campaign,
  });

  final Coupon coupon;
  final Seller supplier;
  final Campaign campaign;

  String getQRCode() {
    return '${Configuration.COUPONS_CODE}=${coupon.couponId};;;${Configuration.SELLER_CODE}=${coupon.sellerId};;;${Configuration.CAMPAIGN_CODE}=${coupon.campaignId}';
  }
}
