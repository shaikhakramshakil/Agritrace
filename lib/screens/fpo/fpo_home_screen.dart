import 'package:flutter/material.dart';
import 'package:agritrace/screens/fpo/procurement_screen.dart';
import 'package:agritrace/screens/fpo/processing_storage_screen.dart';
import 'package:agritrace/screens/fpo/fpo_profile_screen.dart';
import 'package:agritrace/widgets/agritrace_logo.dart';

class FpoHomeScreen extends StatefulWidget {
  const FpoHomeScreen({super.key});

  @override
  State<FpoHomeScreen> createState() => _FpoHomeScreenState();
}

class _FpoHomeScreenState extends State<FpoHomeScreen> {
  // Mock notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Processing Complete',
      'message': 'Batch #123 processing completed successfully',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'type': 'success',
      'isRead': false,
    },
    {
      'id': '2', 
      'title': 'Quality Alert',
      'message': 'Canola Batch #78 requires quality review',
      'time': DateTime.now().subtract(const Duration(hours: 3)),
      'type': 'warning',
      'isRead': false,
    },
    {
      'id': '3',
      'title': 'New Produce Arrival',
      'message': '50 MT of Soybeans arrived from Farm #45',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'type': 'info',
      'isRead': true,
    },
  ];

  // Mock alerts data
  final List<Map<String, dynamic>> _alerts = [
    {
      'id': '1',
      'icon': Icons.error,
      'iconColor': Color(0xFFE74C3C),
      'borderColor': Color(0xFFE74C3C),
      'title': 'Processing Delay',
      'description': 'Machine #3 requires maintenance.',
      'priority': 'high',
      'status': 'active',
    },
    {
      'id': '2',
      'icon': Icons.warning,
      'iconColor': Color(0xFFF1C40F),
      'borderColor': Color(0xFFF1C40F), 
      'title': 'Low Inventory Warning',
      'description': 'Sunflower seeds are running low.',
      'priority': 'medium',
      'status': 'active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C22),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Key Metrics
                    _buildSectionTitle('Live Overview'),
                    _buildMetricsCards(),

                    // Alerts
                    _buildSectionTitle('Urgent Alerts'),
                    _buildAlerts(),

                    // Recent Activity
                    _buildSectionTitle('Recent Activity'),
                    _buildRecentActivity(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // AgriTrace Logo
          const AgriTraceHeaderLogo(
            height: 28.0,
            iconColor: Color(0xFF00FFFF),
            textColor: Color(0xFFE0E0E0),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _showNotifications();
                },
                icon: Stack(
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFFE0E0E0),
                      size: 24,
                    ),
                    if (_notifications.any((n) => !n['isRead']))
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE74C3C),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FpoProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3498DB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFE0E0E0),
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.33,
        ),
      ),
    );
  }

  Widget _buildMetricsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMetricCard(
            title: 'Incoming Produce Today',
            value: '500 MT',
            trend: '+5%',
            trendColor: const Color(0xFF2ECC71),
            isPositive: true,
          ),
          const SizedBox(height: 16),
          _buildProcessingUtilizationCard(),
          const SizedBox(height: 16),
          _buildMetricCard(
            title: 'Live Inventory',
            value: '1,200 MT',
            trend: '+10%',
            trendColor: const Color(0xFF2ECC71),
            isPositive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required Color trendColor,
    required bool isPositive,
  }) {
    return GestureDetector(
      onTap: () => _showMetricDetails(title, value, trend, isPositive),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1B0F2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFBDC3C7).withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF3498DB),
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: trendColor,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: TextStyle(
                    color: trendColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingUtilizationCard() {
    return GestureDetector(
      onTap: () => _showProcessingDetails(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1B0F2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFBDC3C7).withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Processing Utilization',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 0.75,
                backgroundColor: const Color(0xFF0A0C22),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF3498DB),
                ),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '75%',
              style: TextStyle(
                color: Color(0xFF3498DB),
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlerts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _alerts.map((alert) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAlertCard(
            icon: alert['icon'] as IconData,
            iconColor: alert['iconColor'] as Color,
            borderColor: alert['borderColor'] as Color,
            title: alert['title'] as String,
            description: alert['description'] as String,
            alertData: alert,
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required String title,
    required String description,
    required Map<String, dynamic> alertData,
  }) {
    return GestureDetector(
      onTap: () => _showAlertDetails(alertData),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B0F2A),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: borderColor,
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: const Color(0xFFE0E0E0).withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showAlertDetails(alertData),
                icon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildActivityItem(
            icon: Icons.local_shipping,
            iconColor: const Color(0xFF3498DB),
            backgroundColor: const Color(0xFF3498DB).withOpacity(0.2),
            title: 'New produce arrival: 50 MT of Soybeans.',
            time: '2 hours ago',
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            icon: Icons.task_alt,
            iconColor: const Color(0xFF2ECC71),
            backgroundColor: const Color(0xFF2ECC71).withOpacity(0.2),
            title: 'Processing of Batch #123 completed.',
            time: '5 hours ago',
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            icon: Icons.science,
            iconColor: const Color(0xFFF1C40F),
            backgroundColor: const Color(0xFFF1C40F).withOpacity(0.2),
            title: 'Quality check flagged for Canola Batch #78.',
            time: '1 day ago',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B0F2A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: const Color(0xFFE0E0E0).withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B0F2A).withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFBDC3C7).withOpacity(0.1),
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.srcOver,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.add_circle,
                  label: 'New Arrival',
                  isSelected: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProcurementScreen(),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.play_circle,
                  label: 'Start Processing',
                  isSelected: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProcessingStorageScreen(),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.assessment,
                  label: 'View Reports',
                  isSelected: false,
                  onTap: () {
                    _showReportsScreen();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFF3498DB)
                : const Color(0xFFE0E0E0).withOpacity(0.7),
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF3498DB)
                  : const Color(0xFFE0E0E0).withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for interactions
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0C22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            for (var notification in _notifications) {
                              notification['isRead'] = true;
                            }
                          });
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All notifications marked as read')),
                          );
                        },
                        child: const Text('Mark All Read'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        final isRead = notification['isRead'] as bool;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isRead ? const Color(0xFF1B0F2A).withOpacity(0.5) : const Color(0xFF1B0F2A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isRead ? Colors.transparent : const Color(0xFF3498DB).withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification['title'],
                                      style: TextStyle(
                                        color: const Color(0xFFE0E0E0),
                                        fontSize: 16,
                                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (!isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF3498DB),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                notification['message'],
                                style: TextStyle(
                                  color: const Color(0xFFE0E0E0).withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatTime(notification['time']),
                                style: TextStyle(
                                  color: const Color(0xFFE0E0E0).withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0A0C22),
          title: Text(
            alert['title'],
            style: const TextStyle(color: Color(0xFFE0E0E0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert['description'],
                style: const TextStyle(color: Color(0xFFE0E0E0)),
              ),
              const SizedBox(height: 16),
              Text(
                'Priority: ${alert['priority'].toString().toUpperCase()}',
                style: TextStyle(
                  color: alert['priority'] == 'high' ? const Color(0xFFE74C3C) : const Color(0xFFF1C40F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${alert['status'].toString().toUpperCase()}',
                style: const TextStyle(color: Color(0xFFE0E0E0)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resolveAlert(alert['id']);
              },
              child: const Text('Resolve'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _resolveAlert(String alertId) {
    setState(() {
      _alerts.removeWhere((alert) => alert['id'] == alertId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert resolved successfully')),
    );
  }

  void _showMetricDetails(String title, String value, String trend, bool isPositive) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0C22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B0F2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF3498DB),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: isPositive ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trend,
                          style: TextStyle(
                            color: isPositive ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Detailed Breakdown:',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: _getMetricBreakdown(title),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _getMetricBreakdown(String title) {
    if (title.contains('Incoming Produce')) {
      return [
        _buildBreakdownItem('Soybeans', '200 MT', const Color(0xFF2ECC71)),
        _buildBreakdownItem('Sunflower Seeds', '150 MT', const Color(0xFF3498DB)),
        _buildBreakdownItem('Canola', '100 MT', const Color(0xFFF1C40F)),
        _buildBreakdownItem('Other', '50 MT', const Color(0xFFE74C3C)),
      ];
    } else if (title.contains('Live Inventory')) {
      return [
        _buildBreakdownItem('Processed Soybean Oil', '600 MT', const Color(0xFF2ECC71)),
        _buildBreakdownItem('Raw Soybeans', '300 MT', const Color(0xFF3498DB)),
        _buildBreakdownItem('Sunflower Oil', '200 MT', const Color(0xFFF1C40F)),
        _buildBreakdownItem('Other Products', '100 MT', const Color(0xFFE74C3C)),
      ];
    }
    return [
      _buildBreakdownItem('No detailed data available', '', const Color(0xFFE0E0E0)),
    ];
  }

  Widget _buildBreakdownItem(String name, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B0F2A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Color(0xFFE0E0E0)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFE0E0E0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showProcessingDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0C22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Processing Utilization Details',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B0F2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      '75%',
                      style: TextStyle(
                        color: Color(0xFF3498DB),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: 0.75,
                        backgroundColor: const Color(0xFF0A0C22),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3498DB)),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Machine Status:',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildMachineStatus('Machine #1', 'Running', 85, const Color(0xFF2ECC71)),
                    _buildMachineStatus('Machine #2', 'Running', 92, const Color(0xFF2ECC71)),
                    _buildMachineStatus('Machine #3', 'Maintenance', 0, const Color(0xFFE74C3C)),
                    _buildMachineStatus('Machine #4', 'Running', 78, const Color(0xFF2ECC71)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMachineStatus(String name, String status, int utilization, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B0F2A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Color(0xFFE0E0E0)),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$utilization%',
            style: const TextStyle(
              color: Color(0xFFE0E0E0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FpoReportsScreen(),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

// Simple Reports Screen
class FpoReportsScreen extends StatelessWidget {
  const FpoReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0C22),
        title: const Text(
          'FPO Reports',
          style: TextStyle(color: Color(0xFFE0E0E0)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE0E0E0)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analytics Dashboard',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildReportCard('Production Report', Icons.factory, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Production report generated')),
                      );
                    }),
                    _buildReportCard('Inventory Analysis', Icons.inventory, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inventory analysis ready')),
                      );
                    }),
                    _buildReportCard('Quality Metrics', Icons.assessment, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quality metrics compiled')),
                      );
                    }),
                    _buildReportCard('Financial Summary', Icons.account_balance, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Financial summary created')),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B0F2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFBDC3C7).withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF3498DB),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
