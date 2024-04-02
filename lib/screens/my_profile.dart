import 'package:flutter/material.dart';
import 'package:social_movie_app/constants/bottom_nav_bar.dart';
import 'package:social_movie_app/constants/color.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> posts = []; // List to store posts

  @override
  Widget build(BuildContext context) {
    int postCount = posts.length;

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
                            // gönderme islemi
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
              String filmName = '';
              String comment = '';
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
                        filmName = value;
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(labelText: "Yorumunuz"),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      onChanged: (value) {
                        comment = value;
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      // Yorumu paylaş
                      setState(() {
                        posts.add(Post(filmName, comment));
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Paylaş"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      backgroundColor: AppColors.dark,
      bottomNavigationBar: BottomNavBar(
        pageIndex: 4,
        onPageChanged: (int value) {},
      ),
    );
  }
}

class Post {
  String filmName;
  String comment;

  Post(this.filmName, this.comment);
}
