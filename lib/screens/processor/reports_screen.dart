import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Today';
  
  final Map<String, dynamic> _reportData = {
    'production': {
      'total': '2,450 kg',
      'change': '+12.5%',
      'isPositive': true,
    },
    'efficiency': {
      'total': '94.2%',
      'change': '+2.1%',
      'isPositive': true,
    },
    'quality': {
      'total': '98.7%',
      'change': '+0.8%',
      'isPositive': true,
    },
    'waste': {
      'total': '3.2%',
      'change': '-0.5%',
      'isPositive': true,
    },
  };

  final List<Map<String, dynamic>> _recentReports = [
    {
      'id': 'RPT001',
      'title': 'Daily Production Report',
      'type': 'Production',
      'date': 'Oct 25, 2025',
      'time': '05:00 PM',
      'status': 'Generated',
      'icon': Icons.production_quantity_limits,
      'color': Colors.blue,
    },
    {
      'id': 'RPT002',
      'title': 'Quality Control Summary',
      'type': 'Quality',
      'date': 'Oct 25, 2025',
      'time': '03:30 PM',
      'status': 'Generated',
      'icon': Icons.verified,
      'color': Colors.green,
    },
    {
      'id': 'RPT003',
      'title': 'Waste Analysis Report',
      'type': 'Waste',
      'date': 'Oct 24, 2025',
      'time': '06:00 PM',
      'status': 'Generated',
      'icon': Icons.delete_outline,
      'color': Colors.orange,
    },
    {
      'id': 'RPT004',
      'title': 'Weekly Performance',
      'type': 'Performance',
      'date': 'Oct 21, 2025',
      'time': '08:00 AM',
      'status': 'Generated',
      'icon': Icons.analytics,
      'color': Colors.purple,
    },
    {
      'id': 'RPT005',
      'title': 'Monthly Inventory Report',
      'type': 'Inventory',
      'date': 'Oct 1, 2025',
      'time': '09:00 AM',
      'status': 'Generated',
      'icon': Icons.inventory_2,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.analytics,
                        color: Colors.purple,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reports',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Analytics and insights',
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
                        _showGenerateReportDialog();
                      },
                      icon: const Icon(
                        Icons.add_chart,
                        color: Colors.purple,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Period filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPeriodChip('Today'),
                      _buildPeriodChip('This Week'),
                      _buildPeriodChip('This Month'),
                      _buildPeriodChip('This Year'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Summary cards
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildSummaryCard(
                  'Production',
                  _reportData['production']['total'],
                  _reportData['production']['change'],
                  _reportData['production']['isPositive'],
                  Icons.production_quantity_limits,
                  Colors.blue,
                ),
                _buildSummaryCard(
                  'Efficiency',
                  _reportData['efficiency']['total'],
                  _reportData['efficiency']['change'],
                  _reportData['efficiency']['isPositive'],
                  Icons.speed,
                  Colors.green,
                ),
                _buildSummaryCard(
                  'Quality',
                  _reportData['quality']['total'],
                  _reportData['quality']['change'],
                  _reportData['quality']['isPositive'],
                  Icons.verified,
                  Colors.purple,
                ),
                _buildSummaryCard(
                  'Waste',
                  _reportData['waste']['total'],
                  _reportData['waste']['change'],
                  _reportData['waste']['isPositive'],
                  Icons.delete_outline,
                  Colors.orange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent reports section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Reports',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('View all reports coming soon!'),
                        backgroundColor: Colors.purple,
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Reports list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: _recentReports.length,
              itemBuilder: (context, index) {
                final report = _recentReports[index];
                return _buildReportCard(report);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label) {
    final isSelected = _selectedPeriod == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedPeriod = label;
          });
        },
        backgroundColor: const Color(0xFF1C1C2E),
        selectedColor: Colors.purple,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF8B8B9A),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.purple : const Color(0xFF2A2A3E),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String change,
    bool isPositive,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
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
            title,
            style: const TextStyle(
              color: Color(0xFF8B8B9A),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Container(
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: report['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              report['icon'],
              color: report['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: report['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        report['type'],
                        style: TextStyle(
                          color: report['color'],
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${report['date']} • ${report['time']}',
                      style: const TextStyle(
                        color: Color(0xFF8B8B9A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _showReportOptions(report);
            },
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF8B8B9A),
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
        backgroundColor: const Color(0xFF1C1C2E),
        title: const Text(
          'Generate Report',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.production_quantity_limits, color: Colors.blue),
              title: const Text('Production Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _generateReport('Production');
              },
            ),
            ListTile(
              leading: const Icon(Icons.verified, color: Colors.green),
              title: const Text('Quality Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _generateReport('Quality');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: Colors.purple),
              title: const Text('Performance Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _generateReport('Performance');
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2, color: Colors.teal),
              title: const Text('Inventory Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _generateReport('Inventory');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _generateReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating $type report...'),
        backgroundColor: Colors.purple,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showReportOptions(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.white),
              title: const Text('View Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening report...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.white),
              title: const Text('Download PDF', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading report...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text('Share Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing report...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.print, color: Colors.white),
              title: const Text('Print Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Printing report...')),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
