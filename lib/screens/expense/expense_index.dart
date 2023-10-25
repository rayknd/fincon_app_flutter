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
  DateTime _date = DateTime.now();
  bool isRecurrent = false;

  Future<void> _selectDate(BuildContext context) async {
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
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Nome do gasto"),
                    controller: _name,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: "Valor do Gasto"),
                    controller: _value,
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Data: '),
                      Text(formatDate(_date, [dd, '/', mm, '/', yyyy])),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                  Row(
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
                        //Atualiza a despesa
                        FirestoreService().updateExpense(
                            docID, Expense(_name.text, "", _value.text, _date, isRecurrent, "", "1"));
                      } else {
                        //Adiciona nova despesa
                        FirestoreService().addExpense(
                            Expense(_name.text, "", _value.text, _date, isRecurrent, "", "1"));
                      }

                      //Limpa input
                      _name.clear();
                      _value.clear();
                      _date = DateTime.now();
                      isRecurrent = false;

                      //Fecha dialog
                      Navigator.pop(context);
                    },
                    child: const Text("Adicionar"))
              ],
            ));
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

                  String expenseName = data['expense_name'];

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
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    leading: Text(expenseName),
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
