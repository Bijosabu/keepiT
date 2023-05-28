import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({super.key, this.searchController});
  final TextEditingController? searchController;
  Future<List<String>> fetchFileNames() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final path = 'users/$userId/';

    // Use the appropriate method to fetch file names from the path
    // For example, if you're using Firebase Cloud Storage, you can use the following code:
    final ListResult result =
        await FirebaseStorage.instance.ref(path).listAll();
    final List<String> fileNames = result.items.map((ref) => ref.name).toList();

    return fileNames;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: searchController,
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: 'Search files...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
