import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:keepit/controller/routing.dart';
import 'package:keepit/core/constants/constants.dart';
import 'package:file_picker/file_picker.dart';

class AddFilesPage extends StatefulWidget {
  const AddFilesPage({super.key});

  @override
  State<AddFilesPage> createState() => _AddFilesPageState();
}

class _AddFilesPageState extends State<AddFilesPage> {
  PlatformFile? pickedFile;
  String? fileUrl;
  UploadTask? uploadTask;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    setState(() {
      pickedFile = result!.files.first;
    });
  }

  Future upLoadFile() async {
    final path = 'adharfile/${pickedFile!.name}';
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
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (fileUrl == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Add files',
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
              kHeight10,
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                    width: 1.0,
                  ),
                ),
                height: 400,
                width: double.infinity,
                child: pickedFile != null ? buildPreviewWidget() : Container(),
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
                    'Select Files',
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
                    'Upload files',
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
    } else if (fileUrl != null) {
      return Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(fileUrl!),
              fit: BoxFit.cover,
            )),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
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
    } else {
      return const Text('Unsupported File Type');
    }
  }
}
