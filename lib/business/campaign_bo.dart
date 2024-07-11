import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/purchase.dart';
import 'package:try2win/models/supplier.dart';

class CampaignBO {
  CampaignBO({
    required this.purchase,
    required this.supplier,
    required this.campaign,
  });

  final Purchase purchase;
  final Supplier supplier;
  final Campaign campaign;
}
