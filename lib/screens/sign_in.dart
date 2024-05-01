import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_movie_app/screens/sign_up.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final storage =
      FirebaseStorage.instanceFor(bucket: "gs://btbs-movie.appspot.com/");

  String _email = '';
  String _password = '';
  String _error = '';
  Uint8List? _logo;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print('E-posta ile giriş yapıldı: ${userCredential.user!.uid}');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      print('E-posta ile giriş yaparken hata oluştu: $_error');
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print('Google ile giriş yapıldı: ${userCredential.user!.uid}');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      print('Google ile giriş yaparken hata oluştu: $_error');
    }
  }

  Future<void> _fetchLogo() async {
    try {
      final imageData =
          await storage.ref().child('beyaz_png.png').getData(1024 * 1024);
      setState(() {
        _logo = imageData;
      });
    } catch (e) {
      print('Resim alınamadı: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        title: Center(
          child: Text(
            'diji - Giriş Yap',
            style: TextStyle(color: AppColors.white),
          ),
        ),
        backgroundColor: AppColors.red,
      ),
      body: SingleChildScrollView(
        // Ekran küçük olduğunda içeriği kaydır
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logo != null
                  ? Image.memory(
                      _logo!,
                      width: 250,
                      height: 250,
                    )
                  : SizedBox(height: 10),
              SizedBox(height: 20),
              TextField(
                autofocus: true, // Klavye açılınca otomatik olarak odaklan
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
                style: TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'E-posta',
                  hintStyle: TextStyle(color: AppColors.white),
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
                obscureText: true,
                style: TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Şifre',
                  hintStyle: TextStyle(color: AppColors.white),
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  _signInWithEmailAndPassword();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.red),
                ),
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                _error,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()),
                  );
                },
                child: Text(
                  'Hesabınız yoksa üye olun',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              SizedBox(height: 20.0),
              OutlinedButton.icon(
                onPressed: () {
                  _signInWithGoogle();
                },
                icon: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                  width: 15,
                  height: 15,
                ),
                label: Text(
                  'Google ile Giriş Yap',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
