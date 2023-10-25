import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fincon_app/services/firestoreService.dart';
import 'package:flutter/material.dart';

class CategoryIndexPage extends StatefulWidget {
  const CategoryIndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _CategoryIndexPageState();
}

class _CategoryIndexPageState extends State<CategoryIndexPage> {
  final TextEditingController textController = TextEditingController();

  void openCategoryBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                decoration: const InputDecoration(
                    hintText: "Insira o nome da categoria"),
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID != null) {
                        //Atualiza a categoria
                        FirestoreService()
                            .updateCategory(docID, textController.text);
                      } else {
                        //Adiciona nova categoria
                        FirestoreService().addCategory(textController.text);
                      }

                      //Limpa input
                      textController.clear();

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
                        FirestoreService().deleteCategory(docID);
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
          "Categorias",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCategoryBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getCategoryStream(),
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

                  String categoryName = data['category_name'];

                  return Card(
                      child: ListTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => openCategoryBox(docID: docID),
                            icon: const Icon(Icons.settings)),
                        IconButton(
                            onPressed: () => confirmDelete(docID: docID),
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    leading: Text(categoryName),
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
