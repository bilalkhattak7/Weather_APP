import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> _checkAdminStatus() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('admin_users')
        .doc(user.uid)
        .get();

    return doc.exists && doc.data()?['isAdmin'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAdminStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.data!) {
          return const Scaffold(
            body: Center(child: Text('Admin access required')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Admin Panel')),
          body: const Center(child: Text('Admin content here')),
        );
      },
    );
  }
}





