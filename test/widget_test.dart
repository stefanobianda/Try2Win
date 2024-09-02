// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:try2win/business/coupon_bo.dart';

import 'package:try2win/models/campaign.dart';
import 'package:try2win/models/coupon.dart';
import 'package:try2win/models/seller.dart';
import 'package:try2win/widgets/coupons_list.dart';

void main() {
  testWidgets('CouponList widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CouponsList(
          couponsList: [
            CouponBO(
                campaign: Campaign(
                    campaignId: "campaignId",
                    createdAt: Timestamp.now(),
                    name: "Pippo Pluto"),
                coupon: Coupon(
                    sellerId: "sellerId",
                    customerId: "customerId",
                    campaignId: "campaignId",
                    value: 50,
                    issuedAt: Timestamp.now(),
                    used: false),
                supplier: Seller(
                  title: 'SellerX',
                  ticketLimit: 10,
                ))
          ],
        ),
      ),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('Pippo Pluto'), findsOneWidget);
  });
}
