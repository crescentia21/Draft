import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_edit_screen.dart';
import 'package:version0/models/user_profile.dart';


class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  _ProfileManagementScreenState createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  Map<String, dynamic>? profile;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(user!.uid)
        .get();
    if (doc.exists) {
      setState(() {
        profile = doc.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFFFF9800);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text("Profile Management"),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustEditProfileScreen()),
            ),
            icon: const Icon(Icons.edit, color: Colors.white, size: 18),
            label: const Text("Edit", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(themeColor),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInfoCard(
                          title: "Personal Information",
                          icon: Icons.person_outline,
                          iconColor: Colors.orange,
                          children: [
                            _buildInfoRow("Full Name", profile!['fullName']),
                            _buildInfoRow("Email Address", user!.email!,
                                icon: Icons.email_outlined,
                                subtext: "Email cannot be changed"),
                            _buildInfoRow("Phone Number", profile!['phone'],
                                icon: Icons.phone_outlined),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          title: "Address",
                          icon: Icons.location_on_outlined,
                          iconColor: Colors.orange[800]!,
                          children: [
                            _buildInfoRow("Street", profile!['street']),
                            _buildInfoRow("City", profile!['city']),
                            _buildInfoRow("State", profile!['state']),
                            _buildInfoRow("ZIP Code", profile!['zip']),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildActionCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(Color themeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(color: Colors.grey[50]),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: themeColor.withOpacity(0.7),
            child: const Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(profile!['fullName'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(user!.email!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon, String? subtext}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 16, color: Colors.grey), const SizedBox(width: 8)],
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
          if (subtext != null) Text(subtext, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Account Actions", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _actionButton("Change Password", Colors.black87, onPressed: () {
            // TODO: implement change password
          }),
          _actionButton("Sign Out", Colors.black87, onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color color, {required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: color)),
      ),
    );
  }
}
