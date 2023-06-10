// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keepit/controller/important_files_controller.dart';
import 'package:keepit/controller/routing.dart';
import 'package:keepit/core/constants/constants.dart';
import 'package:video_player/video_player.dart';

class AddFilesPage extends StatelessWidget {
  final String mainFileName;
  AddFilesPage({super.key, required this.mainFileName});

//   static PlatformFile? pickedFile;
  final mainFileController = Get.put(MainFilesController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mainFileController.fetchUrl(mainFileName);
    });
    // final String fileUrl = mainFileController.fileUrl.value;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: GetX<MainFilesController>(builder: (mainFileController) {
        final String fileUrl = mainFileController.fileUrl.value;
        final pickedFile = mainFileController.pickedFile.value;
        if (fileUrl == null || fileUrl == '') {
          // Center(
          //   child: CircularProgressIndicator(),
          // );
          // final pickedFile = mainFileController.pickedFile.value;
          return Column(
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
                  child: pickedFile != null
                      ? (pickedFile.extension == 'jpg' ||
                              pickedFile.extension == 'png' ||
                              pickedFile.extension == 'webp' ||
                              pickedFile.extension == 'jpeg')
                          ? Image.file(
                              File(pickedFile.path!),
                              fit: BoxFit.fill,
                            )
                          : (pickedFile.extension == 'pdf')
                              ? const Text('PDF Preview')
                              : (pickedFile.extension == 'txt')
                                  ? const Text('Text Preview')
                                  : (pickedFile.extension == 'mp4')
                                      ? AspectRatio(
                                          aspectRatio: 1.0,
                                          child: VideoPlayer(
                                            VideoPlayerController.file(
                                              File(pickedFile.path!),
                                            ),
                                          ),
                                        )
                                      : const Text('Unsupported File Type')
                      : Container(),
                ),
              ),
              kHeight20,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    mainFileController.selectFile();
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
                    mainFileController.upLoadFile(context, mainFileName);
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
          );
        } else {
          return Column(
            children: [
              Text(
                'File Already saved',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[500],
                ),
              ),
              kHeight20,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      image: DecorationImage(
                        image: NetworkImage(fileUrl),
                        fit: BoxFit.fill,
                      )),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await mainFileController.deleteFile(context, mainFileName);
                  mainFileController.selectFile();
                },
                child: const Text('Delete and Replace file'),
              )
            ],
          );
        }
      })),
    );
  }
}
