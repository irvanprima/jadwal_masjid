// ignore_for_file: unnecessary_new, unused_field, prefer_const_constructors,
//prefer_const_literals_to_create_immutables, unused_local_variable, unused_import,
//use_key_in_widget_constructors, avoid_print, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class FormPage extends StatefulWidget {
//constructor have one parameter, optional paramter
//if have id we will show data and run update method
//else run add data
  const FormPage({this.id});

  final String? id;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
//set form key
  final _formKey = GlobalKey<FormState>();

//set texteditingcontroller variable
  var nameController = TextEditingController();
  var waktuKegiatanController = TextEditingController();
  var penanggungJawabController = TextEditingController();
  var KeteranganController = TextEditingController();

//inisialize firebase instance
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  CollectionReference? kegiatan;

  void getData() async {
//get users collection from firebase
    kegiatan = firebase.collection('kegiatan');
//if have id
    if (widget.id != null) {
//get kegiatan data based on id document
      var data = await kegiatan!.doc(widget.id).get();
//we get data.data()
//so that it can be accessed, we make as a map
      var item = data.data() as Map<String, dynamic>;
//set state to fill data controller from data firebase
      setState(() {
        nameController = TextEditingController(text: item['name']);
        waktuKegiatanController =
            TextEditingController(text: item['waktuKegiatan']);
        penanggungJawabController =
            TextEditingController(text: item['penanggungJawab']);
        KeteranganController =
            TextEditingController(text: item['Keterangan']);
      });
    }
  }

  @override
  void initState() {
// ignore: todo
// TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Form Kegiatan"),
          actions: [
//if have data show delete button
            widget.id != null
                ? IconButton(
                    onPressed: () {
//method to delete data based on id
                      kegiatan!.doc(widget.id).delete();
//back to main page
// '/' is home
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                    icon: Icon(Icons.delete))
                : SizedBox()
          ],
        ),
//this form for add and edit data
//if have id passed from main, field will show data
        body: Form(
          key: _formKey,
          child: ListView(padding: EdgeInsets.all(16.0), children: [
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.calendar_today,
                size: 30,
              ),
            ),
            Text(
              'Nama Kegiatan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Nama Kegiatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Isi nama kegiatan!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Waktu Kegiatan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: waktuKegiatanController,
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today), // Icon Text Field
                  labelText: "Masukkan Waktu Kegiatan" // Label dari text field
                  ),
              readOnly: true,
              // Jadikan readOnly true agar user tidak bisa mengakses edit text secara langsung
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1945),
                    lastDate: DateTime(2045));
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    waktuKegiatanController.text = formattedDate;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              'Penanggung Jawab Kegiatan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: penanggungJawabController,
              decoration: InputDecoration(
                  hintText: "Penanggung Jawab Kegiatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Isi penanggung Jawab kegiatan!';
                }
                return null;
              },
            ),

            //Keterangan kegiatan

            SizedBox(height: 20),
            Text(
              'Keterangan Kegiatan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: KeteranganController,
              decoration: InputDecoration(
                  hintText: "Keterangan Kegiatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Isi Keterangan kegiatan!';
                }
                return null;
              },
            ),

            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
//if id not null run add data to store data into firebase
//else update data based on id
                  if (widget.id == null) {
                    kegiatan!.add({
                      'name': nameController.text,
                      'waktuKegiatan': waktuKegiatanController.text,
                      'penanggungJawab': penanggungJawabController.text,
                      'Keterangan': KeteranganController.text

                    });
                  } else {
                    kegiatan!.doc(widget.id).update({
                      'name': nameController.text,
                      'waktuKegiatan': waktuKegiatanController.text,
                      'penanggungJawab': penanggungJawabController.text,

                      'Keterangan': KeteranganController.text
                    });
                  }
//snackbar notification
                  final snackBar =
                      SnackBar(content: Text('Data berhasil save!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
//back to main page
//home page => '/'
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                }
              },
            )
          ]),
        ));
  }
}
//mau coba aja

