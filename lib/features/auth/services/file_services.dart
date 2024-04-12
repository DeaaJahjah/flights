import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileDbService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadeimage(String name, File image, BuildContext context) async {
    try {
      await storage.ref(name).putFile(image);
      return storage.ref(name).getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.toString());
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return 'error';
    }
  }

  Future<String> uploadeImageByte(String name, Uint8List image, BuildContext context) async {
    try {
      await storage.ref(name).putData(image);
      return storage.ref(name).getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.toString());
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return 'error';
    }
  }

  Future<List<String>> uploadeimages(List<XFile> files, BuildContext context) async {
    List<String> urls = [];
    try {
      for (int i = 0; i < files.length; i++) {
        File file = File(files[i].path);
        String name = files[i].path;
        await storage.ref(name).putFile(file);
        String url = await storage.ref(name).getDownloadURL();
        urls.add(url);
      }
      return urls;
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return [];
    }
  }

  Future<String> uploadeFile(String name, Uint8List file, BuildContext context) async {
    try {
      await storage.ref(name).putData(file);
      return storage.ref(name).getDownloadURL();
    } on FirebaseException catch (e) {
      showErrorSnackBar(context, e.message!);
      return 'error';
    }
  }
}
