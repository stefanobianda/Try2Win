import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:try2win/business/campaign_bo.dart';
import 'package:try2win/business/coupon_bo.dart';
import 'package:try2win/business/ticket_bo.dart';
import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/models/customer.dart';
import 'package:try2win/models/quota.dart';
import 'package:try2win/models/ticket.dart';
import 'package:try2win/models/seller.dart';

class AppFirestore {
  final db = FirebaseFirestore.instance;

  HashMap<String, Seller> sellerMap = HashMap<String, Seller>();

  Future<Customer> getCustomer() async {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return getCustomerByUser(authenticatedUser);
  }

  Future<Customer> getCustomerByUser(User authenticatedUser) async {
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

  createCustomerByUser(User authenticatedUser) async {
    final data = db.collection('customers').doc();
    await data.set({
      'uuid': authenticatedUser.uid,
      'customerId': data.id,
    });
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

  Future<List<TicketBO>> getSellerTickets() async {
    final customer = await getCustomer();
    final ticketsRef = db
        .collection('tickets')
        .where('sellerId', isEqualTo: customer.sellerId)
        .orderBy('createdAt')
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

  Future<int> getSellerTicketsCount() async {
    final customer = await getCustomer();
    final countSnapshotRef = db
        .collection('tickets')
        .where('sellerId', isEqualTo: customer.sellerId)
        .count();
    final docSnap = await countSnapshotRef.get();
    int count = 0;
    if (docSnap.count != null) {
      count = docSnap.count!;
    }
    return count;
  }

  Future<Campaign> getCampaign(String sellerId, String campaignId) async {
    final campaignRef = db
        .collection('sellers')
        .doc(sellerId)
        .collection('campaigns')
        .doc(campaignId)
        .withConverter(
          fromFirestore: Campaign.fromFirestore,
          toFirestore: (Campaign campaign, _) => campaign.toFirestore(),
        );
    final docSnap = await campaignRef.get();
    var campaign = docSnap.data();
    campaign ??= Campaign(
      name: "NotFound",
      createdAt: Timestamp.now(),
      campaignId: '',
    );
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
    seller ??=
        Seller(title: 'Not Found', isProcessing: false, ticketLimit: 1000);
    sellerMap[sellerId] = seller;
    return seller;
  }

  Future<Ticket> getTicket(String tickedId) async {
    final ticketRef = db.collection('tickets').doc(tickedId).withConverter(
          fromFirestore: Ticket.fromFirestore,
          toFirestore: (Ticket ticket, _) => ticket.toFirestore(),
        );
    final docSnap = await ticketRef.get();
    var ticket = docSnap.data();
    ticket ??= Ticket(
        ticketId: '', customerId: '', sellerId: '', createdAt: Timestamp.now());
    return ticket;
  }

  Future<List<CouponBO>> getCoupons(Customer? customer, bool all) async {
    customer ??= await getCustomer();
    List<CouponBO> readCoupons = [];
    var couponsRef = db
        .collection('customers')
        .doc(customer.customerId)
        .collection('coupons')
        .where('used', isEqualTo: false)
        .withConverter(
          fromFirestore: Coupon.fromFirestore,
          toFirestore: (Coupon coupon, _) => coupon.toFirestore(),
        );
    if (all) {
      couponsRef = db
          .collection('customers')
          .doc(customer.customerId)
          .collection('coupons')
          .withConverter(
            fromFirestore: Coupon.fromFirestore,
            toFirestore: (Coupon coupon, _) => coupon.toFirestore(),
          );
    }
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

  Future<List<CampaignBO>> getCampaigns(Customer? customer) async {
    customer ??= await getCustomer();
    List<CampaignBO> readCampaigns = [];
    var campaignsRef = db
        .collection('sellers')
        .doc(customer.sellerId)
        .collection('campaigns')
        .withConverter(
          fromFirestore: Campaign.fromFirestore,
          toFirestore: (Campaign campaign, _) => campaign.toFirestore(),
        );
    final docSnap = await campaignsRef.get();
    for (var item in docSnap.docs) {
      final campaign = item.data();
      CampaignBO campaignBO = CampaignBO(
        campaign: campaign,
      );
      readCampaigns.add(campaignBO);
    }
    return readCampaigns;
  }

  Future<void> processTicket(customerId, sellerId) async {
    final data = db.collection('tickets').doc();
    await data.set({
      'ticketId': data.id,
      'customerId': customerId,
      'sellerId': sellerId,
      'createdAt': Timestamp.now(),
    });
    final snapshot = await db
        .collection('tickets')
        .where('sellerId', isEqualTo: sellerId)
        .count()
        .get();
    if (snapshot.count != null && snapshot.count! >= 10) {
      final seller = await getSeller(sellerId);
      if (!seller.isProcessingCampaign()) {
        setSellerProcessing(sellerId, true);
        await processNewWin(sellerId);
        setSellerProcessing(sellerId, false);
      }
    }
  }

  Future<void> processCoupon(String customerId, String couponId,
      String sellerId, String campaignId) async {
    db
        .collection('customers')
        .doc(customerId)
        .collection('coupons')
        .doc(couponId)
        .update({
      'used': true,
      'usedAt': Timestamp.now(),
    });
  }

  Future<void> processNewWin(sellerId) async {
    final sellerRef = db
        .collection('tickets')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: false)
        .withConverter(
          fromFirestore: Ticket.fromFirestore,
          toFirestore: (Ticket ticket, _) => ticket.toFirestore(),
        );
    final docSnap = await sellerRef.get();
    List<Ticket> ticketList = [];
    List<Ticket> winnerList = [];
    int count = 0;
    for (var item in docSnap.docs) {
      if (count++ < 10) {
        Ticket ticket = item.data();
        ticketList.add(ticket);
      }
    }
    winnerList.add(ticketList[Random().nextInt(10)]);
    winnerList.add(ticketList[Random().nextInt(10)]);
    winnerList.add(ticketList[Random().nextInt(10)]);
    winnerList.shuffle();
    Ticket winner = winnerList[0];
    final fromRef = db.collection('tickets');
    final toRef =
        db.collection('sellers').doc(sellerId).collection('campaigns').doc();
    await toRef.set({
      'createdAt': Timestamp.now(),
      'campaignId': toRef.id,
      'name': RandomNames(Zone.us).fullName(),
    });
    for (Ticket ticket in ticketList) {
      toRef
          .collection('tickets')
          .doc(ticket.ticketId)
          .set(ticket.toFirestore());
      fromRef.doc(ticket.ticketId).delete();
    }
    toRef.collection('winner').add(winner.toFirestore());
    final winRef = db
        .collection('customers')
        .doc(winner.customerId)
        .collection('coupons')
        .doc();
    winRef.set(Coupon(
            sellerId: sellerId,
            customerId: winner.customerId,
            campaignId: toRef.id,
            value: 50,
            issuedAt: Timestamp.now(),
            used: false)
        .toFirestore());
  }

  void setSellerProcessing(sellerId, bool isProcessing) {
    db
        .collection('sellers')
        .doc(sellerId)
        .update({'isProcessing': isProcessing});
  }

  Future<Quota> getSellerCampaignCurrentQuota() async {
    Customer customer = await getCustomer();
    final quotaRef = db
        .collection('sellers')
        .doc(customer.sellerId)
        .collection('quotas')
        .doc('current')
        .withConverter(
            fromFirestore: Quota.fromFirestore,
            toFirestore: (Quota quota, _) => quota.toFirestore());
    final docSnap = await quotaRef.get();
    Quota currentQuota = Quota(
        quota: 1000, renumeration: 100, value: 50, createdAt: Timestamp.now());
    if (docSnap.exists) {
      currentQuota = docSnap.data()!;
      print("reead current quota ${currentQuota.quota}");
    }
    return currentQuota;
  }

  Future<void> setQuota(Quota quota) async {
    Customer customer = await getCustomer();
    db
        .collection('sellers')
        .doc(customer.sellerId)
        .collection('quotas')
        .add(quota.toFirestore());
  }

  getSellerCampaignQuota() async {
    Customer customer = await getCustomer();
    final quotaRef = db
        .collection('sellers')
        .doc(customer.sellerId)
        .collection('quotas')
        .orderBy('createdAt', descending: true)
        .withConverter(
            fromFirestore: Quota.fromFirestore,
            toFirestore: (Quota quota, _) => quota.toFirestore());
    final docSnap = await quotaRef.get();
    Quota lastQuota = Quota(
        quota: 1000, renumeration: 100, value: 50, createdAt: Timestamp.now());
    if (docSnap.docs.isNotEmpty) {
      print("reead last quota");
      lastQuota = docSnap.docs.first.data();
      print("reead last quota ${lastQuota.quota}");
    }
    return lastQuota;
  }
}
