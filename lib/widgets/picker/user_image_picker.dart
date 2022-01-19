import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  
  File? _storedImage;
  Future<void> _takePicture()async{
    final picker=ImagePicker();
    
    final imageFile=await picker.getImage(
        source: ImageSource.gallery,
    imageQuality: 50,
    maxWidth: 200);
    if (imageFile==null)return;
    setState(() {
      _storedImage=File(imageFile.path);
    });
    widget.imagePickFn(_storedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 40,
          backgroundColor: Colors.green,
          backgroundImage: _storedImage!=null? FileImage(_storedImage!):null,
        ),
        FlatButton.icon(onPressed: _takePicture,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),),
      ],
    );
  }
}
