
List vouchersToJsonList(List vouchersList) {
  List<Voucher> vouchers = [];
  vouchersList.forEach((element) {
    vouchers.add(Voucher.fromJson(element));
  });
  return vouchers;
}

class Voucher {
  int bonusAmount; // -bonusAmount% from price
  int toBonus; // amount users purchase to get bonus
  int currentAmount; // current user purchase for this card
  bool used;

  bool get isBonus => currentAmount == toBonus; // is card bonus

  Voucher(
      {this.toBonus, this.currentAmount, this.bonusAmount, this.used = false});

  factory Voucher.fromJson(Map<String, dynamic> data) => Voucher(
      bonusAmount: data['bonus_amount'],
      toBonus: data['to_bonus'],
      used: data['used'] ?? false,
      currentAmount: data['current_amount']);

}
