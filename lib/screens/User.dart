import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GitHubUser {
  final int id;
  final String login;
  final int publicRepos;
  final int followers;
  final int following;

  GitHubUser({
    required this.id,
    required this.login,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      id: json['id'],
      login: json['login'],
      publicRepos: json['public_repos'],
      followers: json['followers'],
      following: json['following'],
    );
  }
}

Future<GitHubUser?> fetchGitHubUser(String username) async {
  final url = 'https://api.github.com/users/$username';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return GitHubUser.fromJson(data);
  } else {
    return null; 
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: GitHubUserScreen(),
    );
  }
}

// User profile screen widget
class GitHubUserScreen extends StatefulWidget {
  @override
  _GitHubUserScreenState createState() => _GitHubUserScreenState();
}

class _GitHubUserScreenState extends State<GitHubUserScreen> {
  final TextEditingController _controller = TextEditingController();
  String errorMessage = '';
  GitHubUser? user; 

  void _searchUser() {
    final username = _controller.text.trim();
    if (username.isEmpty) {
      setState(() {
        errorMessage = 'Enter a username.'; 
        user = null; 
      });
      return; 
    }

    fetchGitHubUser(username).then((fetchedUser) {
      setState(() {
        user = fetchedUser;
        errorMessage = user == null ? 'User not found.' : ''; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('GitHub User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter GitHub Username',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _searchUser,
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty) 
              Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(fontSize: 18, ),
                ),
              )
            else if (user != null) 
              Expanded(
                child: Container(
                  width: double.infinity, 
                  margin: EdgeInsets.only(top: 20), 
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'GitHub ID: ${user!.id}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Username: ${user!.login}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Public Repos: ${user!.publicRepos}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Followers: ${user!.followers}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Following: ${user!.following}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
