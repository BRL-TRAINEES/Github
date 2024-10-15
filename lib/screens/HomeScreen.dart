import 'package:flutter/material.dart';
import 'package:github/screens/ExploreScreen.dart';
import 'package:github/screens/Followers.dart';
import 'package:github/screens/Following.dart';
import 'package:github/screens/Organisation.dart';
import 'package:github/screens/Repo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfile {
  final String login;
  final int id;
  final String url;
  final int followers;
  final int following;
  final int publicRepos;

// if required is not used it gives this error
//The parameter 'login' can't have a value of 'null' because of its type, but the implicit default value is 'null'.
// Try adding either an explicit non-'null' default value or the 'required'

  UserProfile({
    required this.login,
    required this.id,
    required this.url,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });

  // Factory method is used to extract these data from the json
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

// This is used to fetch the data
Future<UserProfile> fetchProfile(String username) async {
  final response =
      await http.get(Uri.parse("https://api.github.com/users/$username"));

  if (response.statusCode == 200) {
    // 200 = Ok response it parses the JSON.
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
  late Future<UserProfile>futureProfile; 
  // when we dont know the value initially and it could be null we use late
  final TextEditingController _controller = TextEditingController();

  @override
  //initstate is used so that the function automatically runs when user comes on that page
  void initState() {
    super.initState();
    futureProfile = fetchProfile('Dikshant005');
  }

//setstate tells the flutter framework that something has changed in this state then it rebuilds and gives the updated result
  void _searchProfile() {
    setState(() {
      futureProfile = fetchProfile(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GitHub',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Color(0xFF2B2B2B),
      ),
      backgroundColor: Color.fromARGB(1, 32, 33, 35),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            style: TextStyle(color: Colors.white30),
            cursorColor: Colors.white30,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30)),
              labelText: 'Enter GitHub Username',
              labelStyle: TextStyle(color: Color.fromARGB(255, 112, 109, 109)),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
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
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data found'));
              }

              UserProfile profile = snapshot.data!;

              return SingleChildScrollView(
                child: Container(
                  height: 450,
                  width: 380,
                  margin: EdgeInsets.only(top: 30, right: 10, left: 10),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  'https://avatars.githubusercontent.com/u/${profile.id}?v=4'),
                            ),
                            SizedBox(height: 10),
                            Text(profile.login,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowersScreen(
                                        username: profile.login),
                                  ),
                                );
                              },
                              child: Text(
                                'Followers: ${profile.followers}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowingScreen(
                                        username: profile.login),
                                  ),
                                );
                              },
                              child: Text(
                                'Following: ${profile.following}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: 200,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RepositoriesScreen(
                                        username: profile.login),
                                  ),
                                );
                              },
                              child: Text(
                                  'Repositories: ${profile.publicRepos}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                            SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrganisationScreen(
                                        username: profile.login),
                                  ),
                                );
                              },
                              child: Text('Organisations',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
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
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Explorescreen()));
            },
            //API not found
            child: Text('Explore',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
