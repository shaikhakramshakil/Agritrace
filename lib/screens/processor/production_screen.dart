import 'package:flutter/material.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  String _selectedFilter = 'All';
  
  final List<Map<String, dynamic>> _productionBatches = [
    {
      'id': 'PR001',
      'productName': 'Wheat Flour',
      'rawMaterial': 'Wheat Grain',
      'quantity': '500 kg',
      'startTime': '08:00 AM',
      'endTime': '02:30 PM',
      'progress': 0.75,
      'status': 'Processing',
      'operator': 'John Doe',
      'quality': 'Grade A',
      'temperature': '45°C',
      'humidity': '35%',
    },
    {
      'id': 'PR002',
      'productName': 'Rice Bran Oil',
      'rawMaterial': 'Rice Bran',
      'quantity': '200 L',
      'startTime': '09:30 AM',
      'endTime': '04:00 PM',
      'progress': 0.90,
      'status': 'Quality Check',
      'operator': 'Jane Smith',
      'quality': 'Grade A+',
      'temperature': '60°C',
      'humidity': '40%',
    },
    {
      'id': 'PR003',
      'productName': 'Corn Flour',
      'rawMaterial': 'Corn Grain',
      'quantity': '300 kg',
      'startTime': '10:00 AM',
      'endTime': '01:45 PM',
      'progress': 0.95,
      'status': 'Packaging',
      'operator': 'Mike Johnson',
      'quality': 'Grade A',
      'temperature': '42°C',
      'humidity': '32%',
    },
    {
      'id': 'PR004',
      'productName': 'Soybean Oil',
      'rawMaterial': 'Soybean',
      'quantity': '400 L',
      'startTime': '07:00 AM',
      'endTime': '05:30 PM',
      'progress': 0.45,
      'status': 'Processing',
      'operator': 'Sarah Lee',
      'quality': 'Grade B+',
      'temperature': '55°C',
      'humidity': '38%',
    },
    {
      'id': 'PR005',
      'productName': 'Mustard Oil',
      'rawMaterial': 'Mustard Seeds',
      'quantity': '150 L',
      'startTime': '11:00 AM',
      'endTime': '03:00 PM',
      'progress': 1.0,
      'status': 'Completed',
      'operator': 'Tom Brown',
      'quality': 'Grade A',
      'temperature': '48°C',
      'humidity': '36%',
    },
  ];

  List<Map<String, dynamic>> get _filteredBatches {
    if (_selectedFilter == 'All') {
      return _productionBatches;
    }
    return _productionBatches.where((batch) => batch['status'] == _selectedFilter).toList();
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
                        color: const Color(0xFF4F46E5).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.production_quantity_limits,
                        color: Color(0xFF4F46E5),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Production',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Monitor active batches',
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
                        // Add new batch
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add new batch coming soon!'),
                            backgroundColor: Color(0xFF4F46E5),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFF4F46E5),
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Processing'),
                      _buildFilterChip('Quality Check'),
                      _buildFilterChip('Packaging'),
                      _buildFilterChip('Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Production batches list
          Expanded(
            child: _filteredBatches.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No batches found',
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
                    itemCount: _filteredBatches.length,
                    itemBuilder: (context, index) {
                      final batch = _filteredBatches[index];
                      return _buildBatchCard(batch);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: const Color(0xFF1C1C2E),
        selectedColor: const Color(0xFF4F46E5),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF8B8B9A),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF2A2A3E),
        ),
      ),
    );
  }

  Widget _buildBatchCard(Map<String, dynamic> batch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor(batch['status']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(batch['status']),
                  color: _getStatusColor(batch['status']),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(batch['status']).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            batch['status'],
                            style: TextStyle(
                              color: _getStatusColor(batch['status']),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      batch['productName'],
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
          const SizedBox(height: 16),

          // Details grid
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(Icons.inventory, 'Quantity', batch['quantity']),
              ),
              Expanded(
                child: _buildDetailItem(Icons.grass, 'Raw Material', batch['rawMaterial']),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(Icons.person, 'Operator', batch['operator']),
              ),
              Expanded(
                child: _buildDetailItem(Icons.star, 'Quality', batch['quality']),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(Icons.thermostat, 'Temperature', batch['temperature']),
              ),
              Expanded(
                child: _buildDetailItem(Icons.water_drop, 'Humidity', batch['humidity']),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(
                      color: Color(0xFF8B8B9A),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(batch['progress'] * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: batch['progress'],
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(batch['status'])),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Time info
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${batch['startTime']} - ${batch['endTime']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  _showBatchDetails(batch);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Color(0xFF4F46E5),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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

  void _showBatchDetails(Map<String, dynamic> batch) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Batch ${batch['id']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      batch['productName'],
                      style: const TextStyle(
                        color: Color(0xFF8B8B9A),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow('Status', batch['status']),
                    _buildDetailRow('Quantity', batch['quantity']),
                    _buildDetailRow('Raw Material', batch['rawMaterial']),
                    _buildDetailRow('Operator', batch['operator']),
                    _buildDetailRow('Quality', batch['quality']),
                    _buildDetailRow('Temperature', batch['temperature']),
                    _buildDetailRow('Humidity', batch['humidity']),
                    _buildDetailRow('Start Time', batch['startTime']),
                    _buildDetailRow('End Time', batch['endTime']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Color(0xFF8B8B9A),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.blue;
      case 'quality check':
        return Colors.orange;
      case 'packaging':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Icons.autorenew;
      case 'quality check':
        return Icons.verified;
      case 'packaging':
        return Icons.inventory_2;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.circle;
    }
  }
}
