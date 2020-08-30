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
  String discount = '';

  int purchaseCount = 0;
  int purchaseToBonus = 10;
  String baseAmount = '';
  String name = '';

  BaseVoucher(
      {this.name,
      this.baseAmount,
      this.id,
      this.discount,
      this.purchaseCount,
      this.purchaseToBonus});

  factory BaseVoucher.fromJson(Map<String, dynamic> data) => BaseVoucher(
      name: data['name'],
      baseAmount: data['amount'],
      id: data['id'],
      discount: data['discount'],
      purchaseToBonus: data['purchase_count'],
      purchaseCount: data['user_current_purchase_count']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'discount': discount,
        'user_current_purchase_count': purchaseCount,
        'purchase_count': purchaseToBonus,
        'amount': baseAmount,
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
  double amount;

  Voucher(
      {this.qrCode,
      this.title,
      this.description,
      this.expirationDate,
      this.used = false,
      this.amount,
      int id,
      String discount})
      : super(id: id, discount: discount);

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
      return '-${amount.toInt()}%';
    } else if (discount == 'free_item') {
      return title;
    }
    return '';
  }
}
