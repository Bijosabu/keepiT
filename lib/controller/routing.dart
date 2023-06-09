import 'package:get/get.dart';
import 'package:keepit/view/addCategories/add_categories.dart';
import 'package:keepit/view/addCategories/add_files.dart';
import 'package:keepit/view/addFiles/add_license.dart';
import 'package:keepit/view/addFiles/add_pan.dart';
import 'package:keepit/view/authentication/forgot_password.dart';

import '../view/addFiles/add_files_page.dart';

class RoutingPage {
  void folderToAddPage() {
    Get.to(() => const AddFilesPage());
  }

  AddPageToFolder() {
    Get.back();
  }

  void addLicense() {
    Get.to(() => const AddLicensePage());
  }

  void addPan() {
    Get.to(() => const AddPanPage());
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
