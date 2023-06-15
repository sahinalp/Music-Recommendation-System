import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //final databaseReference = FirebaseFirestore.instance.collection("dataset");

  // static Future<String> read() async {
  //   try {
  //     DatabaseReference _databaseReference =
  //         FirebaseDatabase.instance.ref("dataset/1");
  //     final snapshot = await _databaseReference.get();
  //     if (snapshot.exists) {
  //       Map<String, dynamic> _snapshotValue =
  //           Map<String, dynamic>.from(snapshot.value as Map);
  //       return _snapshotValue['name'] ?? '';
  //     } else {
  //       return '';
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //py/dataset/101939
    final ref = FirebaseDatabase.instance.ref().child('dataset/1');

    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      child: FirebaseAnimatedList(
          query: ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            //var v = snapshot.value.toString();
            Object? dataset = snapshot.value;
            //dataset['key'] = snapshot.key;
            return SingleChildScrollView(
              child: ListTile(
                title: Text("$dataset"),
              ),
            );
          }),
    ));
  }
}
