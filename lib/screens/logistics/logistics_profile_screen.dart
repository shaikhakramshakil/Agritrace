import 'package:flutter/material.dart';

class LogisticsProfileScreen extends StatelessWidget {
  const LogisticsProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.local_shipping, size: 50)),
          const SizedBox(height: 16),
          const Text('Logistics Manager', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildInfoCard('Name', 'Suresh Kumar', Icons.person),
          _buildInfoCard('Email', 'suresh@fastlogistics.com', Icons.email),
          _buildInfoCard('Phone', '+91 9876543210', Icons.phone),
          _buildInfoCard('Company', 'Fast Logistics Pvt Ltd', Icons.business),
          _buildInfoCard('Fleet Size', '50 Vehicles', Icons.local_shipping),
          _buildInfoCard('Location', 'Bangalore', Icons.location_on),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepOrange),
        title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
