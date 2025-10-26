import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailAlerts = false;
  bool _smsAlerts = true;
  bool _darkMode = true;
  bool _autoBackup = true;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Manage your preferences',
                          style: TextStyle(
                            color: Color(0xFF8B8B9A),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Profile Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2A2A3E),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF4F46E5),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Processor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'processor@agritrace.com',
                          style: TextStyle(
                            color: Color(0xFF8B8B9A),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit profile coming soon!'),
                          backgroundColor: Color(0xFF4F46E5),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notifications Section
            _buildSectionTitle('Notifications'),
            _buildSettingsCard([
              _buildSwitchTile(
                'Push Notifications',
                'Receive push notifications',
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
                Icons.notifications,
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildSwitchTile(
                'Email Alerts',
                'Receive alerts via email',
                _emailAlerts,
                (value) => setState(() => _emailAlerts = value),
                Icons.email,
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildSwitchTile(
                'SMS Alerts',
                'Receive alerts via SMS',
                _smsAlerts,
                (value) => setState(() => _smsAlerts = value),
                Icons.sms,
              ),
            ]),

            const SizedBox(height: 24),

            // Appearance Section
            _buildSectionTitle('Appearance'),
            _buildSettingsCard([
              _buildSwitchTile(
                'Dark Mode',
                'Use dark theme',
                _darkMode,
                (value) => setState(() => _darkMode = value),
                Icons.dark_mode,
              ),
            ]),

            const SizedBox(height: 24),

            // Data & Storage Section
            _buildSectionTitle('Data & Storage'),
            _buildSettingsCard([
              _buildSwitchTile(
                'Auto Backup',
                'Automatically backup data',
                _autoBackup,
                (value) => setState(() => _autoBackup = value),
                Icons.backup,
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActionTile(
                'Clear Cache',
                'Free up storage space',
                Icons.cleaning_services,
                () {
                  _showConfirmDialog(
                    'Clear Cache',
                    'Are you sure you want to clear the cache?',
                    () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cache cleared successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  );
                },
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActionTile(
                'Export Data',
                'Download your data',
                Icons.download,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exporting data...'),
                      backgroundColor: Color(0xFF4F46E5),
                    ),
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Security Section
            _buildSectionTitle('Security'),
            _buildSettingsCard([
              _buildActionTile(
                'Change Password',
                'Update your password',
                Icons.lock,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Change password coming soon!'),
                      backgroundColor: Color(0xFF4F46E5),
                    ),
                  );
                },
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActionTile(
                'Two-Factor Authentication',
                'Add an extra layer of security',
                Icons.security,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('2FA setup coming soon!'),
                      backgroundColor: Color(0xFF4F46E5),
                    ),
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            // About Section
            _buildSectionTitle('About'),
            _buildSettingsCard([
              _buildActionTile(
                'Help & Support',
                'Get help and contact us',
                Icons.help,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening support...'),
                      backgroundColor: Color(0xFF4F46E5),
                    ),
                  );
                },
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActionTile(
                'Terms & Conditions',
                'Read our terms',
                Icons.description,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening terms...'),
                      backgroundColor: Color(0xFF4F46E5),
                    ),
                  );
                },
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildActionTile(
                'Privacy Policy',
                'Read our privacy policy',
                Icons.privacy_tip,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening privacy policy...'),
                      backgroundColor: Color(0xFF4F46E5),
                    ),
                  );
                },
              ),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              _buildInfoTile(
                'App Version',
                '1.0.0',
                Icons.info,
              ),
            ]),

            const SizedBox(height: 24),

            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmDialog(
                    'Logout',
                    'Are you sure you want to logout?',
                    () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logging out...'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF8B8B9A),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2A3E),
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8B8B9A)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF8B8B9A),
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4F46E5),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8B8B9A)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF8B8B9A),
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF8B8B9A),
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8B8B9A)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF8B8B9A),
          fontSize: 14,
        ),
      ),
    );
  }

  void _showConfirmDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C2E),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Color(0xFF8B8B9A))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
