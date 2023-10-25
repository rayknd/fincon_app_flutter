import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fincon_app/models/fixed_expenses.dart';
import 'package:fincon_app/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class ExpenseIndexPage extends StatefulWidget {
  const ExpenseIndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseIndexPageState();
}

class _ExpenseIndexPageState extends State<ExpenseIndexPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _value = TextEditingController();
  Stream<QuerySnapshot> streamCategories =
      FirestoreService().getCategoryStream();

  String? _selectedCategory = "";
  DateTime _date = DateTime.now();
  bool isRecurrent = false;

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  void openExpenseBox({String? docID}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration:
                          const InputDecoration(hintText: "Nome do gasto"),
                      controller: _name,
                    ),
                    TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(hintText: "Valor do Gasto"),
                      controller: _value,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: streamCategories, 
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator(); 
                          }

                          List categories = snapshot.data!.docs
                              .map((doc) => doc['category_name'])
                              .toList();

                          if(_selectedCategory == ""){
                            _selectedCategory = categories[0];
                          }

                          return DropdownButton<String>(
                            value: _selectedCategory,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            },
                            items: categories.map((dynamic category) {
                              return DropdownMenuItem<String>(
                                value: category.toString(),
                                child: Text(category.toString()),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const Text('Data: '),
                        Text(formatDate(_date, [dd, '/', mm, '/', yyyy])),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context, setState);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, 
                      children: <Widget>[
                        Checkbox(
                          value: isRecurrent,
                          onChanged: (bool? value) {
                            setState(() {
                              isRecurrent = value!;
                            });
                          },
                        ),
                        const Text('Recorrente'),
                      ],
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        if (docID != null) {
                          
                          FirestoreService().updateExpense(
                              docID,
                              Expense(_name.text, _selectedCategory!, _value.text, _date,
                                  isRecurrent, null, "1", null));
                        } else {
                          
                          FirestoreService().addExpense(Expense(
                              _name.text,
                              _selectedCategory!,
                              _value.text,
                              _date,
                              isRecurrent,
                              null,
                              "1",
                              null));
                        }

                        
                        _name.clear();
                        _value.clear();
                        _date = DateTime.now();
                        isRecurrent = false;

                        
                        Navigator.pop(context);
                      },
                      child: const Text("Adicionar"))
                ],
              );
            }));
  }

  void confirmDelete({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Tem certeza que quer deletar?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID != null) {
                        FirestoreService().deleteExpense(docID);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Sim")),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Não")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Despesas",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openExpenseBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getExpenseStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List categoriesList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = categoriesList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  Expense expense = Expense.fromJson(data);

                  bool enpenseDtmPayment = expense.dtmPayment != null;

                  return Card(
                      child: ListTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => openExpenseBox(docID: docID),
                            icon: const Icon(Icons.settings)),
                        IconButton(
                            onPressed: () => confirmDelete(docID: docID),
                            icon: const Icon(Icons.delete)),
                        Switch(
                          value: enpenseDtmPayment,
                          onChanged: (bool? value) {
                            setState(() {
                              enpenseDtmPayment = value!;
                            });

                            if (enpenseDtmPayment) {
                              expense.dtmPayment = DateTime.now();
                            }

                            if (!enpenseDtmPayment) {
                              expense.dtmPayment = null;
                            }

                            FirestoreService().updateExpense(docID, expense);
                          },
                        )
                      ],
                    ),
                    title: Text(expense.name),
                    subtitle: Text(
                      expense.value,
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ));
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
