import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

//Issue model
class Issue{
  final String title;
  final String body;
  final String state;

  Issue({required this.title ,required this.body , required this.state});
  factory Issue.fromJson(Map<String , dynamic> json) {
    return Issue(title: json['title'], body: json['body'], state: json['state']);
  }
}

// Git hub API service
class GithubApi {
  final String owner;
  final String repo;

  GithubApi({required this.owner, required this.repo});

  Future<List<Issue>> fetchIssues() async {
    final response = await http.get(Uri.parse('https://api.github.com/repos/$owner/$repo/issues'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((issue) => Issue.fromJson(issue)).toList();
    } else {
      throw Exception('Failed to load issues');
    }
  }
}

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController repoController = TextEditingController();
  Future<List<Issue>>? futureIssues;

   void _fetchIssues() {
    final owner = ownerController.text;
    final repo = repoController.text;

    if (owner.isNotEmpty && repo.isNotEmpty) {
      setState(() {
        futureIssues = GithubApi(owner: owner, repo: repo).fetchIssues();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Issues'),),
      backgroundColor: Colors.teal[50],
      body: SingleChildScrollView( 
        padding: EdgeInsets.only(top: 230.0,left:20.0,right: 20.0 ),
        
        
      child:Column(
         
        children: [
          
          TextField(
            controller: ownerController,
            decoration: InputDecoration(
              labelText: 'Repository Owner',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),

            
          
          border:OutlineInputBorder(
            borderRadius : BorderRadius.circular(12.0),
            borderSide:  const BorderSide(width:2.5),
          ),
           focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                ),
                enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 2.5),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),),
              const SizedBox(height: 20.0,),

          
          TextField(
            controller: repoController,
            decoration: InputDecoration(
              labelText: 'Repository Name',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            
          
           border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 2.5),
                ),
                enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                ),
                prefixIcon: const Icon(Icons.book, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
          ),
         
          const SizedBox(height: 20.0,),
          ElevatedButton(
              onPressed: _fetchIssues,
              
               style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10.0),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
                  child: const Text('Fetch Issues'),
            ),
            const SizedBox(height: 20),

        
      
      FutureBuilder<List<Issue>>(
        future: futureIssues,
        builder: (context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if(!snapshot.hasData){
            return const Center(child: Text('No issues found'),);
          }
          final issues = snapshot.data;

          return Container(
            height: 1000.0,
            width: 1000.0,
            child: ListView.builder(
              itemCount: issues?.length,
              itemBuilder: (context, index){
                final issue = issues![index];
                return ListTile(
                  title: Text(issue.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(issue.state),
                      const SizedBox(height: 4.0,),
                      Text(issue.body ,maxLines: 3,overflow: TextOverflow.ellipsis,)
                    ],
                  ),
                  
                );
              },
            ),
          );
        }
        ),
    ]
    )
    )
    );
  }
}