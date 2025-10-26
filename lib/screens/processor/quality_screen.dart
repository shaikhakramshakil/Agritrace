import 'package:flutter/material.dart';

class QualityScreen extends StatefulWidget {
  const QualityScreen({super.key});

  @override
  State<QualityScreen> createState() => _QualityScreenState();
}

class _QualityScreenState extends State<QualityScreen> {
  String _selectedTab = 'Pending';
  
  final List<Map<String, dynamic>> _qualityTests = [
    {
      'id': 'QT001',
      'batchId': 'PR001',
      'productName': 'Wheat Flour',
      'testType': 'Moisture Content',
      'status': 'Pending',
      'priority': 'High',
      'assignedTo': 'Lab Tech A',
      'scheduledTime': '02:00 PM',
      'parameters': {
        'expectedValue': '12-14%',
        'actualValue': '--',
        'tolerance': '±1%',
      },
    },
    {
      'id': 'QT002',
      'batchId': 'PR002',
      'productName': 'Rice Bran Oil',
      'testType': 'Fatty Acid Profile',
      'status': 'In Progress',
      'priority': 'Medium',
      'assignedTo': 'Lab Tech B',
      'scheduledTime': '03:30 PM',
      'parameters': {
        'expectedValue': 'Grade A',
        'actualValue': 'Testing...',
        'tolerance': '±2%',
      },
    },
    {
      'id': 'QT003',
      'batchId': 'PR003',
      'productName': 'Corn Flour',
      'testType': 'Particle Size',
      'status': 'Completed',
      'priority': 'Low',
      'assignedTo': 'Lab Tech A',
      'scheduledTime': '11:00 AM',
      'result': 'Pass',
      'parameters': {
        'expectedValue': '200 mesh',
        'actualValue': '205 mesh',
        'tolerance': '±10 mesh',
      },
    },
    {
      'id': 'QT004',
      'batchId': 'PR005',
      'productName': 'Mustard Oil',
      'testType': 'Purity Test',
      'status': 'Completed',
      'priority': 'High',
      'assignedTo': 'Lab Tech C',
      'scheduledTime': '09:00 AM',
      'result': 'Pass',
      'parameters': {
        'expectedValue': '99% pure',
        'actualValue': '99.5% pure',
        'tolerance': '±0.5%',
      },
    },
    {
      'id': 'QT005',
      'batchId': 'PR001',
      'productName': 'Wheat Flour',
      'testType': 'Protein Content',
      'status': 'Pending',
      'priority': 'Medium',
      'assignedTo': 'Lab Tech B',
      'scheduledTime': '04:00 PM',
      'parameters': {
        'expectedValue': '10-12%',
        'actualValue': '--',
        'tolerance': '±0.5%',
      },
    },
    {
      'id': 'QT006',
      'batchId': 'PR004',
      'productName': 'Soybean Oil',
      'testType': 'Peroxide Value',
      'status': 'Failed',
      'priority': 'High',
      'assignedTo': 'Lab Tech A',
      'scheduledTime': '01:00 PM',
      'result': 'Fail',
      'parameters': {
        'expectedValue': '<10 meq/kg',
        'actualValue': '12 meq/kg',
        'tolerance': '±2 meq/kg',
      },
      'remarks': 'Batch needs reprocessing',
    },
  ];

  List<Map<String, dynamic>> get _filteredTests {
    return _qualityTests.where((test) => test['status'] == _selectedTab).toList();
  }

  Map<String, int> get _statusCounts {
    return {
      'Pending': _qualityTests.where((t) => t['status'] == 'Pending').length,
      'In Progress': _qualityTests.where((t) => t['status'] == 'In Progress').length,
      'Completed': _qualityTests.where((t) => t['status'] == 'Completed').length,
      'Failed': _qualityTests.where((t) => t['status'] == 'Failed').length,
    };
  }

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
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Color(0xFF10B981),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quality Control',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Quality tests and inspections',
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
                const SizedBox(height: 20),
                // Stats row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard('Pending', _statusCounts['Pending']!, Colors.orange),
                      _buildStatCard('In Progress', _statusCounts['In Progress']!, Colors.blue),
                      _buildStatCard('Completed', _statusCounts['Completed']!, Colors.green),
                      _buildStatCard('Failed', _statusCounts['Failed']!, Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTab('Pending'),
                _buildTab('In Progress'),
                _buildTab('Completed'),
                _buildTab('Failed'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quality tests list
          Expanded(
            child: _filteredTests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tests found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: _filteredTests.length,
                    itemBuilder: (context, index) {
                      final test = _filteredTests[index];
                      return _buildTestCard(test);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    final isSelected = _selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? const Color(0xFF10B981) : const Color(0xFF8B8B9A),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(Map<String, dynamic> test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getPriorityColor(test['priority']).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor(test['status']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(test['status']),
                  color: _getStatusColor(test['status']),
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
                          test['id'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(test['priority']).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            test['priority'],
                            style: TextStyle(
                              color: _getPriorityColor(test['priority']),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      test['testType'],
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
          
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF2A2A3E)),
          const SizedBox(height: 12),

          // Details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(Icons.inventory_2, 'Batch', test['batchId']),
              ),
              Expanded(
                child: _buildDetailItem(Icons.shopping_bag, 'Product', test['productName']),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(Icons.person, 'Assigned To', test['assignedTo']),
              ),
              Expanded(
                child: _buildDetailItem(Icons.schedule, 'Time', test['scheduledTime']),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Parameters section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF262640),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Test Parameters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildParameterRow('Expected', test['parameters']['expectedValue']),
                _buildParameterRow('Actual', test['parameters']['actualValue']),
                _buildParameterRow('Tolerance', test['parameters']['tolerance']),
              ],
            ),
          ),

          if (test['result'] != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  test['result'] == 'Pass' ? Icons.check_circle : Icons.cancel,
                  color: test['result'] == 'Pass' ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Result: ${test['result']}',
                  style: TextStyle(
                    color: test['result'] == 'Pass' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],

          if (test['remarks'] != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      test['remarks'],
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showTestDetails(test);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                test['status'] == 'Pending' ? 'Start Test' : 
                test['status'] == 'In Progress' ? 'Continue Test' : 'View Details',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8B8B9A)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF8B8B9A),
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Color(0xFF8B8B9A),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showTestDetails(Map<String, dynamic> test) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test ${test['id']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Full test details and actions would be shown here.',
                      style: const TextStyle(
                        color: Color(0xFF8B8B9A),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'in progress':
        return Icons.autorenew;
      case 'completed':
        return Icons.check_circle;
      case 'failed':
        return Icons.cancel;
      default:
        return Icons.circle;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
