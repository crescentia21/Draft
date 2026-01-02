import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/app_bottom_nav.dart';

// ---------------------------
// Firebase Initialization
// ---------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD-rpGMX0McVoCXlHe4Xzig7yJM4lYesZM",
      authDomain: "floorbit-a3b55.firebaseapp.com",
      projectId: "floorbit-a3b55",
      storageBucket: "floorbit-a3b55.firebasestorage.app",
      messagingSenderId: "949777069358",
      appId: "1:949777069358:web:27e9e6b4fbd101ec7b36bf",
      measurementId: "G-4QV1HM23LW",
    ),
  );
  runApp(const TrackOrdersApp());
}

// ---------------------------
// Wrapper App
// ---------------------------
class TrackOrdersApp extends StatelessWidget {
  const TrackOrdersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloorBit Orders',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const TrackOrdersScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---------------------------
// Order Service
// ---------------------------
class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchUserOrders(String userId) {
    return _firestore
        .collection('orders') // Make sure this matches your Firestore collection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots();
  }
}

// ---------------------------
// TrackOrdersScreen
// ---------------------------
class TrackOrdersScreen extends StatefulWidget {
  const TrackOrdersScreen({super.key});

  @override
  State<TrackOrdersScreen> createState() => _TrackOrdersScreenState();
}

class _TrackOrdersScreenState extends State<TrackOrdersScreen> {
  final OrderService orderService = OrderService();
  final String testUserId = 'olc6nskDG9P9TRgljOoLIOo1ggM2'; // Real userId
  List<Map<String, dynamic>> displayedOrders = [];

  void _runFilter(String enteredKeyword) {
    setState(() {
      displayedOrders = displayedOrders
          .where((order) =>
              order['orderID'].toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              order['productName'].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Track Orders', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search by Order Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            TextField(
              onChanged: _runFilter,
              decoration: InputDecoration(
                hintText: 'Enter order number (e.g., FL12345678)',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Your Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: orderService.fetchUserOrders(testUserId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  displayedOrders = snapshot.data!.docs
                      .map((doc) => doc.data()! as Map<String, dynamic>)
                      .toList();

                  if (displayedOrders.isEmpty) {
                    return const Center(child: Text('No orders found.'));
                  }

                  return ListView.builder(
                    itemCount: displayedOrders.length,
                    itemBuilder: (context, index) {
                      final order = displayedOrders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: OrderCard(
                          orderID: order['orderID'],
                          date: order['date'],
                          quantity: order['quantity'],
                          productName: order['productName'],
                          status: order['status'],
                          statusColor: Color(int.parse(order['statusColor'])),
                          statusTextColor: Color(int.parse(order['statusTextColor'])),
                          footerLabel: order['footerLabel'],
                          price: order['price'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}

// ---------------------------
// OrderCard Widget
// ---------------------------
class OrderCard extends StatelessWidget {
  final String orderID;
  final String date;
  final String quantity;
  final String productName;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String footerLabel;
  final String price;

  const OrderCard({
    super.key,
    required this.orderID,
    required this.date,
    required this.quantity,
    required this.productName,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.footerLabel,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order $orderID',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status, style: TextStyle(color: statusTextColor, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(date, style: const TextStyle(color: Colors.grey)),
          Text(quantity, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(productName, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(footerLabel, style: const TextStyle(color: Colors.grey)),
              Text(price,
                  style: const TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
