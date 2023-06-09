import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keepit/controller/routing.dart';
import 'package:keepit/core/constants/constants.dart';
import 'package:keepit/view/home/home_page.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class AddFiles extends StatefulWidget {
  const AddFiles({super.key});

  @override
  State<AddFiles> createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {
  static PlatformFile? pickedFile;
  static String? fileUrl;
  UploadTask? uploadTask;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    setState(() {
      pickedFile = result!.files.first;
    });
  }

  // void sendFCMMessage() async {
  //   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  //   await firebaseMessaging.sendMessage(
  //     data: {
  //       'inAppMessage': 'New file added!',
  //     },
  //   );
  // }

  Future upLoadFile() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final path = 'users/$userId/allfiles/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Add file',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[200],
                    border: Border.all()),
                height: 400,
                width: double.infinity,
                child: pickedFile != null ? buildPreviewWidget() : Container(),
              ),
            ),
            kHeight20,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  selectFile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Select File',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            kHeight20,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  upLoadFile();
                },
                child: const Text(
                  'Upload file',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            kHeight30,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    RoutingPage().AddPageToFolder();
                  },
                  child: const Text('Go back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPreviewWidget() {
    if (pickedFile!.extension == 'jpg' ||
        pickedFile!.extension == 'png' ||
        pickedFile!.extension == 'webp' ||
        pickedFile!.extension == 'jpeg') {
      return Image.file(
        File(pickedFile!.path!),
        fit: BoxFit.fill,
      );
    } else if (pickedFile!.extension == 'pdf') {
      return const Text('PDF Preview');
    } else if (pickedFile!.extension == 'txt') {
      return const Text('Text Preview');
    } else if (pickedFile!.extension == 'mp4') {
      final videoPlayerController = VideoPlayerController.file(
        File(pickedFile!.path!),
      );

      return AspectRatio(
        aspectRatio: videoPlayerController.value.aspectRatio,
        child: VideoPlayer(videoPlayerController),
      );
    } else {
      return const Text('Unsupported File Type');
    }
  }

  // Widget buildPreviewWidget() {
  //   if (pickedFile!.extension == 'jpg' ||
  //       pickedFile!.extension == 'png' ||
  //       pickedFile!.extension == 'webp' ||
  //       pickedFile!.extension == 'jpeg') {
  //     return Image.file(
  //       File(pickedFile!.path!),
  //       fit: BoxFit.fill,
  //     );
  //   } else if (pickedFile!.extension == 'pdf') {
  //     return const Text('PDF Preview');
  //   } else if (pickedFile!.extension == 'txt') {
  //     return const Text('Text Preview');
  //   } else {
  //     return const Text('Unsupported File Type');
  //   }
  // }
}
