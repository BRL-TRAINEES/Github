import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:github/screens/Discussion.dart';
// import 'package:github/screens/Explore.dart';
import 'package:github/screens/Issues_screen.dart';
// import 'package:github/screens/Notifications.dart';
// import 'package:github/screens/Organisation.dart';
// import 'package:github/screens/Profile.dart';
// import 'package:github/screens/Projects.dart';
import 'package:github/screens/Pull_request_screen.dart';
import 'package:github/screens/Repo.dart';
// import 'package:github/screens/search_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home',style:
          TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30) ,),

          // actions: [IconButton(
          // icon: const Icon(Icons.search),
          // onPressed: () {
          //    Navigator.of(context).push(
          //    MaterialPageRoute(builder: (context)=>const SearchScreen(),),
          // );
          // },
          // iconSize: 30,
          
          //  )
            
            
          // ],

        ),
        
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.only(left: 18.0,top: 20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('My Work',
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              ),
              ),
              const SizedBox(height: 15.0),
              
              Row(
                children: [
                 
                 GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const IssuesScreen()),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/issues.svg',
                        width: 24,
                        height: 24,
                      ),
                    ), 
                    const SizedBox(width: 8.0,),
                 GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const IssuesScreen()),
                        );
                        
                      },
                      
                      child: const Text('Issues',
                      style: TextStyle(
                        fontSize: 20,
                      ),)
                      ),
                     
               ],

              ),
               const Divider(),
              const SizedBox(height: 15.0,),

              Row(
                children: [
                 
                 GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const PullRequestScreen()),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/pull_request.svg',
                        width: 24,
                        height: 24,
                      ),
                    ), 
                    const SizedBox(width: 8.0,),
                 GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const PullRequestScreen()),
                        );
                        
                      },
                      
                      
                      child: const Text('Pull Requests',
                      style: TextStyle(
                        fontSize: 20,
                      ),)
                      ),
                     
               ],

              ),
              const Divider(),
               const SizedBox(height: 15.0,),

              Row(
                children: [
                 
                 GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const DiscussionScreen()),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/Discussion.svg',
                        width: 24,
                        height: 24,
                      ),
                    ), 
                    const SizedBox(width: 8.0,),
                 GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const DiscussionScreen()),
                        );
                        
                      },
                      
                      
                      child: const Text('Discussions',
                      style: TextStyle(
                        fontSize: 20,
                      ),)
                      ),
                     
               ],

              ),
              // const Divider(),
              // const SizedBox(height: 15.0,),
              // Row(
              //   children: [
                 
              //    GestureDetector(
              //         onTap: () {
              //           Navigator.of(context).push(
              //             MaterialPageRoute(builder: (context) => const Projects()),
              //           );
              //         },
              //         child: SvgPicture.asset(
              //           'assets/Project.svg',
              //           width: 24,
              //           height: 24,
              //         ),
              //       ), 
              //       const SizedBox(width: 8.0,),
              //    GestureDetector(
              //         onTap: () {
              //           Navigator.of(context).push(
              //             MaterialPageRoute(builder: (context) => const Projects()),
              //           );
                        
              //         },
                      
                      
              //         child: const Text('Proejcts',
              //         style: TextStyle(
              //           fontSize: 20,
              //         ),)
              //         ),
                     
              //  ],

              // ),
              const Divider(),
              const SizedBox(height: 15.0,),
              Row(
                children: [
                 
                 GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Repo()),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/Repo.svg',
                        width: 24,
                        height: 24,
                      ),
                    ), 
                    const SizedBox(width: 8.0,),
                 GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Repo()),
                        );
                        
                      },
                      
                      
                      child: const Text('Repositories',
                      style: TextStyle(
                        fontSize: 20,
                      ),)
                      ),
                     
               ],

              ),
            //   const Divider(),
            //  const SizedBox(height: 15.0,),
            //   Row(
            //     children: [
                 
            //      GestureDetector(
            //           onTap: () {
            //             Navigator.of(context).push(
            //               MaterialPageRoute(builder: (context) => const Organisation()),
            //             );
            //           },
            //           child: SvgPicture.asset(
            //             'assets/Organisation.svg',
            //             width: 24,
            //             height: 24,
            //           ),
            //         ), 
            //         const SizedBox(width: 8.0,),
            //      GestureDetector(
            //           onTap: () {
            //             Navigator.of(context).push(
            //               MaterialPageRoute(builder: (context) => const Organisation()),
            //             );
                        
            //           },
                      
                      
            //           child: const Text('Organisations',
            //           style: TextStyle(
            //             fontSize: 20,
            //           ),)
            //           ),
                     
            //    ],

            //   ),
              
            ],
          ),
          ),
      ),
      
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
          
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     crossAxisAlignment: CrossAxisAlignment.start,
          
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen()),);
      //         },
      //         child: const Icon(Icons.home),
      //       ),
            
      //            GestureDetector(
                  
      //                 onTap: () {
      //                   Navigator.of(context).push(
      //                     MaterialPageRoute(builder: (context) => const HomeScreen()),
      //                   );
                        
      //                 },
                      
                      
      //                 child: const Text('Home',)
      //                 ),
      //                 GestureDetector(
      //         onTap: () {
      //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Notifications()),);
      //         },
      //         child: const Icon(Icons.notifications),
      //       ),
            
      //            GestureDetector(
                  
      //                 onTap: () {
      //                   Navigator.of(context).push(
      //                     MaterialPageRoute(builder: (context) => const Notifications()),
      //                   );
                        
      //                 },
                      
                      
      //                 child: const Text('Notification',)
      //                 ),
      //                 GestureDetector(
      //         onTap: () {
      //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Explore()),);
      //         },
      //         child: const Icon(Icons.explore),
      //       ),
            
      //            GestureDetector(
                  
      //                 onTap: () {
      //                   Navigator.of(context).push(
      //                     MaterialPageRoute(builder: (context) => const Explore()),
      //                   );
                        
      //                 },
                      
                      
      //                 child: const Text('Home',)
      //                 ),
      //                 GestureDetector(
      //         onTap: () {
      //           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Profile()),);
      //         },
      //         child: const Icon(Icons.account_circle),
      //       ),
            
      //            GestureDetector(
                  
      //                 onTap: () {
      //                   Navigator.of(context).push(
      //                     MaterialPageRoute(builder: (context) => const Profile()),
      //                   );
                        
      //                 },
                      
                      
      //                 child: const Text('Profile',)
      //                 ),
                      
      //     ],
      //   ),
        
        
      // ),
    ));
  }
}