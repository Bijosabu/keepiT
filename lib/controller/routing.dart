import 'package:get/get.dart';

import '../view/addFiles/add_files_page.dart';

class RoutingPage {
  void folderToAddPage() {
    Get.to(() => const AddFilesPage());
  }

  AddPageToFolder() {
    Get.back();
  }
}
