class FixedExpenses {
  final String name;
  final String category;
  final String value;
  final String date;
  final String recurrent;
  final String dtmExclusion;
  final String userId;

  FixedExpenses(this.name, this.category, this.value, this.date, this.recurrent, this.dtmExclusion, this.userId);

  Map<String, dynamic> toJson() => {
        "expenses_name": name,
        "expenses_category": category,
        "expenses_value": value,
        "expenses_date": date,
        "expenses_recurrent": recurrent,
        "expenses_dtmExclusion": dtmExclusion,
        "expenses_userId": userId,
      };
}
