import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFD9D9D9),
      appBar: AppBar(
        title: Text('Kayıt Ol'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: height * 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(_nameController, 'Ad', Icons.person),
              SizedBox(height: 16.0),
              _buildTextField(_surnameController, 'Soyad', Icons.person),
              SizedBox(height: 16.0),
              _buildTextField(_emailController, 'E-posta', Icons.email,
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: 16.0),
              _buildTextField(_phoneController, 'Telefon Numarası', Icons.phone,
                  keyboardType: TextInputType.phone),
              SizedBox(height: 16.0),
              _buildTextField(_passwordController, 'Şifre', Icons.lock,
                  obscureText: true),
              SizedBox(height: 16.0),
              _buildTextField(
                  _confirmPasswordController, 'Şifre Tekrar', Icons.lock,
                  obscureText: true),
              SizedBox(height: 32.0),
              Container(
                width: width * 0.9,
                height: 60,
                child: _isLoading
                    ? CircularProgressIndicator() // Loading animasyonu
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0D9E2A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                await registerUser();
                              },
                        child: Text(
                          'Kayıt Ol',
                          style: GoogleFonts.kanit(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    try {
      setState(() {
        _isLoading = true; // Loading animasyonunu göster
      });

      // Firebase Authentication ile kullanıcı oluştur
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Firebase Firestore kullanıcıları koleksiyonuna veriyi kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!
              .uid) // Kullanıcının UID'si ile belirtilen bir doküman oluştur
          .set({
        'name': _nameController.text,
        'surname': _surnameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        // İhtiyaca göre diğer alanları ekleyebilirsiniz
      });

      setState(() {
        _isLoading = false; // Loading animasyonunu kapat
      });

      // Kayıt başarılı
      print('Kullanıcı başarıyla kaydedildi.');
    } catch (error) {
      // Hata durumunda kullanıcıya bilgi ver
      print('Kayıt sırasında bir hata oluştu: $error');
      setState(() {
        _isLoading = false; // Loading animasyonunu kapat
      });
    }
  }
}
