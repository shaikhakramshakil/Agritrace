import 'package:flutter/material.dart';
import 'package:agritrace/widgets/agritrace_logo.dart';
import 'package:agritrace/screens/processor/production_screen.dart';
import 'package:agritrace/screens/processor/quality_screen.dart';
import 'package:agritrace/screens/processor/reports_screen.dart';
import 'package:agritrace/screens/processor/settings_screen.dart';

class ProcessorHomeScreen extends StatefulWidget {
  const ProcessorHomeScreen({super.key});

  @override
  State<ProcessorHomeScreen> createState() => _ProcessorHomeScreenState();
}

class _ProcessorHomeScreenState extends State<ProcessorHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProcessorDashboardPage(),
    const ProductionScreen(),
    const QualityScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111121),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1C2E),
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: const Color(0xFF8B8B9A),
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Production',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: 'Quality',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ProcessorDashboardPage extends StatefulWidget {
  const ProcessorDashboardPage({super.key});

  @override
  State<ProcessorDashboardPage> createState() => _ProcessorDashboardPageState();
}

class _ProcessorDashboardPageState extends State<ProcessorDashboardPage> {
  // Mock data for notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Quality Check Required',
      'message': 'Batch #PR001 needs quality verification before processing',
      'time': '2 hours ago',
      'type': 'urgent',
      'read': false,
    },
    {
      'id': 2,
      'title': 'Equipment Maintenance',
      'message': 'Mill #2 scheduled for maintenance tomorrow at 10 AM',
      'time': '5 hours ago',
      'type': 'info',
      'read': false,
    },
    {
      'id': 3,
      'title': 'New Order Received',
      'message': 'Order #ORD789 for 500kg wheat flour received',
      'time': '1 day ago',
      'type': 'info',
      'read': true,
    },
  ];

  // Mock data for alerts
  final List<Map<String, dynamic>> _alerts = [
    {
      'id': 1,
      'title': 'High Temperature Alert',
      'description': 'Processing unit temperature exceeds safe limits',
      'priority': 'high',
      'status': 'active',
      'timestamp': '10:30 AM',
      'facility': 'Mill #2',
    },
    {
      'id': 2,
      'title': 'Low Stock Warning',
      'description': 'Raw material inventory below minimum threshold',
      'priority': 'medium',
      'status': 'pending',
      'timestamp': '09:15 AM',
      'facility': 'Warehouse A',
    },
    {
      'id': 3,
      'title': 'Equipment Calibration Due',
      'description': 'Weighing scale requires recalibration',
      'priority': 'low',
      'status': 'scheduled',
      'timestamp': 'Tomorrow',
      'facility': 'Quality Lab',
    },
  ];

  // Mock data for processing metrics
  final Map<String, dynamic> _processingMetrics = {
    'dailyProduction': {
      'value': '2,450',
      'unit': 'kg',
      'change': '+8.5%',
      'isPositive': true,
    },
    'efficiency': {
      'value': '94.2',
      'unit': '%',
      'change': '+2.1%',
      'isPositive': true,
    },
    'qualityScore': {
      'value': '98.7',
      'unit': '%',
      'change': '+0.8%',
      'isPositive': true,
    },
    'wasteReduction': {
      'value': '3.2',
      'unit': '%',
      'change': '-0.5%',
      'isPositive': true,
    },
  };

  // Mock data for active batches
  final List<Map<String, dynamic>> _activeBatches = [
    {
      'id': 'PR001',
      'type': 'Wheat Flour',
      'quantity': '500kg',
      'status': 'Processing',
      'progress': 0.75,
      'estimatedCompletion': '2:30 PM',
      'quality': 'Grade A',
    },
    {
      'id': 'PR002',
      'type': 'Rice Bran Oil',
      'quantity': '200L',
      'status': 'Quality Check',
      'progress': 0.90,
      'estimatedCompletion': '4:00 PM',
      'quality': 'Grade A+',
    },
    {
      'id': 'PR003',
      'type': 'Corn Flour',
      'quantity': '300kg',
      'status': 'Packaging',
      'progress': 0.95,
      'estimatedCompletion': '1:45 PM',
      'quality': 'Grade A',
    },
  ];

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Mark all as read
                      setState(() {
                        for (var notification in _notifications) {
                          notification['read'] = true;
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Mark all read'),
                  ),
                ],
              ),
            ),
            // Notifications list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: notification['read'] 
                          ? const Color(0xFF262640) 
                          : const Color(0xFF4F46E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: notification['type'] == 'urgent' 
                            ? Colors.red.withOpacity(0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              notification['type'] == 'urgent' 
                                  ? Icons.warning 
                                  : Icons.info,
                              color: notification['type'] == 'urgent' 
                                  ? Colors.red 
                                  : Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                notification['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              notification['time'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification['message'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
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
      ),
    );
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C2E),
        title: Text(
          alert['title'],
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alert['description'],
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Priority: ', style: TextStyle(color: Colors.grey)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: alert['priority'] == 'high' 
                        ? Colors.red.withOpacity(0.2)
                        : alert['priority'] == 'medium'
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    alert['priority'].toUpperCase(),
                    style: TextStyle(
                      color: alert['priority'] == 'high' 
                          ? Colors.red
                          : alert['priority'] == 'medium'
                              ? Colors.orange
                              : Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Facility: ${alert['facility']}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Time: ${alert['timestamp']}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle alert action
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alert acknowledged'),
                  backgroundColor: Color(0xFF4F46E5),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
            ),
            child: const Text('Acknowledge'),
          ),
        ],
      ),
    );
  }

  void _showMetricDetails(String metricKey, Map<String, dynamic> metric) {
    String title = '';
    String description = '';
    
    switch (metricKey) {
      case 'dailyProduction':
        title = 'Daily Production';
        description = 'Total quantity processed today across all facilities';
        break;
      case 'efficiency':
        title = 'Processing Efficiency';
        description = 'Overall efficiency rating based on time and resource utilization';
        break;
      case 'qualityScore':
        title = 'Quality Score';
        description = 'Average quality rating of processed products';
        break;
      case 'wasteReduction':
        title = 'Waste Reduction';
        description = 'Percentage of waste reduced compared to last period';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C2E),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Current Value: ',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  '${metric['value']}${metric['unit']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Change: ',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  metric['change'],
                  style: TextStyle(
                    color: metric['isPositive'] ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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

  void _showBatchDetails(Map<String, dynamic> batch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C2E),
        title: Text(
          'Batch ${batch['id']}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', batch['type']),
            _buildDetailRow('Quantity', batch['quantity']),
            _buildDetailRow('Status', batch['status']),
            _buildDetailRow('Quality', batch['quality']),
            _buildDetailRow('Estimated Completion', batch['estimatedCompletion']),
            const SizedBox(height: 16),
            const Text(
              'Progress',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: batch['progress'],
              backgroundColor: Colors.grey[700],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
            ),
            const SizedBox(height: 8),
            Text(
              '${(batch['progress'] * 100).toInt()}% Complete',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Viewing detailed logs for batch ${batch['id']}'),
                  backgroundColor: const Color(0xFF4F46E5),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
            ),
            child: const Text('View Logs'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header with logo, title, and notifications
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              children: [
                // AgriTrace Logo
                const AgriTraceLogo(
                  size: 48.0,
                  primaryColor: Color(0xFF00FFFF),
                ),
                const SizedBox(width: 16),
                // Title and subtitle
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Processor Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Monitor processing operations',
                        style: TextStyle(
                          color: Color(0xFF8B8B9A),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Notifications icon
                Stack(
                  children: [
                    IconButton(
                      onPressed: _showNotifications,
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    if (_notifications.any((n) => !n['read']))
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Processing Metrics
                  const Text(
                    'Processing Metrics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: _processingMetrics.entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _showMetricDetails(entry.key, entry.value),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2A2A3E),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${entry.value['value']}${entry.value['unit']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    entry.value['change'],
                                    style: TextStyle(
                                      color: entry.value['isPositive'] 
                                          ? Colors.green 
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getMetricTitle(entry.key),
                                style: const TextStyle(
                                  color: Color(0xFF8B8B9A),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Active Alerts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Alerts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all alerts
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigating to all alerts...'),
                              backgroundColor: Color(0xFF4F46E5),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _alerts.take(3).length,
                    itemBuilder: (context, index) {
                      final alert = _alerts[index];
                      return GestureDetector(
                        onTap: () => _showAlertDetails(alert),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: alert['priority'] == 'high' 
                                  ? Colors.red.withOpacity(0.3)
                                  : alert['priority'] == 'medium'
                                      ? Colors.orange.withOpacity(0.3)
                                      : Colors.green.withOpacity(0.3),
                            ),
                            // gradient: LinearGradient(
                            //   colors: [
                            //     _getPriorityColor(alert['priority']).withOpacity(0.2),
                            //     const Color(0xFF1C1C2E),
                            //   ],
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomRight,
                            // ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: alert['priority'] == 'high' 
                                      ? Colors.red.withOpacity(0.2)
                                      : alert['priority'] == 'medium'
                                          ? Colors.orange.withOpacity(0.2)
                                          : Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  alert['priority'] == 'high' 
                                      ? Icons.error
                                      : alert['priority'] == 'medium'
                                          ? Icons.warning
                                          : Icons.info,
                                  color: alert['priority'] == 'high' 
                                      ? Colors.red
                                      : alert['priority'] == 'medium'
                                          ? Colors.orange
                                          : Colors.green,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            alert['title'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          alert['timestamp'],
                                          style: const TextStyle(
                                            color: Color(0xFF8B8B9A),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      alert['description'],
                                      style: const TextStyle(
                                        color: Color(0xFF8B8B9A),
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Active Batches
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Batches',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all batches
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigating to all batches...'),
                              backgroundColor: Color(0xFF4F46E5),
                            ),
                          );
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _activeBatches.length,
                    itemBuilder: (context, index) {
                      final batch = _activeBatches[index];
                      return GestureDetector(
                        onTap: () => _showBatchDetails(batch),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2A2A3E),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4F46E5).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2,
                                      color: Color(0xFF4F46E5),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Batch ${batch['id']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(batch['status']).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                batch['status'],
                                                style: TextStyle(
                                                  color: _getStatusColor(batch['status']),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${batch['type']} • ${batch['quantity']}',
                                          style: const TextStyle(
                                            color: Color(0xFF8B8B9A),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: batch['progress'],
                                      backgroundColor: Colors.grey[700],
                                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${(batch['progress'] * 100).toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'ETA: ${batch['estimatedCompletion']}',
                                    style: const TextStyle(
                                      color: Color(0xFF8B8B9A),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    batch['quality'],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMetricTitle(String key) {
    switch (key) {
      case 'dailyProduction':
        return 'Daily Production';
      case 'efficiency':
        return 'Efficiency';
      case 'qualityScore':
        return 'Quality Score';
      case 'wasteReduction':
        return 'Waste Reduction';
      default:
        return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.blue;
      case 'quality check':
        return Colors.orange;
      case 'packaging':
        return Colors.green;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}