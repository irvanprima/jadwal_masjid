// ignore_for_file: prefer_const_constructors, must_be_immutable,
//use_key_in_widget_constructors, prefer_const_literals_to_create_immutables,
//avoid_print, unnecessary_cast, prefer_is_empty
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'form.dart';
void main() async {
//do initialization to use firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD Firebase',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Flutter CRUD Firebase'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
//The entry point for accessing a [FirebaseFirestore].
    FirebaseFirestore firebase = FirebaseFirestore.instance;
//get collection from firebase, collection is table in mysql
    CollectionReference kegiatan = firebase.collection('kegiatan');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<QuerySnapshot>(
// data to be retrieved in the future
        future: kegiatan.get(),
        builder: (_, snapshot) {
// show if there is data
          if (snapshot.hasData) {
            var allData = snapshot.data!.docs;
// if there is data, make list
            return allData.length != 0
                ? ListView.builder(
                itemCount: allData.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(allData[index]['name'][0]),
                    ),
                    title: Text(allData[index]['name'],
                        style: TextStyle(fontSize: 20)),
                    subtitle: Text(allData[index]['waktuKegiatan'],
                        style: TextStyle(fontSize: 16)),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
//pass data to edit form
                            MaterialPageRoute(
                                builder: (context) => FormPage(
                                  id: snapshot.data!.docs[index].id,
                                )),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_rounded)),
                  );
                })
                : Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            return Center(child: Text("Loading...."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FormPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
