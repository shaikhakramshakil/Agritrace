import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 4; // Profile is at index 4
  bool _notificationsEnabled = true;
  bool _biometricAuth = false;
  String _language = 'English';
  String _theme = 'Light';
  bool _isEditMode = false;

  // Text controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;

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
  void initState() {
    super.initState();
    // Initialize controllers
    _nameController = TextEditingController(text: 'John Doe');
    _emailController = TextEditingController(text: 'john.doe@agritrace.com');
    _phoneController = TextEditingController(text: '+1 555-123-4567');
    _jobTitleController = TextEditingController(text: 'Lead Agronomist');
    _companyController = TextEditingController(text: 'AgriTrace Inc.');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        // Reset controllers to original values
        _nameController.text = 'John Doe';
        _emailController.text = 'john.doe@agritrace.com';
        _phoneController.text = '+1 555-123-4567';
        _jobTitleController.text = 'Lead Agronomist';
        _companyController.text = 'AgriTrace Inc.';
      }
    });
  }

  void _saveChanges() {
    setState(() {
      _isEditMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void _cancelEdit() {
    setState(() {
      _isEditMode = false;
      // Reset controllers to original values
      _nameController.text = 'John Doe';
      _emailController.text = 'john.doe@agritrace.com';
      _phoneController.text = '+1 555-123-4567';
      _jobTitleController.text = 'Lead Agronomist';
      _companyController.text = 'AgriTrace Inc.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Profile Header
                    _buildProfileHeader(),

                    const SizedBox(height: 20),

                    // Profile Information
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildInfoItem(
                            icon: Icons.email,
                            title: 'Email',
                            value: _emailController.text,
                            controller: _emailController,
                            showArrow: false,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoItem(
                            icon: Icons.phone,
                            title: 'Phone Number',
                            value: _phoneController.text,
                            controller: _phoneController,
                            showArrow: false,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoItem(
                            icon: Icons.work,
                            title: 'Job Title',
                            value: _jobTitleController.text,
                            controller: _jobTitleController,
                            showArrow: true,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoItem(
                            icon: Icons.business,
                            title: 'Company/Organization',
                            value: _companyController.text,
                            controller: _companyController,
                            showArrow: true,
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons (shown in edit mode)
                    if (_isEditMode) _buildActionButtons(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),

          // Title
          const Expanded(
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Edit Button
          TextButton(
            onPressed: _toggleEditMode,
            child: Text(
              _isEditMode ? 'Done' : 'Edit',
              style: const TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.015,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCsj1vsRMIgA5sFEuqQpVKDvC-adU4d_x_efQBYv9ZpJFYADjNRDW1LEnHOurJh9ZkhR3xczYHllvqwwm5ba9j90nAclDgKcy5mMm1Gl57F2-3IGn6ay-aX8yE0prxwADevxKUvpQYC5Z3rfGPX_O5PTB-AmoMZRdVElCVo_6r2jdF0y7jiE6uz2z5edxNAlq05qyUnCGnMno3Ocre9GqQorylv3mIdYiITpjApvKafXM1upC-Et5jr61RLor89I9_6-Hb-UFcLQcc',
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),

              // Edit Photo Button
              if (_isEditMode)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C63FF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Implement photo picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Photo picker coming soon!'),
                            backgroundColor: Color(0xFF6C63FF),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          if (_isEditMode)
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.015,
                ),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C63FF)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            )
          else
            Text(
              _nameController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required TextEditingController controller,
    required bool showArrow,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF212135),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Title and Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (_isEditMode)
                  TextField(
                    controller: controller,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Arrow Icon (only if not in edit mode and showArrow is true)
          if (!_isEditMode && showArrow)
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cancel Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _cancelEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A4A4A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
