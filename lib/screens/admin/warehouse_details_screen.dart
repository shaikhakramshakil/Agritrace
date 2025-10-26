import 'package:flutter/material.dart';

class WarehouseDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> warehouse;

  const WarehouseDetailsScreen({super.key, required this.warehouse});

  @override
  State<WarehouseDetailsScreen> createState() => _WarehouseDetailsScreenState();
}

class _WarehouseDetailsScreenState extends State<WarehouseDetailsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Inventory', 'Analytics', 'Staff'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.warehouse['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ID: ${widget.warehouse['id']}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _shareWarehouse(),
            icon: const Icon(Icons.share, color: Colors.white),
          ),
          IconButton(
            onPressed: () => _editWarehouse(),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF1F2937),
      child: TabBar(
        controller: null,
        isScrollable: true,
        indicatorColor: const Color(0xFF4F46E5),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildInventoryTab();
      case 2:
        return _buildAnalyticsTab();
      case 3:
        return _buildStaffTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildLocationCard(),
          const SizedBox(height: 16),
          _buildCapacityCard(),
          const SizedBox(height: 16),
          _buildCropsCard(),
          const SizedBox(height: 16),
          _buildContactCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    'Status',
                    widget.warehouse['status'],
                    _getStatusColor(widget.warehouse['status']),
                    Icons.info_outline,
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    'Capacity',
                    '${widget.warehouse['capacity']}%',
                    _getCapacityColor(widget.warehouse['capacity']),
                    Icons.storage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    'Region',
                    widget.warehouse['region'],
                    Colors.blue,
                    Icons.location_on,
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    'Last Updated',
                    _formatLastUpdated(widget.warehouse['lastUpdated']),
                    Colors.green,
                    Icons.update,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Address', widget.warehouse['location']),
            _buildDetailRow('Region', widget.warehouse['region']),
            _buildDetailRow('Coordinates', 
              '${widget.warehouse['coordinates']['lat']}, ${widget.warehouse['coordinates']['lng']}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openInMaps(),
              icon: const Icon(Icons.map),
              label: const Text('Open in Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityCard() {
    final currentStock = widget.warehouse['currentStock'];
    final maxCapacity = widget.warehouse['maxCapacity'];
    final availableSpace = maxCapacity - currentStock;

    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Capacity Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Capacity visualization
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: (100 - widget.warehouse['capacity']).toInt(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: const Center(
                        child: Text(
                          'Available Space',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: widget.warehouse['capacity'].toInt(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getCapacityColor(widget.warehouse['capacity']).withOpacity(0.7),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                      ),
                      child: const Center(
                        child: Text(
                          'Used Space',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCapacityDetail('Current Stock', '$currentStock tons'),
                ),
                Expanded(
                  child: _buildCapacityDetail('Max Capacity', '$maxCapacity tons'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildCapacityDetail('Available Space', '$availableSpace tons'),
                ),
                Expanded(
                  child: _buildCapacityDetail('Utilization', '${widget.warehouse['capacity']}%'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCropsCard() {
    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Primary Crops',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (widget.warehouse['primaryCrops'] as List<String>)
                  .map((crop) => _buildCropChip(crop))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropChip(String crop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4F46E5),
          width: 1,
        ),
      ),
      child: Text(
        crop,
        style: const TextStyle(
          color: Color(0xFF4F46E5),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Manager', widget.warehouse['manager']),
            _buildDetailRow('Phone', widget.warehouse['phone']),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _callManager(),
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _messageManager(),
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          'Inventory details will be implemented here',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          'Analytics charts will be implemented here',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStaffTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          'Staff information will be implemented here',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Near Capacity':
        return Colors.orange;
      case 'Low Stock':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getCapacityColor(int capacity) {
    if (capacity >= 90) return Colors.red;
    if (capacity >= 70) return Colors.orange;
    if (capacity >= 30) return Colors.green;
    return Colors.blue;
  }

  String _formatLastUpdated(DateTime lastUpdated) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _shareWarehouse() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${widget.warehouse['name']} details...'),
        backgroundColor: const Color(0xFF4F46E5),
      ),
    );
  }

  void _editWarehouse() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit warehouse functionality coming soon...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _openInMaps() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening in maps...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _callManager() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${widget.warehouse['manager']}...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _messageManager() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Messaging ${widget.warehouse['manager']}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}