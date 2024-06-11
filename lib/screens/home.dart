import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_movie_app/constants/bottom_nav_bar.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:social_movie_app/models/ai_suggest.dart' as ai;
import 'package:social_movie_app/models/ai_suggest.dart';
import 'package:social_movie_app/models/movie.dart' as movie;
import 'package:social_movie_app/models/movie.dart';
import 'package:social_movie_app/models/popular.dart';
import 'package:social_movie_app/models/movie_slider.dart';
import 'package:social_movie_app/screens/account.dart';
import 'package:social_movie_app/screens/watch_list_page.dart';
import 'package:social_movie_app/screens/my_profile.dart';
import 'package:social_movie_app/screens/suprise.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<movie.Result>> trendingMovies;
  late Future<List<movie.Result>> topRatedMovies;
  late Future<List<movie.Result>> upcomingMovies;

  String localUserName = "";
  String localUserSurname = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    trendingMovies = api().getTrendingMovies();
    topRatedMovies = api().getTopRatedMovies();
    upcomingMovies = api().getUpcomingMovies();

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        setState(() {
          localUserName = userDoc['name'];
          localUserSurname = userDoc['surname'];
        });
        // SharedPreferences kullanarak kullanıcı verilerini kaydetme
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', localUserName);
        await prefs.setString('userSurname', localUserSurname);
        await prefs.setString('userId', uid);
        print(
            "User Name: $localUserName"); // Print the user's name to the console
      } else {
        print("No user is signed in.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var _pageIndex = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black54,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 40), // to add some space at the beginning
            Expanded(
              child: Center(
                child: Text(
                  "Hoşgeldin $localUserName ",
                  style: GoogleFonts.belleza(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.person_search,
                color: AppColors.white,
                size: 30,
              ),
              onPressed: () {
                // Handle icon press
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Günün Popüleri",
                style: GoogleFonts.belleza(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: trendingMovies,
                builder: (context, AsyncSnapshot<List<movie.Result>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    return popular(snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Yakında Popüler",
                style: GoogleFonts.belleza(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: upcomingMovies,
                builder: (context, AsyncSnapshot<List<movie.Result>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    return MovieSlider(snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 16),
              /* Text(
                "Size Özel",
                style: GoogleFonts.belleza(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),*/
              const SizedBox(height: 16),
              Text(
                "En Yüksek Puanlı Filmler",
                style: GoogleFonts.belleza(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: topRatedMovies,
                builder: (context, AsyncSnapshot<List<movie.Result>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    return MovieSlider(snapshot: snapshot);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black54,
      bottomNavigationBar: BottomNavBar(
        pageIndex: _pageIndex,
        onPageChanged: (int index) {
          setState(() {
            _pageIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupriseMePage()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WatchlistPage()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
    );
  }

  SizedBox third() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.amber,
                height: 300,
                width: 150,
              ),
            ),
          );
        },
      ),
    );
  }
}
