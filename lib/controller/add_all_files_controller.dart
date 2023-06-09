import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFileController extends GetxController {
  final fileUrls = <String>[].obs;
  // Future<void> fetchFileUrls() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final userId = user?.uid;
  //   final ref = FirebaseStorage.instance.ref('users/$userId/allfiles');
  //   final result = await ref.listAll();

  //   final urls =
  //       await Future.wait(result.items.map((item) => item.getDownloadURL()));
  //   fileUrls.addAll(urls);
  // }
  @override
  void onInit() {
    super.onInit();
    fetchFileUrls();
  }

  Future<void> fetchFileUrls() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, handle the case accordingly
      return;
    } else {
      final userId = user.uid;
      final ref = FirebaseStorage.instance.ref('users/$userId/allfiles');
      final result = await ref.listAll();

      final urls =
          await Future.wait(result.items.map((item) => item.getDownloadURL()));
      print(urls);
      fileUrls.addAll(urls);
    }
  }

  Future<void> deleteFile(int index, BuildContext context) async {
    final ref = FirebaseStorage.instance.refFromURL(fileUrls[index]);
    await ref.delete();

    fileUrls.removeAt(index);
    update();

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
