import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore eklendi
import 'dart:math';

import 'package:social_movie_app/constants/color.dart';

final storage =
    FirebaseStorage.instanceFor(bucket: "gs://btbs-movie.appspot.com/");
final firestore = FirebaseFirestore.instance; // Firestore instance oluşturuldu

class PreferencePage extends StatefulWidget {
  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  int progressStep = 0; // İlerleme adımı
  List<String> movies = [
    "Esaretin Bedeli",
    "Başlangıç(Inception)",
    "Yüzüklerin Efendisi",
    "Fight Club",
    "The Matrix",
    "Avengers End Game",
    "Deadpool",
    "Titanic",
    "Yukarı Bak",
    "Interstellar",
  ];

  List<String> selectedMovies = [];
  List<Uint8List?> movieImages =
      List.filled(2, null); // Film resimlerini saklamak için liste eklendi

  // K
  Map<String, int> categories = {
    'Gerilim': 0,
    'Bilim Kurgu': 0,
    'Aksiyon': 0,
    'Komedi': 0,
    'Romantik': 0,
    'Animasyon': 0,
  };

  @override
  void initState() {
    super.initState();
    updateOptions(); // İlk seçenekleri güncelle
  }

  void selectOption(String movieName) {
    setState(() {
      selectedMovies.add(movieName);
      progressStep++; 
      increaseCategoryPoint(movieName); // Seçilen film kategorisine +1
    });

    if (progressStep < 5) {
      
      updateOptions();
    } else {
      
      saveCategoriesToFirestore();
    }
  }

  void saveCategoriesToFirestore() {
    // Kategorileri Firestore'a kaydet
    firestore.collection('users').doc('USER_ID').set({
      'categories': categories,
    }).then((value) {
      print('Kategoriler Firestore\'a kaydedildi.');
    }).catchError((error) {
      print('Kategorileri Firestore\'a kaydederken hata oluştu: $error');
    });
  }

  void increaseCategoryPoint(String movieName) {
  
    switch (movieName) {
      case "Esaretin Bedeli":
        categories['Gerilim'] = categories['Gerilim']! + 1;
        break;
      case "Başlangıç(Inception)":
        categories['Bilim Kurgu'] = categories['Bilim Kurgu']! + 1;
        categories['Aksiyon'] = categories['Aksiyon']! + 1;
        break;
      case "Yüzüklerin Efendisi":
        categories['Bilim Kurgu'] = categories['Bilim Kurgu']! + 1;
        break;
      case "Fight Club":
        categories['Gerilim'] = categories['Gerilim']! + 1;
        categories['Aksiyon'] = categories['Aksiyon']! + 1;
        break;
      case "The Matrix":
        categories['Aksiyon'] = categories['Aksiyon']! + 1;
        categories['Bilim Kurgu'] = categories['Bilim Kurgu']! + 1;
        break;
      case "Avengers End Game":
        categories['Aksiyon'] = categories['Aksiyon']! + 1;
        categories['Bilim Kurgu'] = categories['Bilim Kurgu']! + 1;
        break;
      case "Deadpool":
        categories['Aksiyon'] = categories['Aksiyon']! + 1;
        categories['Komedi'] = categories['Komedi']! + 1;
        break;
      case "Titanic":
        categories['Romantik'] = categories['Romantik']! + 1;
        break;
      case "Yukarı Bak":
        categories['Animasyon'] = categories['Animasyon']! + 1;
        break;
      case "Interstellar":
        categories['Bilim Kurgu'] = categories['Bilim Kurgu']! + 1;
        break;
    }
  }

  void updateOptions() {
    List<String> newSelectedMovies = generateRandomMovies();
    selectedMovies = newSelectedMovies;
    loadNewImages(
        newSelectedMovies); // Yeni seçilen filmler için resimleri yükle
  }

  void loadNewImages(List<String> newSelectedMovies) {
    // Önceki resimleri temizle
    movieImages.fillRange(0, movieImages.length, null);

    for (var i = 0; i < newSelectedMovies.length; i++) {
      storage
          .ref()
          .child('preference/${newSelectedMovies[i]}.png')
          .getData(1024 * 1024)
          .then((value) {
        setState(() {
          movieImages[i] = value; // Alınan resmi listeye ekle
        });
      }).catchError((error) {
        print("Resim yüklenirken hata oluştu: $error");
      });
    }
  }

  List<String> generateRandomMovies() {
    List<String> randomMovies = [];
    final _random = Random();
    for (var i = 0; i < 2; i++) {
      if (movies.isNotEmpty) {
        int randomIndex = _random.nextInt(movies.length);
        randomMovies.add(movies[randomIndex]);
        movies.removeAt(randomIndex); // Seçilen filmi listeden kaldır
      }
    }
    return randomMovies;
  }

  @override
  Widget build(BuildContext context) {
    print(categories); // Kategorileri konsola yazdır
    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        title: Text('Film Tercihi'),
        backgroundColor: AppColors.red, // Bar rengi
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (selectedMovies.isNotEmpty) selectOption(selectedMovies[0]);
              },
              child: Card(
                child: Column(
                  children: [
                    movieImages[0] != null
                        ? Image.memory(
                            movieImages[0]!,
                            width: 120,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(
                            width: 120,
                            height: 180,
                            child: CircularProgressIndicator(),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              selectedMovies.length > 0 ? selectedMovies[0] : 'Seçenek 1',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (selectedMovies.length > 1) selectOption(selectedMovies[1]);
              },
              child: Card(
                child: Column(
                  children: [
                    movieImages[1] != null
                        ? Image.memory(
                            movieImages[1]!,
                            width: 120,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(
                            width: 120,
                            height: 180,
                            child: CircularProgressIndicator(),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              selectedMovies.length > 1 ? selectedMovies[1] : 'Seçenek 2',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Adım: $progressStep/5',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(
              width: 200, // İlerleme çubuğunun genişliği
              child: LinearProgressIndicator(
                color: Color.fromRGBO(239, 37, 35, 1),
                value: progressStep / 5, // 5 adımlık ilerleme
              ),
            )
          ],
        ),
      ),
    );
  }
}
