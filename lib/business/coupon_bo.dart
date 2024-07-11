import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/models/supplier.dart';

class CouponBO {
  CouponBO({
    required this.coupon,
    required this.supplier,
    required this.campaign,
  });

  final Coupon coupon;
  final Supplier supplier;
  final Campaign campaign;
}
