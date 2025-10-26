import 'package:flutter/material.dart';

class FpoProfileScreen extends StatefulWidget {
  const FpoProfileScreen({Key? key}) : super(key: key);

  @override
  State<FpoProfileScreen> createState() => _FpoProfileScreenState();
}

class _FpoProfileScreenState extends State<FpoProfileScreen> {
  int _currentNavIndex = 4; // Profile is at index 4
  bool _notificationsEnabled = true;
  bool _biometricAuth = false;
  String _language = 'English';
  String _theme = 'Light';

  // Mock user data
  final Map<String, dynamic> _userProfile = {
    'name': 'Agricultural FPO Cooperative',
    'email': 'info@agrifpo.com',
    'phone': '+91 9876543210',
    'role': 'FPO Manager',
    'organization': 'Green Valley Agricultural Cooperative',
    'location': 'Punjab, India',
    'memberSince': 'January 2023',
    'totalFarms': 45,
    'totalFarmers': 156,
    'profileImage': null,
    'address': '123 Agricultural Complex, Village Greenfield, Punjab - 144001',
    'website': 'www.greenvalleyfpo.com',
    'gstNumber': '03AAAAA0000A1Z5',
    'licenseNumber': 'FPO/2023/001234',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[600],
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
                      '1',
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
                color: Colors.teal[600],
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
                          child: _userProfile['profileImage'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    _userProfile['profileImage'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.business,
                                  size: 50,
                                  color: Colors.teal[600],
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
                              icon: Icon(Icons.camera_alt, color: Colors.teal[600]),
                              iconSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Name and Role
                    Text(
                      _userProfile['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userProfile['role'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userProfile['organization'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Quick Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Farms',
                      '${_userProfile['totalFarms']}',
                      Icons.agriculture_outlined,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Total Farmers',
                      '${_userProfile['totalFarmers']}',
                      Icons.people_outline,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Member Since',
                      _userProfile['memberSince'],
                      Icons.calendar_today_outlined,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile Information
            _buildSection(
              'Personal Information',
              [
                _buildInfoItem(Icons.email_outlined, 'Email', _userProfile['email']),
                _buildInfoItem(Icons.phone_outlined, 'Phone', _userProfile['phone']),
                _buildInfoItem(Icons.location_on_outlined, 'Location', _userProfile['location']),
                _buildInfoItem(Icons.home_outlined, 'Address', _userProfile['address']),
                _buildInfoItem(Icons.language_outlined, 'Website', _userProfile['website']),
              ],
            ),

            const SizedBox(height: 16),

            // Organization Information
            _buildSection(
              'Organization Details',
              [
                _buildInfoItem(Icons.business_outlined, 'Organization', _userProfile['organization']),
                _buildInfoItem(Icons.receipt_outlined, 'GST Number', _userProfile['gstNumber']),
                _buildInfoItem(Icons.verified_outlined, 'License Number', _userProfile['licenseNumber']),
              ],
            ),

            const SizedBox(height: 16),

            // Settings Section
            _buildSection(
              'Settings',
              [
                _buildSettingItem(
                  Icons.notifications_outlined,
                  'Notifications',
                  'Manage notification preferences',
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: Colors.teal[600],
                  ),
                ),
                _buildClickableSettingItem(
                  Icons.fingerprint_outlined,
                  'Biometric Authentication',
                  _biometricAuth ? 'Enabled' : 'Disabled',
                  () => _toggleBiometric(),
                ),
                _buildClickableSettingItem(
                  Icons.language_outlined,
                  'Language',
                  _language,
                  () => _showLanguageSelection(),
                ),
                _buildClickableSettingItem(
                  Icons.palette_outlined,
                  'Theme',
                  _theme,
                  () => _showThemeSelection(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Support & Help Section
            _buildSection(
              'Support & Help',
              [
                _buildClickableSettingItem(
                  Icons.help_outline,
                  'Help & FAQ',
                  'Get answers to common questions',
                  () => _showHelp(),
                ),
                _buildClickableSettingItem(
                  Icons.support_agent_outlined,
                  'Contact Support',
                  'Reach out to our support team',
                  () => _contactSupport(),
                ),
                _buildClickableSettingItem(
                  Icons.policy_outlined,
                  'Privacy Policy',
                  'View our privacy policy',
                  () => _showPrivacyPolicy(),
                ),
                _buildClickableSettingItem(
                  Icons.description_outlined,
                  'Terms of Service',
                  'Read terms and conditions',
                  () => _showTermsOfService(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Account Actions
            _buildSection(
              'Account',
              [
                _buildClickableSettingItem(
                  Icons.edit_outlined,
                  'Edit Profile',
                  'Update your profile information',
                  () => _editProfile(),
                ),
                _buildClickableSettingItem(
                  Icons.lock_outline,
                  'Change Password',
                  'Update your password',
                  () => _changePassword(),
                ),
                _buildClickableSettingItem(
                  Icons.backup_outlined,
                  'Export Data',
                  'Download your data',
                  () => _exportData(),
                ),
                _buildClickableSettingItem(
                  Icons.logout_outlined,
                  'Sign Out',
                  'Sign out of your account',
                  () => _signOut(),
                  textColor: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle, Widget trailing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildClickableSettingItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: textColor ?? Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor?.withOpacity(0.7) ?? Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: textColor ?? Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.agriculture_outlined, 'Farms'),
              _buildNavItem(2, Icons.inventory_outlined, 'Inventory'),
              _buildNavItem(3, Icons.assessment_outlined, 'Reports'),
              _buildNavItem(4, Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
        _handleNavigation(index);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.teal[600] : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.teal[600] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Home
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case 1: // Farms
        Navigator.pushReplacementNamed(context, '/farms');
        break;
      case 2: // Inventory
        Navigator.pushReplacementNamed(context, '/inventory');
        break;
      case 3: // Reports
        Navigator.pushReplacementNamed(context, '/reports');
        break;
      case 4: // Profile (current screen)
        // Already on profile screen
        break;
    }
  }

  // Helper methods
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.security_outlined, color: Colors.blue),
              title: const Text('Security Update'),
              subtitle: const Text('Your account security settings have been updated'),
              trailing: const Text('1h ago'),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                _shareProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_outlined),
              title: const Text('Show QR Code'),
              onTap: () {
                Navigator.pop(context);
                _showQRCode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.print_outlined),
              title: const Text('Print Profile'),
              onTap: () {
                Navigator.pop(context);
                _printProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening camera...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening gallery...')),
                );
              },
            ),
            if (_userProfile['profileImage'] != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _userProfile['profileImage'] = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile picture removed')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _toggleBiometric() {
    setState(() {
      _biometricAuth = !_biometricAuth;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _biometricAuth
              ? 'Biometric authentication enabled'
              : 'Biometric authentication disabled',
        ),
      ),
    );
  }

  void _showLanguageSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...['English', 'Hindi', 'Punjabi', 'Tamil', 'Bengali'].map((lang) => 
              RadioListTile<String>(
                title: Text(lang),
                value: lang,
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Language changed to $value')),
                  );
                },
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  void _showThemeSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...['Light', 'Dark', 'System'].map((theme) => 
              RadioListTile<String>(
                title: Text(theme),
                value: theme,
                groupValue: _theme,
                onChanged: (value) {
                  setState(() {
                    _theme = value!;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Theme changed to $value')),
                  );
                },
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening profile editor...')),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening password change form...')),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'This will export all your profile and organization data. '
          'The export will be sent to your registered email address.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data export initiated. Check your email.')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening help center...')),
    );
  }

  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Call Support'),
              subtitle: const Text('+91 1800-123-4567'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email Support'),
              subtitle: const Text('support@agritrace.com'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('Live Chat'),
              subtitle: const Text('Chat with our support team'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening privacy policy...')),
    );
  }

  void _showTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening terms of service...')),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing profile...')),
    );
  }

  void _showQRCode() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Profile QR Code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code, size: 80, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      'Profile QR',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _printProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing profile for printing...')),
    );
  }
}