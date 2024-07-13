import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/business/ticket_bo.dart';
import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/models/ticket.dart';
import 'package:try2win/models/seller.dart';

class AppFirestore {
  final db = FirebaseFirestore.instance;

  HashMap<String, Seller> sellerMap = HashMap<String, Seller>();

  Future<Customer> getCustomer() async {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final customerRef = db
        .collection('customers')
        .where('uuid', isEqualTo: authenticatedUser.uid)
        .withConverter(
          fromFirestore: Customer.fromFirestore,
          toFirestore: (Customer customer, _) => customer.toFirestore(),
        );
    final docSnap = await customerRef.get();
    var customer = docSnap.docs.first.data();
    return customer;
  }

  Future<List<TicketBO>> getUserTickets() async {
    final customer = await getCustomer();
    final ticketsRef = db
        .collection('tickets')
        .where('customerId', isEqualTo: customer.customerId)
        .withConverter(
          fromFirestore: Ticket.fromFirestore,
          toFirestore: (Ticket ticket, _) => ticket.toFirestore(),
        );
    List<TicketBO> readTickets = [];
    final docSnap = await ticketsRef.get();
    for (var item in docSnap.docs) {
      final ticket = item.data();
      TicketBO ticketBO = TicketBO(
        ticket: ticket,
        seller: await AppFirestore().getSeller(
          ticket.sellerId,
        ),
        customer: customer,
      );
      readTickets.add(ticketBO);
    }
    return readTickets;
  }

  Future<Campaign> getCampaign(String supplierId, String campaignId) async {
    final campaignRef = db
        .collection('suppliers')
        .doc(supplierId)
        .collection('campaigns')
        .doc(campaignId)
        .withConverter(
          fromFirestore: Campaign.fromFirestore,
          toFirestore: (Campaign campaign, _) => campaign.toFirestore(),
        );
    final docSnap = await campaignRef.get();
    var campaign = docSnap.data();
    campaign ??= Campaign(title: "NotFound");
    return campaign;
  }

  Future<Seller> getSeller(String sellerId) async {
    final sellerRef = db.collection('sellers').doc(sellerId).withConverter(
          fromFirestore: Seller.fromFirestore,
          toFirestore: (Seller seller, _) => seller.toFirestore(),
        );
    if (sellerMap.containsKey(sellerId)) {
      return sellerMap[sellerId]!;
    }
    final docSnap = await sellerRef.get();
    var seller = docSnap.data();
    seller ??= Seller(title: 'Not Found');
    sellerMap[sellerId] = seller;
    return seller;
  }

  Future<List<CouponBO>> getCoupons() async {
    final customer = await getCustomer();
    List<CouponBO> readCoupons = [];
    final couponsRef = db
        .collection('coupons')
        .where('customerId', isEqualTo: customer.customerId)
        .where('used', isEqualTo: false)
        .withConverter(
          fromFirestore: Coupon.fromFirestore,
          toFirestore: (Coupon coupon, _) => coupon.toFirestore(),
        );
    final docSnap = await couponsRef.get();
    for (var item in docSnap.docs) {
      final coupon = item.data();
      coupon.couponId = item.id;
      CouponBO couponBO = CouponBO(
        coupon: coupon,
        supplier: await getSeller(coupon.sellerId),
        campaign: await getCampaign(
          coupon.sellerId,
          coupon.campaignId,
        ),
      );
      readCoupons.add(couponBO);
    }
    return readCoupons;
  }
}
