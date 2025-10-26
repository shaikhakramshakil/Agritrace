import 'package:flutter/material.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({Key? key}) : super(key: key);

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  bool _notificationsEnabled = true;
  bool _biometricAuth = false;
  String _language = 'English';
  String _theme = 'Light';

  // Mock farmer data
  final Map<String, dynamic> _farmerProfile = {
    'name': 'Rajesh Kumar',
    'email': 'rajesh.kumar@farm.com',
    'phone': '+91 9876543210',
    'role': 'Farmer',
    'farmName': 'Kumar Organic Farms',
    'location': 'Ludhiana, Punjab',
    'memberSince': 'March 2023',
    'totalLandArea': '15.5 acres',
    'activeSeasons': 3,
    'cropsGrown': ['Wheat', 'Rice', 'Cotton', 'Mustard'],
    'profileImage': null,
    'address': 'Village Khanna, Ludhiana District, Punjab - 141401',
    'aadharNumber': 'XXXX-XXXX-1234',
    'farmLicenseNumber': 'FARM/PB/2023/5678',
    'fpoMembership': 'Green Valley Agricultural Cooperative',
    'bankAccount': 'XXXX-XXXX-4567',
    'soilType': 'Loamy',
    'irrigationType': 'Canal + Borewell',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
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
                      '2',
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
                color: Colors.green[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                child: Column(
                  children: [
                    // Profile Picture
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: _farmerProfile['profileImage'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    _farmerProfile['profileImage'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.green[700],
                                ),
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
                              icon: Icon(Icons.camera_alt, color: Colors.green[700]),
                              iconSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Name and Role
                    Text(
                      _farmerProfile['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _farmerProfile['role'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.agriculture, color: Colors.white60, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _farmerProfile['farmName'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Quick Stats - Farmer specific
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Land Area',
                      _farmerProfile['totalLandArea'],
                      Icons.landscape,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Active Seasons',
                      '${_farmerProfile['activeSeasons']}',
                      Icons.calendar_today,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Crops',
                      '${_farmerProfile['cropsGrown'].length}',
                      Icons.grass,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal Information Section
            _buildSection(
              'Personal Information',
              [
                _buildInfoTile(Icons.person_outline, 'Full Name', _farmerProfile['name']),
                _buildInfoTile(Icons.email_outlined, 'Email', _farmerProfile['email']),
                _buildInfoTile(Icons.phone_outlined, 'Phone', _farmerProfile['phone']),
                _buildInfoTile(Icons.location_on_outlined, 'Location', _farmerProfile['location']),
                _buildInfoTile(Icons.home_outlined, 'Address', _farmerProfile['address']),
                _buildInfoTile(Icons.badge_outlined, 'Aadhar Number', _farmerProfile['aadharNumber']),
              ],
            ),

            // Farm Details Section - Farmer specific
            _buildSection(
              'Farm Details',
              [
                _buildInfoTile(Icons.agriculture_outlined, 'Farm Name', _farmerProfile['farmName']),
                _buildInfoTile(Icons.landscape_outlined, 'Total Land Area', _farmerProfile['totalLandArea']),
                _buildInfoTile(Icons.terrain_outlined, 'Soil Type', _farmerProfile['soilType']),
                _buildInfoTile(Icons.water_drop_outlined, 'Irrigation Type', _farmerProfile['irrigationType']),
                _buildInfoTile(Icons.document_scanner_outlined, 'Farm License', _farmerProfile['farmLicenseNumber']),
                _buildCropsTile('Crops Grown', _farmerProfile['cropsGrown']),
              ],
            ),

            // Membership Section - Farmer specific
            _buildSection(
              'Membership & Banking',
              [
                _buildInfoTile(Icons.business_outlined, 'FPO Membership', _farmerProfile['fpoMembership']),
                _buildInfoTile(Icons.calendar_month_outlined, 'Member Since', _farmerProfile['memberSince']),
                _buildInfoTile(Icons.account_balance_outlined, 'Bank Account', _farmerProfile['bankAccount']),
              ],
            ),

            // Settings Section
            _buildSection(
              'Settings',
              [
                _buildSwitchTile(
                  Icons.notifications_outlined,
                  'Notifications',
                  'Receive crop alerts and weather updates',
                  _notificationsEnabled,
                  (value) => setState(() => _notificationsEnabled = value),
                ),
                _buildSwitchTile(
                  Icons.fingerprint,
                  'Biometric Authentication',
                  'Use fingerprint or face ID',
                  _biometricAuth,
                  (value) => setState(() => _biometricAuth = value),
                ),
                _buildSelectTile(Icons.language, 'Language', _language, _changeLanguage),
                _buildSelectTile(Icons.palette_outlined, 'Theme', _theme, _changeTheme),
              ],
            ),

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
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
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
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCropsTile(String title, List<String> crops) {
    return ListTile(
      leading: Icon(Icons.grass, color: Colors.green[700]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: crops.map((crop) => Chip(
            label: Text(crop),
            backgroundColor: Colors.green[50],
            labelStyle: TextStyle(color: Colors.green[700], fontSize: 12),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.green[700]),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green[700],
    );
  }

  Widget _buildSelectTile(IconData icon, String title, String value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
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
            ListTile(
              leading: Icon(Icons.wb_sunny, color: Colors.orange),
              title: Text('Weather Alert'),
              subtitle: Text('Rain expected in next 2 days'),
            ),
            ListTile(
              leading: Icon(Icons.notifications_active, color: Colors.blue),
              title: Text('Crop Advisory'),
              subtitle: Text('Time to apply fertilizer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
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
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share profile feature coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture update coming soon')),
    );
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'हिंदी', 'ਪੰਜਾਬੀ', 'বাংলা'].map((lang) => 
            RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _changeTheme() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Light', 'Dark', 'System'].map((theme) => 
            RadioListTile<String>(
              title: Text(theme),
              value: theme,
              groupValue: _theme,
              onChanged: (value) {
                setState(() => _theme = value!);
                Navigator.pop(context);
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile feature coming soon')),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
