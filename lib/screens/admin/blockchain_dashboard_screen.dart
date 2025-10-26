import 'package:flutter/material.dart';
import 'dart:math';

class BlockchainDashboardScreen extends StatefulWidget {
  const BlockchainDashboardScreen({super.key});

  @override
  State<BlockchainDashboardScreen> createState() => _BlockchainDashboardScreenState();
}

class _BlockchainDashboardScreenState extends State<BlockchainDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  
  // Mock blockchain data
  final List<Map<String, dynamic>> _blocks = [];
  final List<Map<String, dynamic>> _transactions = [];
  final List<Map<String, dynamic>> _inventoryRecords = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to show/hide FAB based on tab
    });
    _generateMockBlockchain();
    _generateMockTransactions();
    _generateMockInventory();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  void _generateMockBlockchain() {
    final random = Random();
    final now = DateTime.now();
    
    for (int i = 0; i < 15; i++) {
      _blocks.add({
        'blockNumber': i,
        'hash': _generateHash(),
        'previousHash': i > 0 ? _blocks[i - 1]['hash'] : '0000000000000000',
        'timestamp': now.subtract(Duration(hours: i * 2)),
        'transactionCount': random.nextInt(10) + 5,
        'miner': 'Node-${random.nextInt(5) + 1}',
        'difficulty': random.nextInt(5) + 3,
        'size': random.nextInt(500) + 100,
        'gasUsed': random.nextInt(50000) + 20000,
        'status': 'Confirmed',
      });
    }
  }
  
  void _generateMockTransactions() {
    final random = Random();
    final now = DateTime.now();
    final types = ['Transfer', 'Quality Check', 'Storage Update', 'Delivery', 'Payment'];
    final statuses = ['Confirmed', 'Pending', 'Failed'];
    final items = ['Rice', 'Wheat', 'Corn', 'Soybeans', 'Cotton'];
    
    for (int i = 0; i < 50; i++) {
      final status = i < 45 ? 'Confirmed' : statuses[random.nextInt(statuses.length)];
      _transactions.add({
        'txHash': _generateHash(),
        'blockNumber': random.nextInt(15),
        'timestamp': now.subtract(Duration(minutes: i * 15)),
        'from': 'Farmer-${random.nextInt(100) + 1}',
        'to': 'FPO-${random.nextInt(20) + 1}',
        'type': types[random.nextInt(types.length)],
        'item': items[random.nextInt(items.length)],
        'quantity': random.nextInt(1000) + 100,
        'value': (random.nextDouble() * 10000 + 1000).toStringAsFixed(2),
        'gasPrice': random.nextInt(100) + 20,
        'status': status,
        'confirmations': status == 'Confirmed' ? random.nextInt(50) + 10 : 0,
      });
    }
  }
  
  void _generateMockInventory() {
    final random = Random();
    final now = DateTime.now();
    final items = ['Rice', 'Wheat', 'Corn', 'Soybeans', 'Cotton', 'Pulses', 'Vegetables'];
    final locations = ['Warehouse-A', 'Warehouse-B', 'Warehouse-C', 'Storage-1', 'Storage-2'];
    
    for (int i = 0; i < 30; i++) {
      _inventoryRecords.add({
        'recordHash': _generateHash(),
        'blockNumber': random.nextInt(15),
        'timestamp': now.subtract(Duration(hours: i * 3)),
        'item': items[random.nextInt(items.length)],
        'quantity': random.nextInt(5000) + 500,
        'location': locations[random.nextInt(locations.length)],
        'quality': random.nextInt(10) + 90,
        'temperature': random.nextInt(10) + 15,
        'humidity': random.nextInt(30) + 40,
        'action': random.nextBool() ? 'Added' : 'Updated',
        'operator': 'User-${random.nextInt(20) + 1}',
        'verified': true,
      });
    }
  }
  
  String _generateHash() {
    final random = Random();
    const chars = '0123456789abcdef';
    return '0x${List.generate(64, (index) => chars[random.nextInt(chars.length)]).join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Blockchain Dashboard', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Distributed Ledger Management', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _blocks.clear();
                _transactions.clear();
                _inventoryRecords.clear();
                _generateMockBlockchain();
                _generateMockTransactions();
                _generateMockInventory();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Blockchain data exported successfully')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.view_module), text: 'Blocks'),
            Tab(icon: Icon(Icons.swap_horiz), text: 'Transactions'),
            Tab(icon: Icon(Icons.inventory_2), text: 'Inventory'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildStatsOverview(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBlocksView(),
                _buildTransactionsView(),
                _buildInventoryView(),
                _buildAnalyticsView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: _showCreateTransactionDialog,
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.add),
              label: const Text('New Transaction'),
            )
          : null,
    );
  }
  
  void _showCreateTransactionDialog() {
    final fromController = TextEditingController();
    final toController = TextEditingController();
    final valueController = TextEditingController();
    final quantityController = TextEditingController();
    String selectedProduct = 'Wheat';
    String selectedType = 'Transfer';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text(
            'Create New Transaction',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction Type',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  dropdownColor: const Color(0xFF1F2937),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['Transfer', 'Sale', 'Purchase', 'Storage']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedType = value!);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'From',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: fromController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., Farmer-001',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'To',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: toController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., FPO-001',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Product',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedProduct,
                  dropdownColor: const Color(0xFF1F2937),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['Wheat', 'Rice', 'Corn', 'Soybeans', 'Cotton', 'Pulses', 'Vegetables']
                      .map((prod) => DropdownMenuItem(value: prod, child: Text(prod)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedProduct = value!);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quantity (kg)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., 500',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Value (INR)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., 25000',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                fromController.dispose();
                toController.dispose();
                valueController.dispose();
                quantityController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (fromController.text.isEmpty || 
                    toController.text.isEmpty || 
                    valueController.text.isEmpty || 
                    quantityController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                
                _createTransaction(
                  from: fromController.text,
                  to: toController.text,
                  product: selectedProduct,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  value: double.tryParse(valueController.text) ?? 0.0,
                  type: selectedType,
                );
                
                fromController.dispose();
                toController.dispose();
                valueController.dispose();
                quantityController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Create Transaction'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _createTransaction({
    required String from,
    required String to,
    required String product,
    required int quantity,
    required double value,
    required String type,
  }) {
    final random = Random();
    final newTransaction = {
      'txHash': _generateHash(),
      'from': from,
      'to': to,
      'item': product,
      'quantity': quantity,
      'value': value.toStringAsFixed(2),
      'timestamp': DateTime.now(),
      'blockNumber': _blocks.isNotEmpty ? _blocks.first['blockNumber'] + 1 : 0,
      'status': 'Confirmed',
      'type': type,
      'gasPrice': random.nextInt(50) + 10,
      'confirmations': 12,
    };
    
    setState(() {
      _transactions.insert(0, newTransaction);
      
      // Create a new block for this transaction
      _blocks.insert(0, {
        'blockNumber': newTransaction['blockNumber'],
        'hash': _generateHash(),
        'previousHash': _blocks.isNotEmpty ? _blocks.first['hash'] : '0000000000000000',
        'timestamp': DateTime.now(),
        'transactionCount': 1,
        'miner': 'Node-${random.nextInt(5) + 1}',
        'difficulty': random.nextInt(5) + 3,
        'size': random.nextInt(500) + 100,
        'gasUsed': random.nextInt(50000) + 20000,
      });
      
      // Update block numbers for existing blocks
      for (int i = 1; i < _blocks.length; i++) {
        _blocks[i]['blockNumber'] = _blocks[i]['blockNumber'] as int;
      }
    });
    
    // Show success animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Transaction Created Successfully!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Block #${newTransaction['blockNumber']} • $product: $quantity kg',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  Widget _buildStatsOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Blocks',
                _blocks.length.toString(),
                Icons.view_module,
                Colors.blue,
                showDot: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Transactions',
                _transactions.length.toString(),
                Icons.swap_horiz,
                Colors.green,
                showDot: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Inventory Records',
                _inventoryRecords.length.toString(),
                Icons.inventory_2,
                Colors.orange,
                showDot: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Network Status',
                'Active',
                Icons.circle,
                Colors.green,
                showDot: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color, {bool showDot = false}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              if (showDot)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBlocksView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _blocks.length,
      itemBuilder: (context, index) {
        final block = _blocks[index];
        return _buildBlockCard(block);
      },
    );
  }
  
  Widget _buildBlockCard(Map<String, dynamic> block) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.view_module, color: Colors.blue),
        ),
        title: Text(
          'Block #${block['blockNumber']}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${block['transactionCount']} transactions • ${_formatDate(block['timestamp'])}',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Confirmed',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBlockDetail('Hash', block['hash']),
                const SizedBox(height: 8),
                _buildBlockDetail('Previous Hash', block['previousHash']),
                const SizedBox(height: 8),
                _buildBlockDetail('Miner', block['miner']),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildBlockDetail('Difficulty', block['difficulty'].toString())),
                    Expanded(child: _buildBlockDetail('Size', '${block['size']} KB')),
                  ],
                ),
                const SizedBox(height: 8),
                _buildBlockDetail('Gas Used', '${block['gasUsed']} units'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBlockDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.length > 50 ? '${value.substring(0, 50)}...' : value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
  
  Widget _buildTransactionsView() {
    return Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final tx = _transactions[index];
              return _buildTransactionCard(tx);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search transactions by hash, address...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          DropdownButton<String>(
            value: _selectedFilter,
            dropdownColor: const Color(0xFF1F2937),
            style: const TextStyle(color: Colors.white),
            items: ['All', 'Confirmed', 'Pending', 'Failed']
                .map((filter) => DropdownMenuItem(value: filter, child: Text(filter)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedFilter = value!;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransactionCard(Map<String, dynamic> tx) {
    final statusColor = tx['status'] == 'Confirmed' 
        ? Colors.green 
        : tx['status'] == 'Pending' 
            ? Colors.orange 
            : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.swap_horiz, color: statusColor),
        ),
        title: Text(
          tx['type'] ?? 'Transaction',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Block #${tx['blockNumber']} • ${_formatDate(tx['timestamp'])}',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tx['status'] ?? 'Unknown',
                style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${tx['value'] ?? '0'}',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTxDetail('Transaction Hash', tx['txHash']),
                const Divider(color: Colors.white24),
                Row(
                  children: [
                    Expanded(child: _buildTxDetail('From', tx['from'])),
                    const Icon(Icons.arrow_forward, color: Colors.white54, size: 20),
                    Expanded(child: _buildTxDetail('To', tx['to'])),
                  ],
                ),
                const Divider(color: Colors.white24),
                Row(
                  children: [
                    Expanded(child: _buildTxDetail('Item', tx['item'])),
                    Expanded(child: _buildTxDetail('Quantity', '${tx['quantity']} kg')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildTxDetail('Gas Price', '${tx['gasPrice']} Gwei')),
                    Expanded(child: _buildTxDetail('Confirmations', tx['confirmations'].toString())),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTxDetail(String label, String? value) {
    final displayValue = value ?? 'N/A';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          displayValue.length > 30 ? '${displayValue.substring(0, 30)}...' : displayValue,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
  
  Widget _buildInventoryView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _inventoryRecords.length,
      itemBuilder: (context, index) {
        final record = _inventoryRecords[index];
        return _buildInventoryCard(record);
      },
    );
  }
  
  Widget _buildInventoryCard(Map<String, dynamic> record) {
    final actionColor = record['action'] == 'Added' ? Colors.green : Colors.blue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.inventory_2, color: actionColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          record['item'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: actionColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            record['action'],
                            style: TextStyle(color: actionColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${record['location']} • ${_formatDate(record['timestamp'])}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (record['verified'])
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified, color: Colors.green, size: 16),
                ),
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInventoryMetric(
                  'Quantity',
                  '${record['quantity']} kg',
                  Icons.scale,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildInventoryMetric(
                  'Quality',
                  '${record['quality']}%',
                  Icons.star,
                  Colors.amber,
                ),
              ),
              Expanded(
                child: _buildInventoryMetric(
                  'Temp',
                  '${record['temperature']}°C',
                  Icons.thermostat,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildInventoryMetric(
                  'Humidity',
                  '${record['humidity']}%',
                  Icons.water_drop,
                  Colors.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.link, color: Colors.white.withValues(alpha: 0.6), size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Block #${record['blockNumber']} • ${record['recordHash'].substring(0, 20)}...',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInventoryMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNetworkHealthCard(),
          const SizedBox(height: 16),
          _buildChainVisualization(),
          const SizedBox(height: 16),
          _buildTransactionFlowChart(),
          const SizedBox(height: 16),
          _buildInventoryDistribution(),
        ],
      ),
    );
  }
  
  Widget _buildNetworkHealthCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.health_and_safety, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Network Health',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Healthy',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHealthMetric('Block Time', '2.3s', Colors.green),
              ),
              Expanded(
                child: _buildHealthMetric('TPS', '127', Colors.blue),
              ),
              Expanded(
                child: _buildHealthMetric('Nodes', '12', Colors.purple),
              ),
              Expanded(
                child: _buildHealthMetric('Uptime', '99.9%', Colors.amber),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildHealthMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildChainVisualization() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Blockchain Visualization',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: min(_blocks.length, 8),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    _buildBlockNode(index),
                    if (index < min(_blocks.length, 8) - 1)
                      const Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBlockNode(int index) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.view_module, color: Colors.blue, size: 24),
          const SizedBox(height: 8),
          Text(
            'Block\n#$index',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_blocks[index]['transactionCount']} Tx',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransactionFlowChart() {
    final txByType = <String, int>{};
    for (var tx in _transactions) {
      txByType[tx['type']] = (txByType[tx['type']] ?? 0) + 1;
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction Distribution',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...txByType.entries.map((entry) {
            final percentage = (entry.value / _transactions.length * 100);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorForType(entry.key),
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildInventoryDistribution() {
    final itemCount = <String, int>{};
    for (var record in _inventoryRecords) {
      itemCount[record['item']] = (itemCount[record['item']] ?? 0) + 1;
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Distribution',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: itemCount.entries.map((entry) {
              return SizedBox(
                width: 80,
                height: 80,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Color _getColorForType(String type) {
    switch (type) {
      case 'Transfer':
        return Colors.blue;
      case 'Quality Check':
        return Colors.green;
      case 'Storage Update':
        return Colors.orange;
      case 'Delivery':
        return Colors.purple;
      case 'Payment':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
