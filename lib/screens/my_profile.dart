import 'package:flutter/material.dart';
import 'package:social_movie_app/constants/bottom_nav_bar.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:social_movie_app/models/add_post.dart';
import 'package:social_movie_app/screens/account.dart';
import 'package:social_movie_app/screens/home.dart';
import 'package:social_movie_app/screens/suprise.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> posts = []; // Gönderileri saklamak için bir liste

  @override
  Widget build(BuildContext context) {
    int postCount = posts.length;

    var _pageIndex = 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
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
                    // Kullanıcının profil fotoğrafını buraya ekleyin
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          'Emirhan Can',
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
                      final reversedIndex = posts.length - 1 - index;
                      return Card(
                        color: Colors.black87,
                        child: ListTile(
                          title: Text(
                            posts[reversedIndex].filmName,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            posts[reversedIndex].comment,
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
                  setState(() {
                    posts.add(Post(filmName, comment));
                  });
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      backgroundColor: AppColors.dark,
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
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
          }
        },
      ),
    );
  }
}

class Post {
  String filmName;
  String comment;

  Post(this.filmName, this.comment);
}
