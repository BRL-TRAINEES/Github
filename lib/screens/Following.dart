import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';


class Following {
  final String login;
  final int id;
  final String htmlUrl;
  final String avatar_url;

  Following({
    required this.login,
    required this.id,
    required this.htmlUrl,
    required this.avatar_url,
  });


  factory Following.fromJson(Map<String, dynamic> json) {
    return Following(
      login: json['login'],
      id: json['id'],
      htmlUrl: json['html_url'],
      avatar_url: json['avatar_url']
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
        title: const Text('Following',
        style: TextStyle(color: Colors.white,
        fontSize: 18),
        ),
        backgroundColor: const Color(0xFF2B2B2B),
       iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Following>>(
        future: futureFollowing,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ) {
            return const Center(child: Text('No following found'));
          }

          
          List<Following> following = snapshot.data!;

          return ListView.builder(
            itemCount: following.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
               ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(following[index].avatar_url),
                ),
                title: Text(following[index].login,
                style: const TextStyle(color: Colors.white),),
                subtitle: Text('ID: ${following[index].id}',
                style: const TextStyle(color: Colors.white),),
                onTap: () async {
                  final Uri url = Uri.parse(following[index].htmlUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch ${following[index].htmlUrl}';
                  }
                },
              ),
              const Divider(
                color: Colors.white54,
                thickness: 1,),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
