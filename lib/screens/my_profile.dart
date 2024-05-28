import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_movie_app/constants/bottom_nav_bar.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:social_movie_app/models/add_post.dart';
import 'package:social_movie_app/screens/account.dart';
import 'package:social_movie_app/screens/home.dart';
import 'package:social_movie_app/screens/suprise.dart';
import 'package:social_movie_app/screens/watch_list_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Set<Post> posts =
      {}; // Set kullanarak postların yalnızca benzersiz olanlarını saklayacağız
  late String userName;
  late String userSurname;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchUserPosts();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      userSurname = prefs.getString('userSurname') ?? '';
    });
  }

  Future<void> fetchUserPosts() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .collection('posts')
          .get();

      List<Post> userPosts =
          snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();

      // Set içine postları ekleyerek yalnızca benzersiz olanları saklayacağız
      setState(() {
        posts.addAll(userPosts);
      });
    } catch (e) {
      print("Error fetching user posts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int postCount = posts.length;

    var _pageIndex = 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: Text(
          'Diji ',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    //backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          "$userName $userSurname",
                          style:
                              TextStyle(fontSize: 24, color: AppColors.white),
                        ),
                        Text(
                          '$postCount Gönderi',
                          style:
                              TextStyle(fontSize: 12, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            posts.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Text(
                        'Henüz gönderi yok. Hemen ilk gönderini oluştur',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: AppColors.black,
                        child: ListTile(
                          title: Text(
                            posts.elementAt(index).filmName,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          subtitle: Text(
                            posts.elementAt(index).comment,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            // Göndermeye yönlendirme işlemi
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pop-up açılacak
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddPostDialog(
                onPostAdded: (String filmName, String comment) {
                  // Firestore'a gönderi ekleme
                  addPostToFirestore(filmName, comment);
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.black54,
      bottomNavigationBar: BottomNavBar(
        pageIndex: _pageIndex,
        onPageChanged: (int index) {
          setState(() {
            var _pageIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupriseMePage()),
            );
          }
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WatchlistPage()),
            );
          }
        },
      ),
    );
  }

  void addPostToFirestore(String filmName, String comment) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('posts')
          .add({
        'filmName': filmName,
        'comment': comment,
        'timestamp': Timestamp.now(),
      });

      // Gönderi eklendikten sonra tüm gönderileri yeniden getir
      fetchUserPosts();
    } catch (e) {
      print("Error adding post to Firestore: $e");
    }
  }
}

class Post {
  String filmName;
  String comment;

  Post(this.filmName, this.comment);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post &&
        other.filmName == filmName &&
        other.comment == comment;
  }

  @override
  int get hashCode => filmName.hashCode ^ comment.hashCode;

  // Firestore'dan veri alındığında Post nesnesi oluşturmak için fabrika metodu
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(map['filmName'], map['comment']);
  }
}
