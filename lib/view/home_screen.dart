import 'package:flutter/material.dart';
import 'package:notes_apps_sqtlite/db_helper/db_helper.dart';
import 'package:notes_apps_sqtlite/model/notes_app_model.dart';

import '../components/input_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

late DBHelper? dbHelper;
late Future<List<NotesAppModel>> notesList;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMyDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Expanded(
            child: FutureBuilder<List<NotesAppModel>>(
              future: notesList,
              builder: (context, snapshot) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              'No notes available.',
                              style: TextStyle(fontSize: 20),
                            )),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: Card(
                            color: Colors.deepPurple.shade200,
                            child: Column(
                              children: [
                                ListTile(
                                    title: Text(
                                      snapshot.data![index].title.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    subtitle: Text(
                                      snapshot.data![index].description
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: SizedBox(
                                      width: width * 0.18,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap:(){
                                              editMyDialog(snapshot.data![index], snapshot.data![index].title.toString(), snapshot.data![index].description.toString(),);
                                            },
                                              child: const Icon(Icons.edit)),
                                          SizedBox(
                                            width: width * 0.04,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                dbHelper!.deleteNotes(
                                                    snapshot.data![index].id!);
                                                notesList =
                                                    dbHelper!.getNotesList();
                                                snapshot.data!.remove(
                                                    snapshot.data![index]);
                                              });
                                            },
                                            child: const Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InputTextField(
                    controller: titleController,
                    hintText: 'Enter title',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputTextField(
                    controller: descriptionController,
                    hintText: 'Enter description',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  dbHelper!
                      .insert(NotesAppModel(
                          title: titleController.text,
                          description: descriptionController.text))
                      .then((value) {
                    print("notes added");
                    Navigator.pop(context);
                    setState(() {
                      notesList = dbHelper!.getNotesList();
                      titleController.clear();
                      descriptionController.clear();
                    });
                  }).onError((error, stackTrace) {
                    print(error.toString());
                  });
                },
                child: const Text("Add"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }

  Future<void> editMyDialog( NotesAppModel notesAppModel,
      String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InputTextField(
                      controller: titleController, hintText: 'Enter title'),
                  const SizedBox(
                    height: 20,
                  ),
                  InputTextField(
                      controller: descriptionController,
                      hintText: 'Enter description'),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    dbHelper!.updatesNotes(NotesAppModel(
                        id: notesAppModel.id,
                        title: titleController.text,
                        description: descriptionController.text)).then((value){
                          print("notes save");
                          setState(() {
                            notesList = dbHelper!.getNotesList();
                            titleController.clear();
                            descriptionController.clear();
                          });

                    }).onError((error, stackTrace) {
                      print(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Save")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
            ],
          );
        });
  }
}
