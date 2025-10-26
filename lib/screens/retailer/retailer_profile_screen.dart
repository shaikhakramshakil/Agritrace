import 'package:flutter/material.dart';

class RetailerProfileScreen extends StatefulWidget {
  const RetailerProfileScreen({Key? key}) : super(key: key);

  @override
  State<RetailerProfileScreen> createState() => _RetailerProfileScreenState();
}

class _RetailerProfileScreenState extends State<RetailerProfileScreen> {
  bool _notificationsEnabled = true;
  bool _biometricAuth = false;
  String _language = 'English';
  String _theme = 'Light';

  // Mock retailer data
  final Map<String, dynamic> _retailerProfile = {
    'name': 'Fresh Foods Mart',
    'email': 'contact@freshfoodsmart.com',
    'phone': '+91 9876543210',
    'role': 'Retailer',
    'storeName': 'Fresh Foods Mart - Downtown',
    'location': 'Mumbai, Maharashtra',
    'memberSince': 'June 2023',
    'totalProducts': 450,
    'activeSuppliers': 28,
    'monthlyRevenue': '₹12.5L',
    'profileImage': null,
    'address': 'Shop No. 15, Market Complex, Andheri West, Mumbai - 400053',
    'gstNumber': '27AAAAA0000A1Z5',
    'fssaiLicense': 'FSSAI/2023/123456',
    'businessType': 'Retail Store',
    'storeSize': '2500 sq ft',
    'employeeCount': 12,
    'deliveryRadius': '15 km',
    'paymentMethods': ['Cash', 'Card', 'UPI', 'Wallet'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Store Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showNotifications,
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showProfileMenu,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.store, size: 50, color: Colors.purple[700]),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _changeProfilePicture,
                              icon: Icon(Icons.camera_alt, color: Colors.purple[700]),
                              iconSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _retailerProfile['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _retailerProfile['storeName'],
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Quick Stats - Retailer specific
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Products', '${_retailerProfile['totalProducts']}', Icons.inventory_2, Colors.purple),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Suppliers', '${_retailerProfile['activeSuppliers']}', Icons.people, Colors.orange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Revenue/Mo', _retailerProfile['monthlyRevenue'], Icons.currency_rupee, Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Store Information
            _buildSection('Store Information', [
              _buildInfoTile(Icons.store_outlined, 'Store Name', _retailerProfile['storeName']),
              _buildInfoTile(Icons.business_outlined, 'Business Type', _retailerProfile['businessType']),
              _buildInfoTile(Icons.email_outlined, 'Email', _retailerProfile['email']),
              _buildInfoTile(Icons.phone_outlined, 'Phone', _retailerProfile['phone']),
              _buildInfoTile(Icons.location_on_outlined, 'Location', _retailerProfile['location']),
              _buildInfoTile(Icons.home_outlined, 'Address', _retailerProfile['address']),
            ]),

            // Business Details
            _buildSection('Business Details', [
              _buildInfoTile(Icons.square_foot_outlined, 'Store Size', _retailerProfile['storeSize']),
              _buildInfoTile(Icons.people_outlined, 'Employees', '${_retailerProfile['employeeCount']}'),
              _buildInfoTile(Icons.local_shipping_outlined, 'Delivery Radius', _retailerProfile['deliveryRadius']),
              _buildInfoTile(Icons.badge_outlined, 'GST Number', _retailerProfile['gstNumber']),
              _buildInfoTile(Icons.verified_outlined, 'FSSAI License', _retailerProfile['fssaiLicense']),
              _buildPaymentMethodsTile('Payment Methods', _retailerProfile['paymentMethods']),
            ]),

            // Membership
            _buildSection('Membership', [
              _buildInfoTile(Icons.calendar_month_outlined, 'Member Since', _retailerProfile['memberSince']),
            ]),

            // Settings
            _buildSection('Settings', [
              _buildSwitchTile(Icons.notifications_outlined, 'Notifications', 'Receive order and stock alerts', _notificationsEnabled, (value) => setState(() => _notificationsEnabled = value)),
              _buildSwitchTile(Icons.fingerprint, 'Biometric Auth', 'Use fingerprint or face ID', _biometricAuth, (value) => setState(() => _biometricAuth = value)),
              _buildSelectTile(Icons.language, 'Language', _language, _changeLanguage),
              _buildSelectTile(Icons.palette_outlined, 'Theme', _theme, _changeTheme),
            ]),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _editProfile,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple[700]),
      title: Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
    );
  }

  Widget _buildPaymentMethodsTile(String title, List<String> methods) {
    return ListTile(
      leading: Icon(Icons.payment, color: Colors.purple[700]),
      title: Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: methods.map((method) => Chip(
            label: Text(method),
            backgroundColor: Colors.purple[50],
            labelStyle: TextStyle(color: Colors.purple[700], fontSize: 12),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.purple[700]),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.purple[700],
    );
  }

  Widget _buildSelectTile(IconData icon, String title, String value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple[700]),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(leading: Icon(Icons.inventory, color: Colors.orange), title: Text('Low Stock'), subtitle: Text('5 items running low')),
            ListTile(leading: Icon(Icons.shopping_cart, color: Colors.blue), title: Text('New Orders'), subtitle: Text('3 new orders received')),
            ListTile(leading: Icon(Icons.local_shipping, color: Colors.green), title: Text('Delivery'), subtitle: Text('Supplier delivery at 3 PM')),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.share), title: const Text('Share Profile'), onTap: () { Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help & Support'), onTap: () { Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.info_outline), title: const Text('About'), onTap: () { Navigator.pop(context); }),
          ],
        ),
      ),
    );
  }

  void _changeProfilePicture() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile picture update coming soon')));
  void _changeLanguage() => showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Select Language'), content: Column(mainAxisSize: MainAxisSize.min, children: ['English', 'हिंदी', 'मराठी'].map((lang) => RadioListTile<String>(title: Text(lang), value: lang, groupValue: _language, onChanged: (value) { setState(() => _language = value!); Navigator.pop(context); })).toList())));
  void _changeTheme() => showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Select Theme'), content: Column(mainAxisSize: MainAxisSize.min, children: ['Light', 'Dark', 'System'].map((theme) => RadioListTile<String>(title: Text(theme), value: theme, groupValue: _theme, onChanged: (value) { setState(() => _theme = value!); Navigator.pop(context); })).toList())));
  void _editProfile() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit profile feature coming soon')));
  void _logout() => showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Logout'), content: const Text('Are you sure you want to logout?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), TextButton(onPressed: () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/login'); }, child: const Text('Logout', style: TextStyle(color: Colors.red)))]));
}
