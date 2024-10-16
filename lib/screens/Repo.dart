import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Repo {
  final String name;
  final int id;
  final String htmlUrl;

  Repo({
    required this.name,
    required this.id,
    required this.htmlUrl,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      id: json['id'],
      htmlUrl: json['html_url'], // Fix key to match GitHub API response
    );
  }
}

Future<List<Repo>> fetchRepo(String username) async {
  final response = await http.get(Uri.parse("https://api.github.com/users/$username/repos"));

  if (response.statusCode == 200) {
    List<dynamic> repoJson = jsonDecode(response.body);
    return repoJson.map((json) => Repo.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Repositories');
  }
}

class RepositoriesScreen extends StatefulWidget {
  final String username;
  const RepositoriesScreen({super.key, required this.username});

  @override
  State<RepositoriesScreen> createState() => _RepositoriesScreenState();
}

class _RepositoriesScreenState extends State<RepositoriesScreen> {
  late Future<List<Repo>> futureRepos;

  @override
  void initState() {
    super.initState();
    futureRepos = fetchRepo(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories',
        style: TextStyle(color: Colors.white,
        fontSize: 18),
        ),
        backgroundColor: const Color(0xFF2B2B2B),
       iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Repo>>(
        future: futureRepos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No repositories found'));
          }

          List<Repo> repos = snapshot.data!;
          return ListView.builder(
            itemCount: repos.length,
            itemBuilder: (context, index) {
              return Column(
                children : [
              ListTile(
                title: Text(repos[index].name,
                style: const TextStyle(color: Colors.white),),
                subtitle: Text('ID: ${repos[index].id}',
                style: const TextStyle(color: Colors.white),),
                onTap: () async {
                  final Uri url = Uri.parse(repos[index].htmlUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch ${repos[index].htmlUrl}';
                  }
                },
              ),
              const Divider(
                color: Colors.white54,
                thickness:1,),
                ],
              );

            },
          
          );
        },
      ),
    );
  }
}
