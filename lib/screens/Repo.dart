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
      name: json['name']??'',
      description: json['description']??'',
      owner: json['owner']['login']??'',
      htmlUrl: json['html_url']??'',
    );
  }
}

class GithubApi {
  final String owner;

  GithubApi({required this.owner});

  Future<List<Repository>> fetchRepositories() async {
    final response = await http.get(Uri.parse('https://api.github.com/users/$owner/repos'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((repo) => Repository.fromJson(repo)).toList();
    } else {
      throw Exception('Failed to load Repositories');
    }
  }
}

class Repo extends StatefulWidget {
  const Repo({super.key});

  @override
  State<Repo> createState() => _RepoState();
}

class _RepoState extends State<Repo> {
  final TextEditingController ownerController = TextEditingController();
  Future<List<Repository>>? futureRepositories;

  void _fetchRepositories() {
    final owner = ownerController.text;

    if (owner.isNotEmpty) {
      setState(() {
        futureRepositories = GithubApi(owner: owner).fetchRepositories();
      });
    }
  }
   void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      
      await launchUrl(uri,mode: LaunchMode.inAppWebView);
      
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repositories')),
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              controller: ownerController,
              decoration: InputDecoration(
                labelText: 'Repository Owner',
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(width: 2.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 2.5),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _fetchRepositories,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Fetch Repositories'),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder<List<Repository>>(
                future: futureRepositories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Repositories found.'));
                  }
                  final repositories = snapshot.data!;

                  return ListView.builder(
                    itemCount: repositories.length,
                    itemBuilder: (context, index) {
                      final repo = repositories[index];
                      return ListTile(
                        title: Text(repo.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${repo.description}'),
                            Text('Owner: ${repo.owner}'),
                          ],
                        ),
                        onTap: () =>_launchURL(repo.htmlUrl),
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

  
}
