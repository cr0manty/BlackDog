class Bonus {
  int bonusAmount;    // -bonusAmount% from price
  int toBonus;        // amount users purchase to get bonus
  int currentAmount;  // current user purchase for this card
  bool used;

  bool get isBonus => currentAmount == toBonus; // is card bonus

  Bonus({this.toBonus, this.currentAmount, this.bonusAmount, this.used=false});

  factory Bonus.fromJson(Map<String, dynamic> json) => new Bonus(
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