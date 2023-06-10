import 'package:get/get.dart';
import 'package:keepit/view/addCategories/add_categories.dart';
import 'package:keepit/view/addCategories/add_files.dart';

import 'package:keepit/view/authentication/forgot_password.dart';

import '../view/mainFiles/main_files_page.dart';

class RoutingPage {
  // void folderToAddPage() {
  //   Get.to(() => AddFilesPage());
  // }

  AddPageToFolder() {
    Get.back();
  }

  void addCategories() {
    Get.to(() => AddCategories());
  }

  void addAllFiles() {
    Get.to(() => const AddFiles());
  }

  void goToForgotPassword() {
    Get.to(
      () => const ForgotPassword(),
    );
  }
}
