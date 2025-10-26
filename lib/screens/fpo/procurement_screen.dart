import 'package:flutter/material.dart';

class ProcurementScreen extends StatefulWidget {
  const ProcurementScreen({super.key});

  @override
  State<ProcurementScreen> createState() => _ProcurementScreenState();
}

class _ProcurementScreenState extends State<ProcurementScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showBatchDetails = false;
  Map<String, dynamic>? _selectedBatch;

  final List<Map<String, dynamic>> _procurementBatches = [
    {
      'id': 'a1b2c3d4e5f6',
      'farmer': 'Rajesh Kumar',
      'quantity': '250 KG',
      'crop': 'Soybean',
      'status': 'Pending',
      'statusColor': Color(0xFF8A2BE2),
      'date': '2023-10-27',
    },
    {
      'id': 'b2c3d4e5f6g7',
      'farmer': 'Anita Singh',
      'quantity': '150 KG',
      'crop': 'Mustard',
      'status': 'Verified',
      'statusColor': Color(0xFF3B82F6),
      'date': '2023-10-26',
    },
    {
      'id': 'c3d4e5f6g7h8',
      'farmer': 'Vikram Patel',
      'quantity': '300 KG',
      'crop': 'Soybean',
      'status': 'Rejected',
      'statusColor': Colors.red,
      'date': '2023-10-25',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111121),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                _buildHeader(),

                // Search Bar
                _buildSearchBar(),

                // Filter Chips
                _buildFilterChips(),

                // Procurement List
                Expanded(
                  child: _buildProcurementList(),
                ),
              ],
            ),

            // Floating Action Button
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: Add new procurement
                },
                backgroundColor: const Color(0xFF1919E6),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),

            // Batch Details Modal
            if (_showBatchDetails && _selectedBatch != null)
              _buildBatchDetailsModal(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.agriculture,
            color: Colors.white,
            size: 30,
          ),
          const Expanded(
            child: Text(
              'Procurement',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.27,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Show notifications
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF292938),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.search,
                color: Color(0xFF9D9DB8),
                size: 24,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search by Farmer or Batch ID...',
                  hintStyle: TextStyle(
                    color: Color(0xFF9D9DB8),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          _buildFilterChip('Crop Type'),
          const SizedBox(width: 12),
          _buildFilterChip('Status'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF292938),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.expand_more,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProcurementList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _procurementBatches.length,
      itemBuilder: (context, index) {
        final batch = _procurementBatches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildProcurementCard(batch),
        );
      },
    );
  }

  Widget _buildProcurementCard(Map<String, dynamic> batch) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedBatch = batch;
          _showBatchDetails = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2D),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF292938),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.qr_code_2,
                color: Color(0xFFC0C0C0),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    batch['farmer'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    batch['quantity'],
                    style: const TextStyle(
                      color: Color(0xFF9D9DB8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    batch['crop'],
                    style: const TextStyle(
                      color: Color(0xFF9D9DB8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedBatch = batch;
                  _showBatchDetails = true;
                });
              },
              child: Text(
                batch['status'],
                style: TextStyle(
                  color: batch['statusColor'],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchDetailsModal() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Text(
                    'Batch Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showBatchDetails = false;
                        _selectedBatch = null;
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF9D9DB8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF292938),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'QR: ${_selectedBatch!['id']}',
                style: const TextStyle(
                  color: Color(0xFF9D9DB8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Details
              _buildDetailRow('Farmer:', _selectedBatch!['farmer']),
              _buildDetailRow('Crop:', _selectedBatch!['crop']),
              _buildDetailRow('Quantity:', _selectedBatch!['quantity']),
              _buildDetailRow('Date:', _selectedBatch!['date']),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showBatchDetails = false;
                          _selectedBatch = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Batch rejected'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showBatchDetails = false;
                          _selectedBatch = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Batch verified and accepted'),
                            backgroundColor: Color(0xFF1919E6),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1919E6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Verify & Accept',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9D9DB8),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
