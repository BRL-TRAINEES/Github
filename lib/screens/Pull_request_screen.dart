import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class PullRequest{
  final String title;
  final String body;
  final String state;

  PullRequest({required this.title ,required this.body , required this.state});
  factory PullRequest.fromJson(Map<String , dynamic> json) {
    return PullRequest(title: json['title'], body: json['body'], state: json['state']);
  }
}
// Git hub API service
class GithubApi {
  final String owner;
  final String repo;

  GithubApi({required this.owner, required this.repo});

  Future<List<PullRequest>> fetchPullRequests() async {
    final response = await http.get(Uri.parse('https://api.github.com/repos/$owner/$repo/pulls'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((pr) => PullRequest.fromJson(pr)).toList();
    } else {
      throw Exception('Failed to load Pull Requests');
    }
  }
}

class PullRequestScreen extends StatefulWidget {
  const PullRequestScreen({super.key});

  @override
  State<PullRequestScreen> createState() => _PullRequestScreenState();
}

class _PullRequestScreenState extends State<PullRequestScreen> {
   final TextEditingController ownerController = TextEditingController();
  final TextEditingController repoController = TextEditingController();
  Future<List<PullRequest>>? futurePullRequests;

  void _fetchPullRequest() {
    final owner = ownerController.text;
    final repo = repoController.text;

    if (owner.isNotEmpty && repo.isNotEmpty) {
      setState(() {
        futurePullRequests = GithubApi(owner: owner, repo: repo).fetchPullRequests();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pull Requests')),
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50), // Adjust spacing
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
            TextField(
              controller: repoController,
              decoration: InputDecoration(
                labelText: 'Repository Name',
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 2.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                ),
                prefixIcon: const Icon(Icons.book, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _fetchPullRequest,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Fetch Pull Requests'),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder<List<PullRequest>>(
                future: futurePullRequests,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Pull Requests found.'));
                  }
                  final pullRequests = snapshot.data!;

                  return ListView.builder(
                    itemCount: pullRequests.length,
                    itemBuilder: (context, index) {
                      final pullRequest = pullRequests[index];
                      return ListTile(
                        title: Text(pullRequest.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pullRequest.state),
                            const SizedBox(height: 4.0),
                            Text(pullRequest.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
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
