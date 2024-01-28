import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key,required this.onPickImage});
  final void Function(File pickedImage) onPickImage;
  @override
  State<StatefulWidget> createState() {
    return _UserImagePicker();
  }
}

class _UserImagePicker extends State<UserImagePicker> {
  File? pickedImageFile;
  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
    widget.onPickImage(pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 26,
        ),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:  pickedImageFile != null ? FileImage(pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.camera_enhance_sharp),
          label: Text(
            'Add Image',
            style: GoogleFonts.patrickHand(),
          ),
        )
      ],
    );
  }
}
