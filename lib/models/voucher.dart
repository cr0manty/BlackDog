import 'dart:convert';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';

import 'base_voucher.dart';

Future vouchersFromJsonList(List vouchersList) async {
  List<Voucher> vouchers = [];
  await Future.wait(vouchersList.map((element) async {
    Voucher voucher = Voucher.fromJson(element);
    await voucher.saveQrCode();
    vouchers.add(voucher);
  }));
  SharedPrefs.saveActiveVoucher(vouchers);
}

Voucher voucherFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return Voucher.fromJson(data);
  }
  return Voucher();
}

class Voucher extends BaseVoucher {
  bool used;
  String qrCode;
  String qrCodeLocal;
  String expirationDate;
  String title;
  String description;

  Voucher(
      {this.qrCode,
      this.title,
      this.description,
      this.expirationDate,
      this.qrCodeLocal,
      this.used = false,
      int id,
      String amount,
      String name,
      String discount})
      : super(id: id, discount: discount, amount: amount, name: name);

  factory Voucher.fromStringJson(String data, {bool config = false}) {
    Map jsonData = json.decode(data);

    if (config) {
      Voucher voucher = Voucher.fromJson(jsonData['voucher_config']);
      voucher.qrCode = jsonData['qr_code'];
      voucher.id = jsonData['id'];
      return voucher;
    }

    return Voucher.fromJson(jsonData);
  }

  factory Voucher.fromJson(Map<String, dynamic> data) => Voucher(
      qrCode: data['qr_code'],
      title: data['title'],
      name: data['name'],
      amount: data['amount'],
      id: data['id'],
      expirationDate: data['expiration_date'],
      discount: data['discount'] ?? data[''][''],
      qrCodeLocal: data['qr_code_local'],
      used: data['used'] ?? false,
      description: data['description']);

  Map<String, dynamic> toJson() => {
        'qr_code': qrCode,
        'title': title,
        'id': id,
        'amount': amount,
        'name': name,
        'expiration_date': expirationDate,
        'discount': discount,
        'description': description,
        'used': used,
        'qr_code_local': qrCodeLocal
      };

  String get discountType {
    if (discount == 'percentage') {
      return '-$amount%';
    } else if (discount == 'fixed' || discount == "free_item") {
      return voucherName;
    }
    return '';
  }

  bool get isLocal => qrCodeLocal != null && qrCodeLocal.isNotEmpty;

  Future saveQrCode() async {
    if (qrCodeLocal == null || qrCodeLocal.isEmpty) {
      String qrCodeLocalPath = await Api.instance.saveQRCode(qrCode);
      qrCodeLocal = qrCodeLocalPath ?? qrCodeLocal;
    }
  }

  String get voucherName => title ?? name;
}
