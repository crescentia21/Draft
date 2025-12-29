import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_input_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential cred = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());

                  final user = cred.user;
                  if (user == null) return;

                  final profileRef = FirebaseFirestore.instance
                      .collection('profiles')
                      .doc(user.uid);
                  final profileSnap = await profileRef.get();

                  if (!profileSnap.exists) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProfileInputScreen(userId: user.uid)));
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? "Login failed")),
                  );
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
