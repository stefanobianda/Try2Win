class Purchase {
  Purchase(this.purchaseId, this.userId, this.supplierId, this.campaignId,
      this.issuedAt);

  final String purchaseId;
  final String userId;
  final String supplierId;
  final String campaignId;
  final DateTime issuedAt;
}
