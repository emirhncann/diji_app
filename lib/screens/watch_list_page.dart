import 'package:flutter/material.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:social_movie_app/models/add_post.dart';
import 'package:social_movie_app/models/watch_list.dart';

class WatchlistPage extends StatefulWidget {
  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daha Sonra İzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ListView.builder(
          itemCount: watchList.length,
          itemBuilder: (context, index) {
            final reversedIndex = watchList.length - 1 - index;
            return Dismissible(
              key: Key(watchList[reversedIndex]),
              onDismissed: (direction) {
                setState(() {
                  watchList.removeAt(reversedIndex);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${watchList[reversedIndex]} dismissed'),
                  ),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete),
              ),
              child: Card(
                color: AppColors.dark,
                child: ListTile(
                  title: Text(
                    watchList[reversedIndex],
                    style: TextStyle(color: AppColors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      // İzledim butonuna basıldığında filmi izlediklerim listesine ekle
                      _showCreatePostDialog(watchList[reversedIndex]);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: AppColors.black,
    );
  }

  // Gönderi oluşturma için popup gösterme fonksiyonu
  void _showCreatePostDialog(String filmName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gönderi Oluşturma'),
          content:
              Text('$filmName hakkında bir gönderi oluşturmak ister misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hayır'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createPost(filmName);
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  // Gönderi oluşturma fonksiyonu
  void _createPost(String filmName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPostDialog(
          onPostAdded: (String filmName, String comment) {
            // Gönderi oluşturma işlemleri burada gerçekleştirilir
            // Örneğin, gönderiyi bir listeye ekleyebilirsiniz
            // addPost(filmName, comment);
            // Burada addPost fonksiyonu, gönderiyi bir listeye ekleyen bir fonksiyon olmalıdır
            // Örnek olarak şu şekilde:
            // setState(() {
            //   posts.add(Post(filmName, comment));
            // });
            Navigator.pop(context); // İletişim kutusunu kapat
          },
        );
      },
    );
  }
}
