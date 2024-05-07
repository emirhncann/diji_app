import 'package:flutter/material.dart';
import 'package:social_movie_app/constants/color.dart';

class AddPostDialog extends StatefulWidget {
  final Function(String, String) onPostAdded;

  const AddPostDialog({Key? key, required this.onPostAdded}) : super(key: key);

  @override
  _AddPostDialogState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  String filmName = '';
  String comment = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.dark,
      title: Text(
        'Gönderi ekle',
        style: TextStyle(color: AppColors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Film Adı'),
            onChanged: (value) {
              setState(() {
                filmName = value;
              });
            },
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: "Yorumunuz"),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            onChanged: (value) {
              setState(() {
                comment = value;
              });
            },
          ),
          SizedBox(height: 10),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Yorumu paylaş
            widget.onPostAdded(filmName, comment);
            Navigator.pop(context);
          },
          child: Text("Paylaş"),
        ),
      ],
    );
  }
}
