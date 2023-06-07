import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  Future<void> fetchFileUrls() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, handle the case accordingly
      return;
    }

    final userId = user.uid;
    final ref = FirebaseStorage.instance.ref('users/$userId/allfiles');
    final result = await ref.listAll();

    final urls =
        await Future.wait(result.items.map((item) => item.getDownloadURL()));
    fileUrls.addAll(urls);
  }
}
