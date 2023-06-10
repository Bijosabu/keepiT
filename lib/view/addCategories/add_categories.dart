// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keepit/controller/add_all_files_controller.dart';
import 'package:keepit/controller/routing.dart';

class AddCategories extends StatelessWidget {
  AddCategories({
    super.key,
  });

  final addFileController = Get.put(AddFileController());

  // List<String> fileUrls = [];
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   addFileController.fetchFileUrls();
    //   await Future.delayed(const Duration(seconds: 2));
    // });
    if (addFileController.fileUrls.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text(
            'Add Files to show in this page',
            style: TextStyle(fontSize: 20),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            RoutingPage().addAllFiles();
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'All Files',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetX<AddFileController>(builder: (controller) {
              return ListView.separated(
                itemCount: controller.fileUrls.length,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.blue[200],
                      height: 2,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  final imageUrl = controller.fileUrls[index];
                  return ListTile(
                    leading: Image.network(imageUrl),
                    trailing: GestureDetector(
                        onTap: () {
                          controller.deleteFile(index, context);
                        },
                        child: const Icon(Icons.delete)),
                  );
                },
              );
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            RoutingPage().addAllFiles();
          },
        ),
      );
    }
  }
}
