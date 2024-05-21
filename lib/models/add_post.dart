import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostDialog extends StatefulWidget {
  final Function(String, String) onPostAdded;

  const AddPostDialog({Key? key, required this.onPostAdded}) : super(key: key);

  @override
  _AddPostDialogState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  String filmName = '';
  String comment = '';

  Future<void> addPostToFirestore(String filmName, String comment) async {
    try {
      // Aktif kullanıcıyı al
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Firestore referansını al ve gönderi ekle
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('posts')
          .add({
        'filmName': filmName,
        'comment': comment,
        'timestamp': Timestamp.now(),
      });

      // Başarıyla eklendiğinde geri çağırma işlevini çağır
      widget.onPostAdded(filmName, comment);
    } catch (e) {
      // Hata durumunda kullanıcıyı bilgilendir
      print("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.dark,
      title: Text(
        'Gönderi ekle',
        style: TextStyle(color: AppColors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Film Adı'),
            onChanged: (value) {
              setState(() {
                filmName = value;
              });
            },
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: "Yorumunuz"),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            onChanged: (value) {
              setState(() {
                comment = value;
              });
            },
          ),
          SizedBox(height: 10),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Gönderiyi Firestore'a ekle
            addPostToFirestore(filmName, comment);
            Navigator.pop(context);
            print("kaydedildi");
          },
          child: Text("Paylaş"),
        ),
      ],
    );
  }
}
