import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:keepit/controller/routing.dart';
import 'package:keepit/core/constants/constants.dart';
import 'package:keepit/model/services/google_auth_services.dart';
import 'package:keepit/view/home/search_results.dart';
import 'package:keepit/view/widgets/main_folder.dart';

// import '../addFiles/add_license.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> allFileNames = [];
  List<String> searchResults = [];
  final TextEditingController? searchController = TextEditingController();
  Future<List<String>> fetchFileNames() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final path = 'users/$userId/';

    final ListResult result =
        await FirebaseStorage.instance.ref(path).listAll();
    final List<String> fileNames = result.items.map((ref) => ref.name).toList();

    return fileNames;
  }

  Future<void> fetchAllFileNames() async {
    final fileNames = await fetchFileNames();
    setState(() {
      allFileNames = fileNames;
    });
  }

  void navigateToSearchResultsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResults(searchResults: searchResults),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAllFileNames();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user!.email;
    final name = email!.substring(0, email.indexOf('@')).toUpperCase();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome $name',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                AuthService().signOutGoogle();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.logout),
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kHeight20,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchResults = allFileNames.where((fileName) {
                        // Perform case-insensitive search based on file names
                        return fileName
                            .toLowerCase()
                            .contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search files...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (searchResults.isNotEmpty)
                ElevatedButton(
                  onPressed: navigateToSearchResultsPage,
                  child: Text('View Search Results'),
                ),
              kHeight20,
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5, left: 10),
                child: Row(
                  children: [
                    Text(
                      'Important files',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              kHeight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  kWidth10,
                  MainFolder(
                      text: 'Aadhar',
                      onTap: () {
                        RoutingPage().folderToAddPage();
                      }),
                  kWidth10,
                  MainFolder(
                      text: 'PAN',
                      onTap: () {
                        RoutingPage().addPan();
                      }),
                  kWidth10,
                  MainFolder(
                    text: 'License',
                    onTap: () {
                      RoutingPage().addLicense();
                    },
                  ),
                  kWidth10,
                ],
              ),
              kHeight20,
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5, left: 10),
                child: Row(
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              kHeight30,
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: MainFolder(
                      text: 'All Files',
                      onTap: () {
                        return RoutingPage().addCategories();
                      },
                    ),
                  ),
                ],
              ),
              kHeight30,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add,
          )),
    );
  }
}
