import 'package:flutter/material.dart';
import 'package:agritrace/screens/farmer/farmer_home_screen.dart';
import 'package:agritrace/screens/fpo/fpo_home_screen.dart';
import 'package:agritrace/screens/processor/processor_home_screen.dart';
import 'package:agritrace/screens/retailer/retailer_inventory_screen.dart';
import 'package:agritrace/screens/policymaker/policymaker_dashboard_screen.dart';
import 'package:agritrace/screens/logistics/logistics_home_screen.dart';
import 'package:agritrace/screens/admin/admin_dashboard_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String userRole;

  const ProfileSetupScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Form controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _farmSizeController = TextEditingController();
  final TextEditingController _cropTypeController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _farmSizeController.dispose();
    _cropTypeController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Profile setup complete - navigate to dashboard based on role
      final role = widget.userRole.toLowerCase().trim().replaceAll(' ', '');
      
      Widget targetScreen;
      switch (role) {
        case 'farmer':
          targetScreen = const FarmerHomeScreen();
          break;
        case 'fpo':
          targetScreen = const FpoHomeScreen();
          break;
        case 'processor':
          targetScreen = const ProcessorHomeScreen();
          break;
        case 'retailer':
          targetScreen = const RetailerInventoryScreen();
          break;
        case 'policymaker':
          targetScreen = const PolicyMakerDashboardScreen();
          break;
        case 'logistics':
          targetScreen = const LogisticsHomeScreen();
          break;
        case 'admin':
          targetScreen = const AdminDashboardScreen();
          break;
        default:
          // Show error and return to role selection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unknown role: ${widget.userRole}. Please select again.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
      }
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => targetScreen),
      );
    }
  }

  void _handleSkip() {
    // Navigate to appropriate dashboard based on user role
    final role = widget.userRole.toLowerCase().trim().replaceAll(' ', '');
    
    Widget targetScreen;
    switch (role) {
      case 'farmer':
        targetScreen = const FarmerHomeScreen();
        break;
      case 'fpo':
        targetScreen = const FpoHomeScreen();
        break;
      case 'processor':
        targetScreen = const ProcessorHomeScreen();
        break;
      case 'retailer':
        targetScreen = const RetailerInventoryScreen();
        break;
      case 'policymaker':
        targetScreen = const PolicyMakerDashboardScreen();
        break;
      case 'logistics':
        targetScreen = const LogisticsHomeScreen();
        break;
      case 'admin':
        targetScreen = const AdminDashboardScreen();
        break;
      default:
        // Show error and return to role selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unknown role: ${widget.userRole}. Please select again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111121),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 448),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C2E),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress Indicator
                  _buildProgressIndicator(),

                  const SizedBox(height: 24),

                  // Title and Subtitle
                  Text(
                    _getStepTitle(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _getStepSubtitle(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9D9DB8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Form Fields
                  _buildStepContent(),

                  const SizedBox(height: 32),

                  // Continue Button
                  ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Skip Button
                  TextButton(
                    onPressed: _handleSkip,
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9D9DB8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${_currentStep + 1} of $_totalSteps',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9D9DB8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C53),
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (_currentStep + 1) / _totalSteps,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return "Let's Get Started";
      case 1:
        return "Tell Us More";
      case 2:
        return "Almost Done";
      default:
        return "Let's Get Started";
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return "Create your AgriTrace profile.";
      case 1:
        return "Add your location and details.";
      case 2:
        return "Complete your profile setup.";
      default:
        return "Create your AgriTrace profile.";
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoForm();
      case 1:
        return _buildLocationForm();
      case 2:
        return _buildRoleSpecificForm();
      default:
        return _buildBasicInfoForm();
    }
  }

  Widget _buildBasicInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'Full Name',
          placeholder: 'Enter your full name',
          controller: _fullNameController,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Email Address',
          placeholder: 'Enter your email address',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Phone Number',
          placeholder: 'Enter your phone number',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildLocationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'Location',
          placeholder: 'Enter your location (City, State)',
          controller: _locationController,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Pin Code',
          placeholder: 'Enter your pin code',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'Address',
          placeholder: 'Enter your complete address',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildRoleSpecificForm() {
    // Different fields based on user role
    if (widget.userRole.toLowerCase() == 'farmer') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputField(
            label: 'Farm Size',
            placeholder: 'Enter farm size (in acres)',
            controller: _farmSizeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          _buildInputField(
            label: 'Primary Crop Type',
            placeholder: 'Enter primary crop type',
            controller: _cropTypeController,
          ),
          const SizedBox(height: 24),
          _buildInputField(
            label: 'Years of Experience',
            placeholder: 'Enter years of farming experience',
            keyboardType: TextInputType.number,
          ),
        ],
      );
    } else if (widget.userRole.toLowerCase() == 'fpo') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputField(
            label: 'Organization Name',
            placeholder: 'Enter FPO name',
          ),
          const SizedBox(height: 24),
          _buildInputField(
            label: 'Number of Farmers',
            placeholder: 'Enter number of associated farmers',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          _buildInputField(
            label: 'Registration Number',
            placeholder: 'Enter FPO registration number',
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputField(
            label: 'Organization Name',
            placeholder: 'Enter your organization name',
          ),
          const SizedBox(height: 24),
          _buildInputField(
            label: 'Designation',
            placeholder: 'Enter your designation',
          ),
          const SizedBox(height: 24),
          _buildInputField(
            label: 'Department',
            placeholder: 'Enter your department',
          ),
        ],
      );
    }
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    TextEditingController? controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C26),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF3C3C53),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFF9D9DB8),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
