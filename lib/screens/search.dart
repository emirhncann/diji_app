import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_movie_app/constants/color.dart';
import 'package:social_movie_app/screens/search_profile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> users = querySnapshot.docs
        .where((doc) =>
            doc['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .map((doc) =>
            {'uid': doc.id, 'name': doc['name'], 'surname': doc['surname']})
        .toList();

    setState(() {
      _searchResults = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kullanıcı Ara',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Kullanıcı Adı Giriniz',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchUsers(_searchController.text),
                ),
              ),
              onChanged: (value) => _searchUsers(value),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            uid: _searchResults[index]['uid'],
                            name: _searchResults[index]['name'],
                            surname: _searchResults[index]['surname'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                          '${_searchResults[index]['name']} ${_searchResults[index]['surname']}',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black54,
    );
  }
}
