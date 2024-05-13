import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_movie_app/constants/bottom_nav_bar.dart';
import 'package:social_movie_app/constants/color.dart';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:social_movie_app/constants/api.dart';
import 'package:social_movie_app/models/watch_list.dart';
import 'package:social_movie_app/screens/account.dart';
import 'package:social_movie_app/screens/home.dart';
import 'package:social_movie_app/screens/my_profile.dart';

class SupriseMePage extends StatefulWidget {
  const SupriseMePage({Key? key}) : super(key: key);

  @override
  _SupriseMePageState createState() => _SupriseMePageState();
}

class _SupriseMePageState extends State<SupriseMePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  Uint8List _wheelImage = Uint8List(0);

  final storage = FirebaseStorage.instance;

  String responseText = '';

  @override
  void initState() {
    super.initState();
    movieSuggest();
    _fetchWheelImage();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _showResponsePopup(responseText);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchWheelImage() async {
    try {
      final imageData =
          await storage.ref().child('cark.png').getData(1024 * 1024);
      setState(() {
        _wheelImage = imageData!;
      });
    } catch (e) {
      print('Resim alınamadı: $e');
    }
  }

  // Animasyonu başlatan fonksiyon
  void _startRotationAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var _pageIndex = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Surprise Me'),
        backgroundColor: AppColors.black,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _wheelImage != null
                  ? RotationTransition(
                      turns: _animation,
                      child: Image.memory(
                        _wheelImage!,
                        width: 400,
                        height: 400,
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
          Container(),
          ElevatedButton(
            onPressed: () async {
              _startRotationAnimation();
              await movieSuggest();
              // Butona basıldığında animasyonu başlat
            },
            child: Text('Surprise Me!'),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
      backgroundColor: Colors.black54,
      bottomNavigationBar: BottomNavBar(
        pageIndex: _pageIndex,
        onPageChanged: (int index) {
          setState(() {
            _pageIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
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

  Future<void> movieSuggest() async {
    final apiKey = API_keys.gemini_API;
    if (apiKey == null) {
      print('API key bulunamadı');
      exit(1);
    }

    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [
      Content.text(
          'son 10 yılda kesinlikle izlenmesi gereken rastgele 1 tane film öner. . çıktıyı şu şekilde ver: Film adı, Çıkış yılı, İMDB Puan/10,Her bir satırı alt alta yaz')
    ];
    final response = await model.generateContent(content);
    setState(() {
      responseText = response.text!;
    });
    print(response.text);
  }

  void _showResponsePopup(String responseText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Film Önerisi"),
          content: Text(responseText),
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
                addToWatchList(responseText);
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );
  }
}
