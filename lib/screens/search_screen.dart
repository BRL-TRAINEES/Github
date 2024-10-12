import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Repository {
  final String name;
  final String description;
  final String owner;
  final String htmlUrl;

  Repository({
    required this.name,
    required this.description,
    required this.owner,
    required this.htmlUrl,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'],
      owner: json['owner']['login'],
      htmlUrl: json['html_url'],
    );
  }
}

class GithubApi {
  Future<List<Repository>> fetchRepositories(String owner) async {
    final response = await http.get(Uri.parse('https://api.github.com/users/$owner/repos'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((repo) => Repository.fromJson(repo)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController ownerController = TextEditingController();
  Future<List<Repository>>? futureRepositories;
  List<String> suggestions = [];

  void _searchRepositories(String query) {
    if (query.isNotEmpty) {
      GithubApi().fetchRepositories(query).then((repos) {
        setState(() {
          suggestions = repos.map((repo) => repo.name).toList();
        });
      }).catchError((_) {
        setState(() {
          suggestions = [];
        });
      });
    } else {
      setState(() {
        suggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Repositories')),
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: ownerController,
              onChanged: _searchRepositories,
              decoration: InputDecoration(
                labelText: 'Repository Owner',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(width: 2.5),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      ownerController.text = suggestions[index];
                      setState(() {
                        futureRepositories = GithubApi().fetchRepositories(suggestions[index]);
                        suggestions = [];
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final owner = ownerController.text;
                if (owner.isNotEmpty) {
                  setState(() {
                    futureRepositories = GithubApi().fetchRepositories(owner);
                    suggestions = [];
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Search Repositories'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Repository>>(
                future: futureRepositories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No repositories found.'));
                  }

                  final repositories = snapshot.data!;
                  return ListView.builder(
                    itemCount: repositories.length,
                    itemBuilder: (context, index) {
                      final repo = repositories[index];
                      return ListTile(
                        title: Text(repo.name),
                        subtitle: Text(repo.description),
                        onTap: () {
                          _launchURL(repo.htmlUrl);
                        },
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
