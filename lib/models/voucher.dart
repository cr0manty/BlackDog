import 'dart:convert';
import 'package:black_dog/instances/api.dart';
import 'package:black_dog/instances/shared_pref.dart';

Future vouchersFromJsonList(List vouchersList) async {
  List<Voucher> vouchers = [];
  await Future.wait(vouchersList.map((element) async {
    Voucher voucher = Voucher.fromJson(element);
    await voucher.saveQrCode();
    vouchers.add(voucher);
  }));
  SharedPrefs.saveActiveVoucher(vouchers);
}

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

Voucher voucherFromJson(String str) {
  if (str != null && str.isNotEmpty) {
    final data = json.decode(str);
    return Voucher.fromJson(data);
  }
  return Voucher();
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
      qrCodeLocal: data['qr_code_local'],
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
        'used': used,
        'qr_code_local': qrCodeLocal
      };

  String get discountType {
    if (discount == 'percentage') {
      return '-$amount%';
    } else if (discount == 'fixed' || discount == "free_item") {
      return title;
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
}
