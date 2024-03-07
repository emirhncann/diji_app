import 'package:flutter/material.dart';
import 'package:social_movie_app/constants/color.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _email = 'test@emir.com';
  String _phone = '+1234567890';
  List<String> _selectedCategories = []; // Seçilen kategoriler listesi
  List<String> _categories = [
    'Aksiyon',
    'Macera',
    'Komedi',
    'Dram',
    'Fantastik',
    'Korku',
    'Gizem',
    'Romantik',
    'Bilim Kurgu',
    'Gerilim',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonIcon(),
        backgroundColor: AppColors.red,
        title: Text('Hesabım', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile_image.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'E-posta: $_email',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Telefon: $_phone',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Profilde Gözüksün (en fazla 5 adet seçebilirsiniz)',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              alignment: WrapAlignment.center,
              children: _categories.map<Widget>((category) {
                return FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(color: Colors.white),
                  ),
                  selected: _selectedCategories.contains(category),
                  selectedColor: AppColors.red,
                  backgroundColor: AppColors.black,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        if (_selectedCategories.length < 5) {
                          _selectedCategories.add(category);
                        } else {
                          // En fazla 5 kategori seçilebilir
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('En fazla 5 kategori seçebilirsiniz!'),
                          ));
                        }
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                // Kategorileri kaydetme işlemi
              },
              child: Text(
                'Değişiklikleri Kaydet',
                style: TextStyle(color: AppColors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.red),
              ),
            )
          ],
        ),
      ),
      backgroundColor: AppColors.dark,
    );
  }
}
