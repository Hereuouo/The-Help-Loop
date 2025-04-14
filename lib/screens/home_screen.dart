import 'package:flutter/material.dart';
import 'base_scaffold.dart'; 
import 'font_styles.dart'; 
import 'profile_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMenuOpen = false; // Track if the menu is open or not

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            style: FontStyles.heading(context, fontSize: 24, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                //the search functionality here
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            // Home Content
            Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for skills...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                
                // List of users requesting skills
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Just an example
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("User $index is requesting a skill"),
                        subtitle: Text("Skill requested: Skill $index"),
                        onTap: () {
                          //the action when a skill request is selected here
                        },
                      );
                    },
                  ),
                ),
                
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //the action for requesting help here
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: const Text("Request Help"),
                  ),
                ),
              ],
            ),
            
            // Menu Overlay
            if (isMenuOpen)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMenuOpen = false; // Close the menu when tapping on the background
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Info
                          Text(
                            "User Name",
                            style: FontStyles.heading(context, fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            title: const Text("Profile"),
                            onTap: () {
                              // Go to profile
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text("System Support"),
                            onTap: () {
                              // Go to system support
                            },
                          ),
                          ListTile(
                            title: const Text("Terms of App"),
                            onTap: () {
                              // Go to terms of the app
                            },
                          ),
                          ListTile(
                            title: const Text("App Settings"),
                            onTap: () {
                              // Navigate to app settings
                            },
                          ),
                          const Spacer(),
                          ListTile(
                            title: const Text("Log Out"),
                            onTap: () {
                              // logout functionality here
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        
        // Three Dots Menu
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isMenuOpen = !isMenuOpen; // Toggle menu
            });
          },
          child: const Icon(Icons.more_vert),
          backgroundColor: Colors.blueAccent.withOpacity(0.9),
        ),
      ),
    );
  }
}