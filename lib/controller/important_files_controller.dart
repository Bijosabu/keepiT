import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/home/home_page.dart';

class MainFilesController extends GetxController {
  Rx<PlatformFile?> pickedFile = Rx<PlatformFile?>(null);
  RxString fileUrl = ''.obs;
  UploadTask? uploadTask;
  void fetchUrl(String fileName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    } else {
      final userId = user.uid;
      final ref = FirebaseStorage.instance.ref('users/$userId/$fileName');
      final result = await ref.listAll();

      if (result.items.isNotEmpty) {
        final url = await result.items.first.getDownloadURL();
        print(url);
        fileUrl.value = url;
      }
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchUrl('adharfile');
  // }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    pickedFile.value = result!.files.first;
    update();
    print(pickedFile.value);
  }

  Future upLoadFile(BuildContext context, String fileName) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final path = 'users/$userId/$fileName/${pickedFile.value!.name}';
    final file = File(pickedFile.value!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => null);
    fileUrl.value = await snapshot.ref.getDownloadURL();

    print(fileUrl);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('File Uploaded'),
          content: const Text('The file was uploaded successfully.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => const HomePage());
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future deleteFile(BuildContext context, String fileName) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    if (pickedFile.value != null) {
      final path = 'users/$userId/$fileName/${pickedFile.value!.name}';
      final ref = FirebaseStorage.instance.ref().child(path);

      await ref.delete();

      pickedFile.value = null;
      fileUrl.value = '';

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('File Deleted'),
            content: const Text('The file was deleted successfully.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
