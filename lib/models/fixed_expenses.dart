import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String name;
  final String category;
  final String value;
  final DateTime date;
  final bool recurrent;
  final DateTime? dtmExclusion;
  final String userId;
  DateTime? dtmPayment;

  Expense(this.name, this.category, this.value, this.date, this.recurrent,
      this.dtmExclusion, this.userId, this.dtmPayment);

  Map<String, dynamic> toJson() => {
        "expense_name": name,
        "expense_category": category,
        "expense_value": value,
        "expense_date": date,
        "expense_recurrent": recurrent,
        "expense_dtmExclusion": dtmExclusion,
        "expense_userId": userId,
        "expense_dtmPayment": dtmPayment,
      };

  factory Expense.fromJson(Map<String, dynamic> json) {
    DateTime? dtmExclusion;
    if(json["expense_dtmExclusion"] is Timestamp){
      dtmExclusion = (json["expense_dtmExclusion"] as Timestamp).toDate();
    }

    DateTime? dtmPayment;
    if(json["expense_dtmPayment"] is Timestamp){
      dtmPayment = (json["expense_dtmPayment"] as Timestamp).toDate();
    }

    return Expense(
        json["expense_name"],
        json["expense_category"],
        json["expense_value"],
        (json["expense_date"] as Timestamp).toDate(),
        json["expense_recurrent"],
        dtmExclusion,
        json["expense_userId"],
        dtmPayment);
  }
}