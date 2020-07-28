import 'dart:convert';

List vouchersFromJsonList(List body) {
  List<Voucher> vouchers = [];
  body.forEach((value) {
    vouchers.add(Voucher.fromJson(value));
  });
  return vouchers;
}

String vouchersToJsonList(List vouchers) {
  return json.encode(vouchers);
}

class Voucher {
  int bonusAmount; // -bonusAmount% from price
  int toBonus; // amount users purchase to get bonus
  int currentAmount; // current user purchase for this card
  bool used;

  bool get isBonus => currentAmount == toBonus; // is card bonus

  Voucher(
      {this.toBonus, this.currentAmount, this.bonusAmount, this.used = false});

  factory Voucher.fromJson(Map<String, dynamic> json) => new Voucher(
      bonusAmount: json['bonus_amount'],
      toBonus: json['to_bonus'],
      used: json['used'] ?? false,
      currentAmount: json['current_amount']);

  Map<String, dynamic> toJson() => {
        'bonus_amount': bonusAmount,
        'to_bonus': toBonus,
        'used': used,
        'current_amount': currentAmount
      };
}
