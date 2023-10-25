class Expense {
  final String name;
  final String category;
  final String value;
  final DateTime date;
  final bool recurrent;
  final String dtmExclusion;
  final String userId;

  Expense(this.name, this.category, this.value, this.date, this.recurrent, this.dtmExclusion, this.userId);

  Map<String, dynamic> toJson() => {
        "expense_name": name,
        "expense_category": category,
        "expense_value": value,
        "expense_date": date,
        "expense_recurrent": recurrent,
        "expense_dtmExclusion": dtmExclusion,
        "expense_userId": userId,
      };
}