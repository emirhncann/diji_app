import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Klavye açılınca sayfanın yukarı kaymaması için eklenen satır
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/beyaz_png.png"),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),

          // Antrasit renkte alt kısım
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // E-posta Adresi Girişi
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'E-posta',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Şifre Girişi
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Şifremi Unuttum',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 16),

                    // Giriş Butonu
                    ElevatedButton(
                      onPressed: () {
                        // Giriş butonuna tıklama işlemleri
                      },
                      child: Text('Giriş Yap'),
                    ),

                    SizedBox(height: 16),

                    // Google ile Giriş Butonu
                    OutlinedButton(
                      onPressed: () {
                        // Google ile giriş butonuna tıklama işlemleri
                      },
                      child: Text('Google ile Giriş Yap'),
                    ),

                    SizedBox(height: 16),

                    // Üye Ol Mesajı
                    Text(
                      'Hesabınız yok mu? Hemen üye olun',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
