import 'package:flutter/material.dart';
import 'package:agritrace/screens/onboarding/login_screen.dart';
import 'package:agritrace/widgets/agritrace_logo.dart';

enum UserRole {
  farmer,
  fpo,
  processor,
  retailer,
  logistics,
  policyMaker,
  admin,
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;

  final Map<UserRole, RoleData> _roleData = {
    UserRole.farmer: RoleData(
      title: 'Farmer',
      description: 'Manage your crops and track your produce.',
      icon: Icons.agriculture,
      color: const Color(0xFF4CAF50),
    ),
    UserRole.fpo: RoleData(
      title: 'FPO',
      description: 'Coordinate with farmers and manage logistics.',
      icon: Icons.groups,
      color: const Color(0xFF2196F3),
    ),
    UserRole.processor: RoleData(
      title: 'Processor',
      description: 'Process raw materials and track inventory.',
      icon: Icons.factory,
      color: const Color(0xFFFF9800),
    ),
    UserRole.retailer: RoleData(
      title: 'Retailer',
      description: 'Manage store inventory and sales data.',
      icon: Icons.storefront,
      color: const Color(0xFF9C27B0),
    ),
    UserRole.logistics: RoleData(
      title: 'Logistics',
      description: 'Track shipments and manage warehouse operations.',
      icon: Icons.local_shipping,
      color: const Color(0xFF00BCD4),
    ),
    UserRole.policyMaker: RoleData(
      title: 'Policy Maker',
      description: 'Access aggregated data for policy making.',
      icon: Icons.account_balance,
      color: const Color(0xFFFFEB3B),
    ),
    UserRole.admin: RoleData(
      title: 'Admin',
      description: 'Oversee the platform and manage users.',
      icon: Icons.admin_panel_settings,
      color: const Color(0xFFE0E0E0),
    ),
  };

  void _handleContinue() {
    if (_selectedRole == null) return;

    // Navigate to Login Screen with selected role
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          userRole: _roleData[_selectedRole!]!.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111121),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: const AgriTraceHeaderLogo(
                height: 36.0,
                iconColor: Color(0xFF00FFFF),
                textColor: Colors.white,
              ),
            ),

            // Headline
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome! Please select your role to continue.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            // Role Selection Cards
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                children: UserRole.values.map((role) {
                  return _buildRoleCard(role);
                }).toList(),
              ),
            ),
          ],
        ),
      ),

      // Continue Button (Fixed at Bottom)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111121).withOpacity(0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _selectedRole != null ? _handleContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF4F46E5).withOpacity(0.5),
            disabledForegroundColor: Colors.white.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(UserRole role) {
    final roleData = _roleData[role]!;
    final isSelected = _selectedRole == role;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRole = role;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2333),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? roleData.color : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: roleData.color.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected ? roleData.color : const Color(0xFF292938),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  roleData.icon,
                  color: isSelected ? const Color(0xFF111121) : roleData.color,
                  size: 30,
                ),
              ),

              const SizedBox(width: 16),

              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roleData.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      roleData.description,
                      style: const TextStyle(
                        color: Color(0xFF9D9DB8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Checkmark
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Icon(
                  Icons.check_circle,
                  color: roleData.color,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  RoleData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
