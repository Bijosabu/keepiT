// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keepit/controller/add_all_files_controller.dart';
import 'package:keepit/controller/routing.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({
    super.key,
  });

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  final addFileController = Get.put(AddFileController());
  List<String> fileUrls = [];

  Future<void> fetchFileUrls() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final ref = FirebaseStorage.instance.ref('users/$userId/allfiles');
    final result = await ref.listAll();

    final urls =
        await Future.wait(result.items.map((item) => item.getDownloadURL()));

    setState(() {
      fileUrls = urls;
    });
  }

  Future<void> deleteFile(int index) async {
    final ref = FirebaseStorage.instance.refFromURL(fileUrls[index]);
    await ref.delete();

    setState(() {
      fileUrls.removeAt(index);
    });

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

  @override
  // void initState() {
  //   super.initState();
  //   fetchFileUrls();
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addFileController.fetchFileUrls();
    });
    if (fileUrls.isEmpty) {
      return Scaffold(
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
                          deleteFile(index);
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
