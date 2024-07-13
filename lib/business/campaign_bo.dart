import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/ticket.dart';
import 'package:try2win/models/seller.dart';

class CampaignBO {
  CampaignBO({
    required this.purchase,
    required this.supplier,
    required this.campaign,
  });

  final Ticket purchase;
  final Seller supplier;
  final Campaign campaign;
}
