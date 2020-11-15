import 'dart:convert';

BaseVoucher baseVoucherFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return BaseVoucher.fromJson(data);
  }
  return BaseVoucher();
}

String baseVoucherToJson(BaseVoucher data) {
  final str = data.toJson();
  return json.encode(str);
}

String voucherToJson(BaseVoucher data) {
  final str = data.toJson();
  return json.encode(str);
}

class BaseVoucher {
  int id;
  String discount;

  int purchaseCount;
  int purchaseToBonus;
  String amount;
  String name;

  BaseVoucher(
      {this.name,
      this.amount,
      this.id,
      this.discount,
      this.purchaseCount,
      this.purchaseToBonus});

  factory BaseVoucher.fromJson(Map<String, dynamic> data) => BaseVoucher(
      name: data['name'] ?? '',
      amount: data['amount'] ?? '',
      id: data['id'] ?? -1,
      discount: data['discount'],
      purchaseToBonus: data['purchase_count'] ?? 10,
      purchaseCount: data['user_current_purchase_count'] ?? 0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'discount': discount,
        'user_current_purchase_count': purchaseCount,
        'purchase_count': purchaseToBonus,
        'amount': amount,
        'name': name,
      };

  int get currentStep => ((purchaseCount / purchaseToBonus) * 100).toInt();
}
