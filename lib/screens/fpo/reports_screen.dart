import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTimeframe = 'This Month';
  String _selectedCategory = 'All Reports';
  int _currentNavIndex = 3; // Reports is at index 3

  // Mock reports data
  final List<Map<String, dynamic>> _allReports = [
    {
      'id': 'RPT001',
      'title': 'Monthly Production Summary',
      'type': 'Production',
      'description': 'Comprehensive overview of production metrics for the current month',
      'dateGenerated': '2024-02-15',
      'status': 'Ready',
      'size': '2.3 MB',
      'downloadCount': 45,
      'lastAccessed': '2 hours ago',
      'insights': [
        'Production increased by 15% compared to last month',
        'Quality ratings improved across all categories',
        'New farm registrations: 8'
      ],
    },
    {
      'id': 'RPT002',
      'title': 'Supply Chain Analytics',
      'type': 'Supply Chain',
      'description': 'Analysis of supply chain efficiency and bottlenecks',
      'dateGenerated': '2024-02-14',
      'status': 'Ready',
      'size': '1.8 MB',
      'downloadCount': 32,
      'lastAccessed': '5 hours ago',
      'insights': [
        'Average delivery time reduced by 2 days',
        'Storage utilization at 85%',
        'Transportation costs decreased by 8%'
      ],
    },
    {
      'id': 'RPT003',
      'title': 'Quality Control Report',
      'type': 'Quality',
      'description': 'Detailed quality assessment across all product categories',
      'dateGenerated': '2024-02-13',
      'status': 'Processing',
      'size': 'Generating...',
      'downloadCount': 0,
      'lastAccessed': 'Never',
      'insights': [
        'Quality standards met for 95% of products',
        'Improved traceability implementation',
        'Certification compliance at 100%'
      ],
    },
    {
      'id': 'RPT004',
      'title': 'Financial Performance',
      'type': 'Financial',
      'description': 'Revenue, costs, and profit analysis for the current quarter',
      'dateGenerated': '2024-02-12',
      'status': 'Ready',
      'size': '3.1 MB',
      'downloadCount': 78,
      'lastAccessed': '1 day ago',
      'insights': [
        'Revenue growth of 22% year-over-year',
        'Cost optimization saved ₹2.5L this quarter',
        'Profit margin improved to 18%'
      ],
    },
    {
      'id': 'RPT005',
      'title': 'Sustainability Metrics',
      'type': 'Sustainability',
      'description': 'Environmental impact and sustainability initiatives tracking',
      'dateGenerated': '2024-02-11',
      'status': 'Ready',
      'size': '1.2 MB',
      'downloadCount': 23,
      'lastAccessed': '3 days ago',
      'insights': [
        'Carbon footprint reduced by 12%',
        'Water usage optimized by 20%',
        'Renewable energy adoption at 65%'
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredReports {
    List<Map<String, dynamic>> filtered = _allReports;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((report) =>
              report['title']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              report['type']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              report['description']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All Reports') {
      filtered = filtered
          .where((report) => report['type'] == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Reports & Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[600],
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
                      '2',
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
            onPressed: () => _showReportSettings(),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _buildSummaryCard('Total Reports', '${_allReports.length}', Icons.assessment, Colors.purple)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Ready', '${_allReports.where((r) => r['status'] == 'Ready').length}', Icons.check_circle, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Processing', '${_allReports.where((r) => r['status'] == 'Processing').length}', Icons.hourglass_empty, Colors.orange)),
              ],
            ),
          ),
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search reports by title, type, or description...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Chips
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryChip('All Reports'),
                            const SizedBox(width: 8),
                            _buildCategoryChip('Production'),
                            const SizedBox(width: 8),
                            _buildCategoryChip('Financial'),
                            const SizedBox(width: 8),
                            _buildCategoryChip('Quality'),
                            const SizedBox(width: 8),
                            _buildCategoryChip('Supply Chain'),
                            const SizedBox(width: 8),
                            _buildCategoryChip('Sustainability'),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _showAdvancedFilters,
                      icon: const Icon(Icons.tune),
                      tooltip: 'Advanced Filters',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Reports List
          Expanded(
            child: _filteredReports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assessment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No reports found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = _filteredReports[index];
                      return _buildReportCard(report);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showGenerateReportDialog,
        backgroundColor: Colors.purple[600],
        child: const Icon(Icons.add_chart),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
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

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple[600] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    Color statusColor;
    IconData statusIcon;
    
    switch (report['status']) {
      case 'Ready':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Processing':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showReportDetails(report),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          report['status'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      report['type'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    report['dateGenerated'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.file_download_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${report['downloadCount']} downloads',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.storage_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    report['size'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last accessed ${report['lastAccessed']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Row(
                    children: [
                      if (report['status'] == 'Ready') ...[
                        IconButton(
                          onPressed: () => _downloadReport(report),
                          icon: Icon(Icons.download_outlined, size: 20, color: Colors.blue[600]),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _shareReport(report),
                          icon: Icon(Icons.share_outlined, size: 20, color: Colors.green[600]),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ] else ...[
                        IconButton(
                          onPressed: () => _showProcessingStatus(report),
                          icon: Icon(Icons.info_outline, size: 20, color: Colors.orange[600]),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
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
              color: isSelected ? Colors.purple[600] : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.purple[600] : Colors.grey[600],
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
      case 3: // Reports (current screen)
        // Already on reports screen
        break;
      case 4: // Profile
        Navigator.pushReplacementNamed(context, '/profile');
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
              'Report Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: const Text('Report Ready'),
              subtitle: const Text('Monthly Production Summary is ready for download'),
              trailing: const Text('2h ago'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule_outlined, color: Colors.orange),
              title: const Text('Processing Report'),
              subtitle: const Text('Quality Control Report is being generated'),
              trailing: const Text('Processing'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Report Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: const Text('Scheduled Reports'),
              subtitle: const Text('Manage automatic report generation'),
              onTap: () {
                Navigator.pop(context);
                _showScheduledReports();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notification Settings'),
              subtitle: const Text('Configure report notifications'),
              onTap: () {
                Navigator.pop(context);
                _showNotificationSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Export Settings'),
              subtitle: const Text('Default export formats and options'),
              onTap: () {
                Navigator.pop(context);
                _showExportSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Advanced Filters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Time Period', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['This Month', 'Last Month', 'This Quarter', 'Last Quarter', 'This Year']
                  .map((period) => _buildTimeframeChip(period))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Status', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'Ready', 'Processing']
                  .map((status) => _buildStatusChip(status))
                  .toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeChip(String timeframe) {
    final isSelected = _selectedTimeframe == timeframe;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTimeframe = timeframe;
        });
      },
      child: Chip(
        label: Text(timeframe),
        backgroundColor: isSelected ? Colors.purple[600] : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Chip(
      label: Text(status),
      backgroundColor: Colors.grey[200],
    );
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      report['title'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Report ID', report['id']),
              _buildDetailRow('Type', report['type']),
              _buildDetailRow('Status', report['status']),
              _buildDetailRow('Date Generated', report['dateGenerated']),
              _buildDetailRow('File Size', report['size']),
              _buildDetailRow('Download Count', '${report['downloadCount']}'),
              _buildDetailRow('Last Accessed', report['lastAccessed']),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                report['description'],
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              const Text(
                'Key Insights',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...((report['insights'] as List<String>).map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right, color: Colors.purple[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insight,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ))).toList(),
              const SizedBox(height: 24),
              if (report['status'] == 'Ready') ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _downloadReport(report),
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareReport(report),
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showProcessingStatus(report),
                    icon: const Icon(Icons.info),
                    label: const Text('View Processing Status'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showGenerateReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate New Report'),
        content: const Text(
          'Select the type of report you would like to generate. '
          'The system will compile the latest data and create a comprehensive report for you.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showReportTypeSelection();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showReportTypeSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Report Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.trending_up, color: Colors.blue[600]),
              title: const Text('Production Report'),
              subtitle: const Text('Analysis of production metrics and trends'),
              onTap: () => _generateReport('Production'),
            ),
            ListTile(
              leading: Icon(Icons.attach_money, color: Colors.green[600]),
              title: const Text('Financial Report'),
              subtitle: const Text('Revenue, costs, and profit analysis'),
              onTap: () => _generateReport('Financial'),
            ),
            ListTile(
              leading: Icon(Icons.verified, color: Colors.orange[600]),
              title: const Text('Quality Report'),
              subtitle: const Text('Quality control and compliance metrics'),
              onTap: () => _generateReport('Quality'),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping, color: Colors.purple[600]),
              title: const Text('Supply Chain Report'),
              subtitle: const Text('Logistics and supply chain analysis'),
              onTap: () => _generateReport('Supply Chain'),
            ),
            ListTile(
              leading: Icon(Icons.eco, color: Colors.green[700]),
              title: const Text('Sustainability Report'),
              subtitle: const Text('Environmental impact and sustainability metrics'),
              onTap: () => _generateReport('Sustainability'),
            ),
          ],
        ),
      ),
    );
  }

  void _generateReport(String type) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating $type report...'),
        action: SnackBarAction(
          label: 'View Progress',
          onPressed: () {
            // Show progress
          },
        ),
      ),
    );
  }

  void _downloadReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${report['title']}...'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            // Open downloaded file
          },
        ),
      ),
    );
  }

  void _shareReport(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share ${report['title']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening email client...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.link_outlined),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload_outlined),
              title: const Text('Upload to Cloud'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Uploading to cloud storage...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProcessingStatus(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Processing Status - ${report['title']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const LinearProgressIndicator(value: 0.7),
            const SizedBox(height: 16),
            const Text(
              'Data collection: Complete ✓\n'
              'Analysis: In Progress...\n'
              'Report generation: Pending',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Estimated completion: 15 minutes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
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

  void _showScheduledReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening scheduled reports settings...')),
    );
  }

  void _showNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening notification settings...')),
    );
  }

  void _showExportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening export settings...')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}