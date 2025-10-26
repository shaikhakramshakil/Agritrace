import 'package:flutter/material.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  String _selectedFilter = 'All';
  List<String> _filters = ['All', 'System', 'Users', 'Warehouses', 'Security'];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'High Priority: Warehouse Capacity Alert',
      'message': 'Warehouse LA-01 has reached 95% capacity. Immediate attention required.',
      'type': 'Warehouses',
      'priority': 'High',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'icon': Icons.warning,
      'color': Colors.red,
    },
    {
      'id': 2,
      'title': 'New User Registration',
      'message': 'Farmer John Smith has registered and is pending approval.',
      'type': 'Users',
      'priority': 'Medium',
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'isRead': false,
      'icon': Icons.person_add,
      'color': Colors.blue,
    },
    {
      'id': 3,
      'title': 'System Backup Completed',
      'message': 'Daily backup process completed successfully at 02:00 AM.',
      'type': 'System',
      'priority': 'Low',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'isRead': true,
      'icon': Icons.backup,
      'color': Colors.green,
    },
    {
      'id': 4,
      'title': 'Security Alert: Multiple Login Attempts',
      'message': 'Multiple failed login attempts detected from IP: 192.168.1.100',
      'type': 'Security',
      'priority': 'High',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'isRead': false,
      'icon': Icons.security,
      'color': Colors.orange,
    },
    {
      'id': 5,
      'title': 'Warehouse Maintenance Scheduled',
      'message': 'Warehouse NY-03 is scheduled for maintenance on October 25, 2025.',
      'type': 'Warehouses',
      'priority': 'Medium',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'icon': Icons.build,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _selectedFilter == 'All' 
        ? _notifications 
        : _notifications.where((n) => n['type'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all, color: Colors.white),
          ),
          IconButton(
            onPressed: _clearAllNotifications,
            icon: const Icon(Icons.clear_all, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          _buildNotificationStats(filteredNotifications),
          Expanded(
            child: _buildNotificationsList(filteredNotifications),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4F46E5) : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationStats(List<Map<String, dynamic>> notifications) {
    final unreadCount = notifications.where((n) => !n['isRead']).length;
    final highPriorityCount = notifications.where((n) => n['priority'] == 'High').length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Total', notifications.length.toString(), Icons.notifications),
          ),
          Expanded(
            child: _buildStatItem('Unread', unreadCount.toString(), Icons.mark_email_unread),
          ),
          Expanded(
            child: _buildStatItem('High Priority', highPriorityCount.toString(), Icons.priority_high),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4F46E5), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications found',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] ? const Color(0xFF1F2937) : const Color(0xFF1F2937).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['isRead'] ? Colors.transparent : notification['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showNotificationDetails(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: notification['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['color'],
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
                            notification['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: notification['isRead'] ? FontWeight.w500 : FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildPriorityBadge(notification['priority']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTimestamp(notification['timestamp']),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            if (!notification['isRead'])
                              IconButton(
                                onPressed: () => _markAsRead(notification['id']),
                                icon: const Icon(Icons.mark_email_read, color: Colors.blue, size: 16),
                              ),
                            IconButton(
                              onPressed: () => _deleteNotification(notification['id']),
                              icon: const Icon(Icons.delete, color: Colors.red, size: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = Colors.red;
        break;
      case 'Medium':
        color = Colors.orange;
        break;
      case 'Low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _markAsRead(int id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification marked as read'),
        backgroundColor: Color(0xFF4F46E5),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Color(0xFF4F46E5),
      ),
    );
  }

  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification deleted'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: const Text(
          'Clear All Notifications',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: Row(
          children: [
            Icon(notification['icon'], color: notification['color']),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                notification['title'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriorityBadge(notification['priority']),
            const SizedBox(height: 16),
            Text(
              notification['message'],
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'Type: ${notification['type']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${_formatTimestamp(notification['timestamp'])}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!notification['isRead'])
            ElevatedButton(
              onPressed: () {
                _markAsRead(notification['id']);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
              ),
              child: const Text('Mark as Read'),
            ),
        ],
      ),
    );
  }
}