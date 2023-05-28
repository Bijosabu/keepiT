import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  final List<String> searchResults;
  const SearchResults({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final fileName = searchResults[index];
        return ListTile(
          title: Text(fileName),
        );
      },
    );
  }
}
