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
}
