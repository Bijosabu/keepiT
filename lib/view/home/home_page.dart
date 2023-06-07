import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:keepit/controller/routing.dart';
import 'package:keepit/core/constants/constants.dart';
import 'package:keepit/model/services/google_auth_services.dart';
import 'package:keepit/view/home/search_results.dart';
import 'package:keepit/view/widgets/main_folder.dart';

import '../../core/debounce/debounce,.dart';

// import '../addFiles/add_license.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String folderNameInput = '';
  List<String> folders = [];
  List<String> allFileNames = [];
  List<String> searchResults = [];
  List<String> fileUrls = [];
  final _debouncer = Debouncer(milliseconds: 1 * 1000);
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

  Future<void> fetchFileUrls(String query) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final ref = FirebaseStorage.instance.ref('users/$userId/');
    final result = await ref.listAll();
    final filteredItems = result.items.where((item) {
      // Match the item's name against the query (case-insensitive partial match)
      final itemName = item.name.toLowerCase();
      final queryLowerCase = query.toLowerCase();
      return itemName.contains(queryLowerCase);
    });

// Get the download URLs of the filtered items
    final urls =
        await Future.wait(filteredItems.map((item) => item.getDownloadURL()));

    // final urls =
    //     await Future.wait(result.items.map((item) => item.getDownloadURL()));

    setState(() {
      fileUrls = urls;
    });

    if (fileUrls.isEmpty) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Results'),
            content: const Text('No files found for the given query.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK')),
              ),
            ],
          );
        },
      );
    }
    print(fileUrls);
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
        // automaticallyImplyLeading: false,
        // title: Text(
        //   'Welcome $name',
        //   style: const TextStyle(
        //     color: Colors.white,
        //     fontSize: 20,
        //   ),
        // ),
        backgroundColor: Colors.blue, foregroundColor: Colors.white,
        // actions: [
        //   GestureDetector(
        //       onTap: () {
        //         FirebaseAuth.instance.signOut();
        //         AuthService().signOutGoogle();
        //       },
        //       child: const Padding(
        //         padding: EdgeInsets.only(right: 10),
        //         child: Icon(Icons.logout),
        //       ))
        // ],
      ),
      drawer: Drawer(
          child: Container(
        color: Colors.white10,
        child: ListView(
          children: [
            DrawerHeader(
                child: Center(
              child: Row(
                children: [
                  Text(
                    'KEEP IT',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            )),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                AuthService().signOutGoogle();
              },
              child: const ListTile(
                leading: Icon(
                  Icons.logout,
                  size: 25,
                ),
                title: Text(
                  'Signout',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kHeight10,
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  "Welcome $name",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              kHeight20,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    _debouncer.run(() {
                      fetchFileUrls(value);
                    });
                  },
                  decoration: InputDecoration(
                    // suffixIcon: GestureDetector(
                    //     onTap: () {}, child: Icon(Icons.get_app)),
                    hintText: 'Search files...',
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (searchResults.isNotEmpty)
                ElevatedButton(
                  onPressed: navigateToSearchResultsPage,
                  child: const Text('View Search Results'),
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
              kHeight10,
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
              SingleChildScrollView(
                child: Expanded(
                  child: GestureDetector(
                    onTap: () {
                      return RoutingPage().addCategories();
                    },
                    onLongPress: () {},
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: folders.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return MainFolder(text: folders[index]);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Create folder'),
                  content: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onChanged: (value) {
                      setState(() {
                        folderNameInput = value;
                      });
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        createNewFolder(folderNameInput);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Create'),
                    )
                  ],
                );
              },
            );
          },
          child: const Icon(
            Icons.add,
          )),
    );
  }

  void createNewFolder(String fileName) {
    setState(() {
      folders.add(fileName);
    });
  }
}
