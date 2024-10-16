import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:github/screens/ExploreScreen.dart';
import 'package:github/screens/Followers.dart';
import 'package:github/screens/Following.dart';
import 'package:github/screens/Organisation.dart';
import 'package:github/screens/Repo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UserProfile {
  final String login;
  final int id;
  final String url;
  final int followers;
  final int following;
  final int publicRepos;

  UserProfile({
    required this.login,
    required this.id,
    required this.url,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      login: json['login'],
      id: json['id'],
      url: json['html_url'],
      followers: json['followers'],
      following: json['following'],
      publicRepos: json['public_repos'],
    );
  }
}

Future<UserProfile> fetchProfile(String username) async {
  final response =
      await http.get(Uri.parse("https://api.github.com/users/$username"));

  if (response.statusCode == 200) {
    return UserProfile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load profile');
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserProfile> futureProfile;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile('Dikshant005');
  }

  void _searchProfile() {
    setState(() {
      futureProfile = fetchProfile(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GitHub',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF2B2B2B),
      ),
      backgroundColor: Colors.black,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white54,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54)),
              labelText: 'Enter GitHub Username',
              labelStyle: const TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search,color: Colors.white54,),
                onPressed: _searchProfile,
                
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<UserProfile>(
            future: futureProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found'));
              }

              UserProfile profile = snapshot.data!;

              return SingleChildScrollView(
                child: Container(
                  height: 450,
                  width: 380,
                  margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  'https://avatars.githubusercontent.com/u/${profile.id}?v=4'),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () async {
                                final url = Uri.parse(profile.url);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Text(
                                profile.login,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            OpenContainer(
                              transitionDuration: const Duration(milliseconds: 500),
                              closedElevation: 0,
                              closedColor: Colors.transparent,
                              openBuilder: (context, _) => FollowersScreen(username: profile.login),
                              closedBuilder: (context, openContainer) => GestureDetector(
                                onTap: openContainer,
                                child: Text(
                                  'Followers: ${profile.followers}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            OpenContainer(//widget by animation package
                              transitionDuration: const Duration(milliseconds: 500),
                              closedElevation: 0, //container will have no shadow when its closed
                              closedColor: Colors.transparent,//if this is not used container background turns white
                              openBuilder: (context, _) => FollowingScreen(username: profile.login),
                              closedBuilder: (context, openContainer) => GestureDetector(
                                onTap: openContainer,
                                child: Text(
                                  'Following: ${profile.following}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: 200,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            OpenContainer(
                              transitionDuration: const Duration(milliseconds: 500),
                              closedElevation: 0,
                              closedColor: Colors.transparent,
                              openBuilder: (context, _) => RepositoriesScreen(username: profile.login),
                              closedBuilder: (context, openContainer) => GestureDetector(
                                onTap: openContainer,
                                child: Text(
                                  'Repositories: ${profile.publicRepos}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            OpenContainer(
                              transitionDuration: const Duration(milliseconds: 500),
                              closedElevation: 0,
                              closedColor: Colors.transparent,
                              openBuilder: (context, _) => OrganisationScreen(username: profile.login),
                              closedBuilder: (context, openContainer) => GestureDetector(
                                onTap: openContainer,
                                child: const Text(
                                  'Organisations',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
      bottomNavigationBar: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Explorescreen()),
              );
            },
            child: const Text('Explore',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
