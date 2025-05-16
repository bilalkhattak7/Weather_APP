import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_fyp/models/user_model.dart';
import 'package:weather_fyp/screens/glassmorphism_container.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  Future<void> _launchWhatsApp(String phone) async {
    final url = 'https://wa.me/${phone.replaceAll(RegExp(r'[^\d+]'), '')}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Registered Volunteers'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight + 60), // Padding from top
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('public_users')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: GlassmorphismContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: GlassmorphismContainer(
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No volunteers found',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              }

              final users = snapshot.data!.docs.map((doc) {
                return AppUser.fromMap(doc.data() as Map<String, dynamic>);
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlassmorphismContainer(
                      borderRadius: 15,
                      blur: 15,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Phone: ${user.phone}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Location: ${user.place}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.chat, color: Colors.green),
                          onPressed: () => _launchWhatsApp(user.phone),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}