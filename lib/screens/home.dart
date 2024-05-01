import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:social_movie_app/constants/bottom_nav_bar.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:social_movie_app/screens/account.dart';
import 'package:social_movie_app/screens/my_profile.dart';
import 'package:social_movie_app/screens/suprise.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var _pageIndex = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Text(
          'Diji ',
          style: TextStyle(color: AppColors.white),
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
                "Popüler Filmler",
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                  width: double.infinity,
                  child: CarouselSlider.builder(
                    itemCount: 10,
                    options: CarouselOptions(
                        height: 300,
                        autoPlay: true,
                        viewportFraction: 0.55,
                        enlargeCenterPage: true,
                        pageSnapping: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlayAnimationDuration: const Duration(seconds: 2)),
                    itemBuilder: (context, itemIndex, PageViewIndex) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 300,
                          width: 200,
                          color: Colors.amber,
                        ),
                      );
                    },
                  )),
              const SizedBox(height: 16),
              Text("En Yüksek Puanlı Filmler"),
              SizedBox(
                height: 16,
              ),
              SizedBox(
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
                          ));
                    }),
              ),
              const SizedBox(height: 16),
              Text("En Yüksek Puanlı Filmler"),
              SizedBox(
                height: 16,
              ),
              SizedBox(
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
                          ));
                    }),
              ),
              const SizedBox(height: 16),
              Text("En Yüksek Puanlı Filmler"),
              SizedBox(
                height: 16,
              ),
              SizedBox(
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
                          ));
                    }),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.dark,
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
}
