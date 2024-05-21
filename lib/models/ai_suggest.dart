import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore eklendi

class AISuggestPage extends StatefulWidget {
  @override
  _AISuggestPageState createState() => _AISuggestPageState();
}

class _AISuggestPageState extends State<AISuggestPage> {
  Map<String, int> categories = {};

  @override
  void initState() {
    super.initState();
    fetchCategoriesFromFirestore();
  }

  void fetchCategoriesFromFirestore() async {
    String userId =
        FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (documentSnapshot.exists) {
      setState(() {
        categories =
            Map<String, int>.from(documentSnapshot.data()!['categories']);
      });
    } else {
      print("Belge mevcut değil.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Suggest Page'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (categories.isNotEmpty)
              ...categories.entries.map((entry) => Text(
                    '${entry.key}: ${entry.value}',
                    style: TextStyle(fontSize: 20),
                  )),
            if (categories.isEmpty) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
