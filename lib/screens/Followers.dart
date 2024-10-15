import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class Followers {
  final String login;
  final int id;
  final String htmlUrl;

  Followers({
    required this.login,
    required this.id,
    required this.htmlUrl,
  });

  factory Followers.fromJson(Map<String, dynamic> json) {
    return Followers(
      login: json['login'],
      id: json['id'],
      htmlUrl: json['html_url'],
    );
  }
}

// fetch a list of followers
Future<List<Followers>> fetchFollowers(String username) async {
  final response = await http.get(Uri.parse("https://api.github.com/users/$username/followers"));

  if (response.statusCode == 200) {
    // parse the json response into a list 
    List<dynamic> followersJson = jsonDecode(response.body);
    return followersJson.map((json) => Followers.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load followers');
  }
}

class FollowersScreen extends StatefulWidget {
  final String username;
  const FollowersScreen({super.key,required this.username});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  late Future<List<Followers>> futureFollowers;

  @override
  void initState() {
    super.initState();
    futureFollowers = fetchFollowers(widget.username);//fetch followers for the username provided
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: FutureBuilder<List<Followers>>(
        future: futureFollowers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ) {
            return Center(child: Text('No followers found'));
          }

          
          List<Followers> followers = snapshot.data!;//create a list of data

          return ListView.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(followers[index].login),
                subtitle: Text('ID: ${followers[index].id}'),
                
                onTap: () async {
                  final Uri url = Uri.parse(followers[index].htmlUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch ${followers[index].htmlUrl}';
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
