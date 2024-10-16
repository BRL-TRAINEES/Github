import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Organisation {
  final String login;
  final int id;
  

  Organisation({
    required this.login,
    required this.id,
    
  });

  factory Organisation.fromJson(Map<String, dynamic> json) {
    return Organisation(
      login: json['login'],
      id: json['id'],
      
    );
  }
}

Future<List<Organisation>> fetchOrganisation(String username) async {
  final response =
      await http.get(Uri.parse("https://api.github.com/users/$username/orgs"));

  if (response.statusCode == 200) {
    List<dynamic> organisationJson = jsonDecode(response.body);
    return organisationJson.map((json) => Organisation.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Organisations');
  }
}

class OrganisationScreen extends StatefulWidget {
  final String username;
  const OrganisationScreen({super.key, required this.username});

  @override
  State<OrganisationScreen> createState() => _OrganisationScreenState();
}

class _OrganisationScreenState extends State<OrganisationScreen> {
  late Future<List<Organisation>> futureOrganisations;

  @override
  void initState() {
    super.initState();
    futureOrganisations = fetchOrganisation(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisations',
        style: TextStyle(color: Colors.white,
        fontSize: 18),),
        backgroundColor: const Color(0xFF2B2B2B),
       iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Organisation>>(
        future: futureOrganisations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ) {
            return const Center(child: Text('No organisations found'));
          }

          List<Organisation> organisations = snapshot.data!;
          return ListView.builder(
            itemCount: organisations.length,
            itemBuilder: (context, index) {
              return Column(
                children: [ 
              ListTile(
                title: Text(organisations[index].login,
                style: const TextStyle(color: Colors.white),),
                subtitle: Text('ID: ${organisations[index].id}',
                style: const TextStyle(color: Colors.white),),
               
              ),
              const Divider(
                color:Colors.white54 ,
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
