import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerViewNotifier extends StateNotifier<bool> {
  SellerViewNotifier() : super(true);

  void setSellerView(bool sellerView) {
    state = sellerView;
  }

  bool isSellerView() {
    return state;
  }
}

final isSellerViewProvider = StateNotifierProvider<SellerViewNotifier, bool>(
  (ref) => SellerViewNotifier(),
);
