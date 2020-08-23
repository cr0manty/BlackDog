List vouchersFromJsonList(List vouchersList) {
  List<Voucher> vouchers = [];
  vouchersList.forEach((element) {
    vouchers.add(Voucher.fromJson(element));
  });
  return vouchers;
}


class Voucher {
  int id;
  double amount;
  bool used;
  String qrCode;
  String expirationDate;
  String discount;
  String title;
  String description;

  Voucher(
      {this.qrCode,
      this.title,
      this.amount,
      this.description,
      this.discount,
      this.expirationDate,
      this.id,
      this.used = false});

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
}
