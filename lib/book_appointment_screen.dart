import 'package:flutter/material.dart';

class CustBookAppointmentScreen extends StatefulWidget {
  const CustBookAppointmentScreen({super.key});

  @override
  State<CustBookAppointmentScreen> createState() => _CustBookAppointmentScreenState();
}

class _CustBookAppointmentScreenState extends State<CustBookAppointmentScreen> {
  final Color themeColor = const Color(0xFFE69F52); // Primary orange
  String? selectedTime; // To track the chosen time slot

  final List<String> timeSlots = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Book Appointment",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeaderIcon(),
            const SizedBox(height: 16),
            const Text(
              "Schedule a Consultation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                "Book a free consultation with our flooring experts",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: "Your Information",
              icon: Icons.person_outline,
              children: [
                _buildFieldLabel("Full Name"),
                _buildAppointmentField("John Doe"),
                const SizedBox(height: 12),
                _buildFieldLabel("Email"),
                _buildAppointmentField("john@example.com", icon: Icons.email_outlined),
                const SizedBox(height: 12),
                _buildFieldLabel("Phone"),
                _buildAppointmentField("60 + 104567892", icon: Icons.phone_outlined),
                const SizedBox(height: 12),
                _buildFieldLabel("Service Address"),
                _buildAppointmentField("No. 138, Lorong Setia Raja, Kuching", icon: Icons.location_on_outlined),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: "Select Date",
              icon: Icons.calendar_today_outlined,
              children: [
                _buildAppointmentField("Select Date...", isDropdown: true),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimePickerCard(),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: "Additional Notes (Optional)",
              icon: null,
              children: [
                _buildNotesField(),
              ],
            ),
            const SizedBox(height: 24),
            _buildConfirmButton(),
            const SizedBox(height: 16),
            const Text(
              "You'll receive a confirmation email once your appointment is booked",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return CircleAvatar(
      radius: 35,
      backgroundColor: themeColor.withOpacity(0.8),
      child: const Icon(Icons.calendar_month, size: 35, color: Colors.white),
    );
  }

  Widget _buildSectionCard({required String title, IconData? icon, required List<Widget> children}) {
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
              if (icon != null) ...[
                Icon(icon, color: themeColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildAppointmentField(String hint, {IconData? icon, bool isDropdown = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.black54),
            const SizedBox(width: 10),
          ],
          Expanded(child: Text(hint, style: const TextStyle(color: Colors.black54))),
          if (isDropdown) const Icon(Icons.arrow_drop_down, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildTimePickerCard() {
    return _buildSectionCard(
      title: "Select Time",
      icon: Icons.access_time,
      children: timeSlots.map((time) {
        bool isSelected = selectedTime == time;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: () => setState(() => selectedTime = time),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isSelected ? themeColor : Colors.grey[300]!),
              ),
              child: Text(
                time,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? themeColor : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotesField() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const TextField(
        maxLines: null,
        decoration: InputDecoration.collapsed(
          hintText: "Tell us about your project, preferred flooring types, or any specific requirements...",
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor.withOpacity(0.5), // Lighter orange as per Figma
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {},
        child: const Text("Confirm Appointment", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}