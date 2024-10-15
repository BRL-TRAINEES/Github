import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';


class Following {
  final String login;
  final int id;
  final String htmlUrl;

  Following({
    required this.login,
    required this.id,
    required this.htmlUrl,
  });


  factory Following.fromJson(Map<String, dynamic> json) {
    return Following(
      login: json['login'],
      id: json['id'],
      htmlUrl: json['html_url'],
    );
  }
}


Future<List<Following>> fetchFollowing(String username) async {
  final response =
      await http.get(Uri.parse("https://api.github.com/users/$username/following"));

  if (response.statusCode == 200) {
    List<dynamic> followingJson = jsonDecode(response.body);
    return followingJson.map((json) => Following.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load following');
  }
}

class FollowingScreen extends StatefulWidget {
  final String username;

  const FollowingScreen({super.key, required this.username});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  late Future<List<Following>> futureFollowing;

  @override
  void initState() {
    super.initState();
    
    futureFollowing = fetchFollowing(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: FutureBuilder<List<Following>>(
        future: futureFollowing,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ) {
            return Center(child: Text('No following found'));
          }

          
          List<Following> following = snapshot.data!;

          return ListView.builder(
            itemCount: following.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(following[index].login),
                subtitle: Text('ID: ${following[index].id}'),
                onTap: () async {
                  final Uri url = Uri.parse(following[index].htmlUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch ${following[index].htmlUrl}';
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
