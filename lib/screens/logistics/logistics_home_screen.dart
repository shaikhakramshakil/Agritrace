import 'package:flutter/material.dart';
import 'package:agritrace/screens/logistics/warehouse_map_screen.dart';
import 'package:agritrace/screens/logistics/logistics_tracker_screen.dart';
import 'package:agritrace/screens/logistics/logistics_profile_screen.dart';

class LogisticsHomeScreen extends StatefulWidget {
  const LogisticsHomeScreen({super.key});

  @override
  State<LogisticsHomeScreen> createState() => _LogisticsHomeScreenState();
}

class _LogisticsHomeScreenState extends State<LogisticsHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WarehouseMapScreen(),
    const LogisticsTrackerScreen(),
    const LogisticsProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        
        final navigator = Navigator.of(context);
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        
        if (shouldPop ?? false) {
          navigator.pop();
        }
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.map,
                    label: 'Map',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.local_shipping,
                    label: 'Tracker',
                    index: 1,
                  ),
                  _buildNavItem(
                    icon: Icons.person,
                    label: 'Profile',
                    index: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF00BCD4) : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF00BCD4) : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
