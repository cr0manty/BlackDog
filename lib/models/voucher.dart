import 'dart:convert';

List vouchersFromJsonList(List vouchersList) {
  List<Voucher> vouchers = [];
  vouchersList.forEach((element) {
    vouchers.add(Voucher.fromJson(element));
  });
  return vouchers;
}

BaseVoucher voucherFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return BaseVoucher.fromJson(data);
  }
  return BaseVoucher();
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

class Voucher extends BaseVoucher {
  bool used;
  String qrCode;
  String expirationDate;
  String title;
  String description;

  Voucher(
      {this.qrCode,
      this.title,
      this.description,
      this.expirationDate,
      this.used = false,
      int id,
      String amount,
      String discount})
      : super(id: id, discount: discount, amount: amount);

  factory Voucher.fromStringJson(String data) {
    Map jsonData = json.decode(data);
    return Voucher.fromJson(jsonData);
  }

  factory Voucher.fromJson(Map<String, dynamic> data) => Voucher(
      qrCode: data['qr_code'],
      title: data['title'],
      amount: data['amount'],
      id: data['id'],
      expirationDate: data['expiration_date'],
      discount: data['discount'],
      used: data['used'] ?? false,
      description: data['description']);

  Map<String, dynamic> toJson() => {
        'qr_code': qrCode,
        'title': title,
        'id': id,
        'amount': amount,
        'expiration_date': expirationDate,
        'discount': discount,
        'description': description,
        'used': used
      };

  String get discountType {
    if (discount == 'percentage') {
      return '-$amount%';
    } else if (discount == 'free_item') {
      return title;
    }
    return '';
  }
}
