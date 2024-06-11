import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_movie_app/constants/color.dart';

class UserProfile extends StatelessWidget {
  final String uid;
  final String name;
  final String surname;

  UserProfile({required this.uid, required this.name, required this.surname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Ara',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                FutureBuilder(
                  future: _getProfileImage(),
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return CircleAvatar();
                    }
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(snapshot.data!),
                    );
                  },
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                        "$name $surname",
                        style: TextStyle(fontSize: 24, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('posts')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('Kullanıcı henüz bir gönderi oluşturmamış.'),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((postDoc) {
                    Map<String, dynamic> posts =
                        postDoc.data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(
                          posts['filmName'],
                          style:
                              TextStyle(color: AppColors.white, fontSize: 20),
                        ),
                        subtitle: Text(
                          posts['comment'],
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black54,
    );
  }

// ...

  Future<String> _getProfileImage() async {
    // Kullanıcının profil fotoğrafının yolunu Firebase Storage'dan al
    try {
      final storage = firebase_storage.FirebaseStorage.instanceFor(
          bucket: "gs://btbs-movie.appspot.com/");
      firebase_storage.Reference ref = storage.ref('user.png');
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // Hata oluşursa varsayılan profil resminin yolunu döndür
      return '';
    }
  }
}
