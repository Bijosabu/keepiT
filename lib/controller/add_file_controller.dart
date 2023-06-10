import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keepit/view/home/home_page.dart';

class AddFile extends GetxController {
  Rx<PlatformFile?> pickedFile = Rx<PlatformFile?>(null);
  static String? fileUrl;
  UploadTask? uploadTask;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    } else {
      pickedFile.value = result.files.first;
    }
    update();
  }

  Future upLoadFile(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final path = 'users/$userId/allfiles/${pickedFile.value!.name}';
    final file = File(pickedFile.value!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => null);
    fileUrl = await snapshot.ref.getDownloadURL();

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
    // sendFCMMessage();
  }
}
