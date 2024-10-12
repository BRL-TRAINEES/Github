import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SearchResult {
  final String name;
  final String description;
  final String url;

  SearchResult({
    required this.name,
    required this.description,
    required this.url,
  });

  factory SearchResult.fromRepoJson(Map<String, dynamic> json) {
    return SearchResult(
      name: json['name'] ,
      description: json['description'] ,
      url: json['html_url'] ,
    );
  }

  factory SearchResult.fromUserJson(Map<String, dynamic> json) {
    return SearchResult(
      name: json['login'] ,
      description: json['html_url'] ,
      url: json['html_url'],
    );
  }

  factory SearchResult.fromIssueJson(Map<String, dynamic> json) {
    return SearchResult(
      name: json['title'],
      description: json['body'] ,
      url: json['html_url'] ,
    );
  }
}

class GithubApi {
  Future<List<SearchResult>> search(String query) async {
    final response = await http.get(Uri.parse('https://api.github.com/search/repositories?q=$query'));
    final userResponse = await http.get(Uri.parse('https://api.github.com/search/users?q=$query'));
    final issueResponse = await http.get(Uri.parse('https://api.github.com/search/issues?q=$query'));

    List<SearchResult> results = [];

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['items'];
      results.addAll(jsonResponse.map((repo) => SearchResult.fromRepoJson(repo)).toList());
    }

    if (userResponse.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(userResponse.body)['items'];
      results.addAll(jsonResponse.map((user) => SearchResult.fromUserJson(user)).toList());
    }

    if (issueResponse.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(issueResponse.body)['items'];
      results.addAll(jsonResponse.map((issue) => SearchResult.fromIssueJson(issue)).toList());
    }

    return results;
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  Future<List<SearchResult>>? futureResults;

  void _search() {
    final query = searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        futureResults = GithubApi().search(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search GitHub')),
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(width: 2.5),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) => _search(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _search,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<SearchResult>>(
                future: futureResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No results found.'));
                  }

                  final results = snapshot.data!;
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return ListTile(
                        title: Text(result.name),
                        subtitle: Text(result.description),
                        onTap: () => _launchURL(result.url),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

