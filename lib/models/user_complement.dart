class UserComplement {
  final String name;
  final String income;
  final String uid;

  UserComplement(this.name, this.income, this.uid);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "user_name": name,
        "income": income,
      };
}
