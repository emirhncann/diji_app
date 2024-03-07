import 'package:flutter/material.dart';
import 'package:social_movie_app/constants/bottom_nav_bar.dart';
import 'package:social_movie_app/constants/color.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                          '10 Gönderi',
                          style:
                              TextStyle(fontSize: 12, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10, // Kullanıcının post sayısı buraya gelir
              itemBuilder: (context, index) {
                // Örnek olarak, postları gösteren bir Card kullanarak devam edebilirsiniz
                return Card(
                  color: Colors.black87,
                  child: ListTile(
                    title: Text(
                      'Film adı',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Kullanıcı Yorumu Kullanıcı Yorumu Kullanıcı Yorumu Kullanıcı Yorumu Kullanıcı Yorumu Kullanıcı Yorumu ',
                      style: TextStyle(color: Colors.white),
                    ),
                    // Posta tıklanınca yapılacak işlemler buraya eklenebilir
                    onTap: () {
                      // Posta tıklanınca yapılacak işlemler
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.dark,
      bottomNavigationBar: BottomNavBar(
        pageIndex: 4,
        onPageChanged: (int value) {},
      ),
    );
  }
}
