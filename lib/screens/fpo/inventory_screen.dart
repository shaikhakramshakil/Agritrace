import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';
  String _selectedLocation = 'All';
  String _selectedQuality = 'All';
  String _sortBy = 'name';
  bool _sortAscending = true;
  int _currentNavIndex = 2; // Inventory is at index 2
  
  // Add new inventory categories for better organization
  final List<String> _categories = ['All', 'Grains', 'Fruits', 'Vegetables', 'Fiber', 'Oils', 'Spices'];
  final List<String> _statuses = ['All', 'In Stock', 'Low Stock', 'Out of Stock', 'Expired'];
  final List<String> _locations = ['All', 'Warehouse A', 'Warehouse B', 'Warehouse C', 'Cold Storage', 'Processing Unit'];

  // Enhanced mock inventory data with more variety
  List<Map<String, dynamic>> _allInventory = [
    {
      'id': 'INV001',
      'name': 'Premium Wheat',
      'category': 'Grains',
      'quantity': 1500,
      'unit': 'kg',
      'status': 'In Stock',
      'location': 'Warehouse A',
      'batch': 'WH2024001',
      'expiryDate': '2024-12-15',
      'price': 25.50,
      'supplier': 'Green Valley Farm',
      'lastUpdated': '2 hours ago',
      'quality': 'Grade A',
      'certifications': ['Organic', 'Non-GMO'],
      'minStock': 500,
      'maxStock': 3000,
      'costPrice': 22.00,
      'alertLevel': 600,
    },
    {
      'id': 'INV002',
      'name': 'Basmati Rice',
      'category': 'Grains',
      'quantity': 2200,
      'unit': 'kg',
      'status': 'In Stock',
      'location': 'Warehouse B',
      'batch': 'BR2024001',
      'expiryDate': '2025-03-20',
      'price': 45.00,
      'supplier': 'Riverside Farm',
      'lastUpdated': '4 hours ago',
      'quality': 'Premium',
      'certifications': ['Organic', 'Fair Trade'],
      'minStock': 800,
      'maxStock': 4000,
      'costPrice': 38.50,
      'alertLevel': 1000,
    },
    {
      'id': 'INV003',
      'name': 'Fresh Apples',
      'category': 'Fruits',
      'quantity': 500,
      'unit': 'kg',
      'status': 'Low Stock',
      'location': 'Cold Storage',
      'batch': 'AP2024001',
      'expiryDate': '2024-11-15',
      'price': 120.00,
      'supplier': 'Sunrise Orchards',
      'lastUpdated': '1 hour ago',
      'quality': 'Grade A',
      'certifications': ['Organic'],
      'minStock': 200,
      'maxStock': 1000,
      'costPrice': 95.00,
      'alertLevel': 300,
    },
    {
      'id': 'INV004',
      'name': 'Cotton Bales',
      'category': 'Fiber',
      'quantity': 100,
      'unit': 'bales',
      'status': 'In Stock',
      'location': 'Warehouse C',
      'batch': 'CT2024001',
      'expiryDate': 'N/A',
      'price': 5500.00,
      'supplier': 'Golden Fields',
      'lastUpdated': '6 hours ago',
      'quality': 'Premium',
      'certifications': ['Fair Trade'],
      'minStock': 50,
      'maxStock': 200,
      'costPrice': 5200.00,
      'alertLevel': 75,
    },
    {
      'id': 'INV005',
      'name': 'Organic Tomatoes',
      'category': 'Vegetables',
      'quantity': 0,
      'unit': 'kg',
      'status': 'Out of Stock',
      'location': 'Cold Storage',
      'batch': 'TM2024001',
      'expiryDate': '2024-11-05',
      'price': 80.00,
      'supplier': 'Valley Gardens',
      'lastUpdated': '12 hours ago',
      'quality': 'Grade B',
      'certifications': ['Organic'],
      'minStock': 100,
      'maxStock': 800,
      'costPrice': 65.00,
      'alertLevel': 150,
    },
    {
      'id': 'INV006',
      'name': 'Sunflower Oil',
      'category': 'Oils',
      'quantity': 350,
      'unit': 'liters',
      'status': 'In Stock',
      'location': 'Processing Unit',
      'batch': 'SO2024001',
      'expiryDate': '2025-06-30',
      'price': 180.00,
      'supplier': 'Oil Mill Cooperative',
      'lastUpdated': '3 hours ago',
      'quality': 'Premium',
      'certifications': ['Cold Pressed', 'Organic'],
      'minStock': 200,
      'maxStock': 1000,
      'costPrice': 155.00,
      'alertLevel': 250,
    },
    {
      'id': 'INV007',
      'name': 'Black Pepper',
      'category': 'Spices',
      'quantity': 25,
      'unit': 'kg',
      'status': 'Low Stock',
      'location': 'Warehouse A',
      'batch': 'BP2024001',
      'expiryDate': '2025-12-31',
      'price': 850.00,
      'supplier': 'Spice Valley',
      'lastUpdated': '5 hours ago',
      'quality': 'Grade A',
      'certifications': ['Organic', 'Fair Trade'],
      'minStock': 50,
      'maxStock': 200,
      'costPrice': 780.00,
      'alertLevel': 40,
    },
    {
      'id': 'INV008',
      'name': 'Soybeans',
      'category': 'Grains',
      'quantity': 1800,
      'unit': 'kg',
      'status': 'In Stock',
      'location': 'Warehouse B',
      'batch': 'SB2024001',
      'expiryDate': '2025-01-20',
      'price': 55.00,
      'supplier': 'Modern Farms',
      'lastUpdated': '7 hours ago',
      'quality': 'Premium',
      'certifications': ['Non-GMO'],
      'minStock': 500,
      'maxStock': 3500,
      'costPrice': 48.00,
      'alertLevel': 700,
    },
    {
      'id': 'INV009',
      'name': 'Canola Oil',
      'category': 'Oils',
      'quantity': 15,
      'unit': 'liters',
      'status': 'Low Stock',
      'location': 'Processing Unit',
      'batch': 'CO2024001',
      'expiryDate': '2025-04-15',
      'price': 165.00,
      'supplier': 'Pure Oil Mills',
      'lastUpdated': '2 hours ago',
      'quality': 'Grade A',
      'certifications': ['Cold Pressed'],
      'minStock': 100,
      'maxStock': 500,
      'costPrice': 142.00,
      'alertLevel': 80,
    },
    {
      'id': 'INV010',
      'name': 'Fresh Carrots',
      'category': 'Vegetables',
      'quantity': 320,
      'unit': 'kg',
      'status': 'In Stock',
      'location': 'Cold Storage',
      'batch': 'CR2024001',
      'expiryDate': '2024-11-25',
      'price': 45.00,
      'supplier': 'Fresh Harvest',
      'lastUpdated': '30 minutes ago',
      'quality': 'Grade A',
      'certifications': ['Organic'],
      'minStock': 150,
      'maxStock': 600,
      'costPrice': 35.00,
      'alertLevel': 200,
    },
  ];

  List<Map<String, dynamic>> get _filteredInventory {
    List<Map<String, dynamic>> filtered = List.from(_allInventory);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered
          .where((item) =>
              item['name'].toLowerCase().contains(searchTerm) ||
              item['batch'].toLowerCase().contains(searchTerm) ||
              item['supplier'].toLowerCase().contains(searchTerm) ||
              item['id'].toLowerCase().contains(searchTerm) ||
              item['category'].toLowerCase().contains(searchTerm))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((item) => item['category'] == _selectedCategory)
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != 'All') {
      filtered = filtered
          .where((item) => item['status'] == _selectedStatus)
          .toList();
    }

    // Apply location filter
    if (_selectedLocation != 'All') {
      filtered = filtered
          .where((item) => item['location'] == _selectedLocation)
          .toList();
    }

    // Apply quality filter
    if (_selectedQuality != 'All') {
      filtered = filtered
          .where((item) => item['quality'] == _selectedQuality)
          .toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      dynamic aValue = a[_sortBy];
      dynamic bValue = b[_sortBy];
      
      if (aValue is String && bValue is String) {
        return _sortAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      } else if (aValue is num && bValue is num) {
        return _sortAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      }
      return 0;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Inventory Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[600],
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
                      '5',
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
            onPressed: () => _showInventoryStats(),
            icon: const Icon(Icons.analytics_outlined),
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
                Expanded(child: _buildSummaryCard('Total Items', '${_allInventory.length}', Icons.inventory_2, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Low Stock', '${_allInventory.where((item) => item['status'] == 'Low Stock').length}', Icons.warning, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('Out of Stock', '${_allInventory.where((item) => item['status'] == 'Out of Stock').length}', Icons.remove_circle, Colors.red)),
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
                    hintText: 'Search items, batches, or suppliers...',
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
                          children: _categories.map((category) => 
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildCategoryChip(category),
                            )
                          ).toList(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _showSortOptions,
                          icon: const Icon(Icons.sort),
                          tooltip: 'Sort Options',
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
              ],
            ),
          ),
          // Inventory List
          Expanded(
            child: _filteredInventory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items found',
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
                    itemCount: _filteredInventory.length,
                    itemBuilder: (context, index) {
                      final item = _filteredInventory[index];
                      return _buildInventoryCard(item);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showBulkOperations,
            backgroundColor: Colors.orange[600],
            heroTag: "bulk",
            child: const Icon(Icons.checklist),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: _showAddItemDialog,
            backgroundColor: Colors.blue[600],
            heroTag: "add",
            child: const Icon(Icons.add),
          ),
        ],
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.blue[200]!,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    Color statusColor;
    IconData statusIcon;
    
    switch (item['status']) {
      case 'In Stock':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Low Stock':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case 'Out of Stock':
        statusColor = Colors.red;
        statusIcon = Icons.remove_circle;
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
        onTap: () => _showItemDetails(item),
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
                          item['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Batch: ${item['batch']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
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
                          item['status'],
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
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.inventory_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${item['quantity']} ${item['unit']}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          item['location'],
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.category_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          item['category'],
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${item['price'].toStringAsFixed(2)}/${item['unit']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Updated ${item['lastUpdated']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _editQuantity(item),
                        icon: Icon(Icons.edit_outlined, size: 20, color: Colors.blue[600]),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _generateBarcode(item),
                        icon: Icon(Icons.qr_code, size: 20, color: Colors.grey[600]),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
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
              color: isSelected ? Colors.blue[600] : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue[600] : Colors.grey[600],
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
      case 2: // Inventory (current screen)
        // Already on inventory screen
        break;
      case 3: // Reports
        Navigator.pushReplacementNamed(context, '/reports');
        break;
      case 4: // Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  // Helper methods
  void _showBulkOperations() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.checklist, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Bulk Operations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.file_upload, color: Colors.blue),
              title: const Text('Import Items'),
              subtitle: const Text('Import multiple items from CSV/Excel'),
              onTap: () {
                Navigator.pop(context);
                _showImportDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download, color: Colors.green),
              title: const Text('Export Inventory'),
              subtitle: const Text('Export current inventory data'),
              onTap: () {
                Navigator.pop(context);
                _exportInventory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.orange),
              title: const Text('Bulk Update'),
              subtitle: const Text('Update multiple items at once'),
              onTap: () {
                Navigator.pop(context);
                _showBulkUpdateDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.red),
              title: const Text('Bulk Delete'),
              subtitle: const Text('Remove multiple items'),
              onTap: () {
                Navigator.pop(context);
                _showBulkDeleteDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_upload, color: Colors.blue),
            SizedBox(width: 8),
            Text('Import Items'),
          ],
        ),
        content: const Text(
          'Choose how you want to import items:\n\n'
          '• CSV/Excel file upload\n'
          '• Manual batch entry\n'
          '• Scan QR codes in bulk',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File picker would open here for CSV import'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Choose File'),
          ),
        ],
      ),
    );
  }

  void _exportInventory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_download, color: Colors.green),
            SizedBox(width: 8),
            Text('Export Inventory'),
          ],
        ),
        content: const Text(
          'Export format:\n\n'
          '• Excel (.xlsx)\n'
          '• CSV (.csv)\n'
          '• PDF Report\n\n'
          'This will include all current inventory items with their details.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Exported ${_allInventory.length} items successfully!'),
                  backgroundColor: Colors.green,
                  action: SnackBarAction(
                    label: 'VIEW',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showBulkUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Update'),
        content: const Text(
          'Select multiple items to update:\n\n'
          '• Prices\n'
          '• Locations\n'
          '• Status\n'
          '• Categories\n\n'
          'This feature allows you to modify multiple items simultaneously.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bulk update mode activated - select items to update'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showBulkDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Bulk Delete'),
          ],
        ),
        content: const Text(
          'Warning: This action cannot be undone.\n\n'
          'You can delete items by:\n'
          '• Selecting multiple items\n'
          '• Filtering by category/status\n'
          '• Expired items only\n'
          '• Out of stock items only',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bulk delete mode activated - select items to remove'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    // Generate dynamic notifications based on current inventory
    List<Map<String, dynamic>> notifications = [];
    
    // Low stock notifications
    for (var item in _allInventory.where((item) => item['status'] == 'Low Stock')) {
      notifications.add({
        'icon': Icons.warning_amber_outlined,
        'color': Colors.orange,
        'title': 'Low Stock Alert',
        'subtitle': '${item['name']} running low (${item['quantity']} ${item['unit']} remaining)',
        'time': item['lastUpdated'],
        'action': () => _editQuantity(item),
      });
    }
    
    // Out of stock notifications
    for (var item in _allInventory.where((item) => item['status'] == 'Out of Stock')) {
      notifications.add({
        'icon': Icons.remove_circle_outline,
        'color': Colors.red,
        'title': 'Out of Stock',
        'subtitle': '${item['name']} - Immediate restocking needed',
        'time': item['lastUpdated'],
        'action': () => _editQuantity(item),
      });
    }
    
    // Add some general notifications
    notifications.addAll([
      {
        'icon': Icons.local_shipping_outlined,
        'color': Colors.blue,
        'title': 'New Delivery',
        'subtitle': 'Basmati Rice shipment received (2200kg)',
        'time': '4h ago',
        'action': () {},
      },
      {
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
        'title': 'Quality Check',
        'subtitle': 'Premium Wheat passed quality inspection',
        'time': '6h ago',
        'action': () {},
      },
      {
        'icon': Icons.trending_up,
        'color': Colors.purple,
        'title': 'Price Update',
        'subtitle': 'Sunflower Oil prices increased by 5%',
        'time': '8h ago',
        'action': () {},
      },
    ]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Inventory Alerts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${notifications.length} alerts',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          notification['icon'],
                          color: notification['color'],
                        ),
                        title: Text(
                          notification['title'],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(notification['subtitle']),
                        trailing: Text(
                          notification['time'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        onTap: notification['action'],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All notifications marked as read')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Mark All as Read'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInventoryStats() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              const Text(
                'Inventory Analytics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Total Value', '₹2,47,500', Icons.monetization_on, Colors.green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Avg. Quality', 'Grade A', Icons.star, Colors.amber),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Turnover Rate', '85%', Icons.refresh, Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Waste %', '2.3%', Icons.delete_outline, Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Category Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildCategoryBreakdown(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
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
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final categoryStats = <String, Map<String, dynamic>>{};
    final colors = [Colors.amber, Colors.red, Colors.green, Colors.brown, Colors.purple, Colors.orange];
    
    // Calculate stats for each category
    for (var item in _allInventory) {
      final category = item['category'] as String;
      if (!categoryStats.containsKey(category)) {
        categoryStats[category] = {
          'count': 0,
          'totalValue': 0.0,
          'totalQuantity': 0,
        };
      }
      categoryStats[category]!['count']++;
      categoryStats[category]!['totalValue'] += (item['price'] as double) * (item['quantity'] as int);
      categoryStats[category]!['totalQuantity'] += item['quantity'] as int;
    }
    
    return Column(
      children: categoryStats.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final categoryEntry = entry.value;
        final category = categoryEntry.key;
        final stats = categoryEntry.value;
        final count = stats['count'] as int;
        final totalValue = stats['totalValue'] as double;
        final percentage = (count / _allInventory.length * 100).toInt();
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                  Text(
                    '$count items ($percentage%)',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total Value: ₹${totalValue.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    'Qty: ${stats['totalQuantity']} units',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sort, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Sort Options',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...['name', 'quantity', 'price', 'category', 'status', 'lastUpdated'].map((field) =>
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: field,
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                  },
                ),
                title: Text(_getSortFieldLabel(field)),
                onTap: () {
                  setState(() {
                    _sortBy = field;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Order:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('Ascending'),
                  selected: _sortAscending,
                  onSelected: (selected) {
                    setState(() {
                      _sortAscending = true;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Descending'),
                  selected: !_sortAscending,
                  onSelected: (selected) {
                    setState(() {
                      _sortAscending = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply Sort'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSortFieldLabel(String field) {
    switch (field) {
      case 'name': return 'Name';
      case 'quantity': return 'Quantity';
      case 'price': return 'Price';
      case 'category': return 'Category';
      case 'status': return 'Status';
      case 'lastUpdated': return 'Last Updated';
      default: return field;
    }
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Advanced Filters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              const Text('Status:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _statuses.map((status) => _buildStatusChip(status)).toList(),
              ),
              
              const SizedBox(height: 20),
              const Text('Location:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _locations.map((location) => _buildLocationChip(location)).toList(),
              ),
              
              const SizedBox(height: 20),
              const Text('Quality Grade:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: ['All', 'Premium', 'Grade A', 'Grade B'].map((quality) => 
                  _buildQualityChip(quality)
                ).toList(),
              ),
              
              const SizedBox(height: 20),
              const Text('Stock Level:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Show Low Stock Only'),
                      value: false,
                      onChanged: (value) {
                        // Implementation for low stock filter
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Apply Filters'),
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

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = 'All';
      _selectedStatus = 'All';
      _selectedLocation = 'All';
      _searchController.clear();
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All filters cleared')),
    );
  }

  Widget _buildStatusChip(String status) {
    final isSelected = _selectedStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.orange[600]! : Colors.orange[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.orange[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationChip(String location) {
    final isSelected = _selectedLocation == location;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLocation = location;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green[600]! : Colors.green[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          location,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.green[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildQualityChip(String quality) {
    final isSelected = _selectedQuality == quality;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedQuality = _selectedQuality == quality ? 'All' : quality;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.purple[600]! : Colors.purple[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          quality,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.purple[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _showItemDetails(Map<String, dynamic> item) {
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
                  Text(
                    item['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Item ID', item['id']),
              _buildDetailRow('Category', item['category']),
              _buildDetailRow('Quantity', '${item['quantity']} ${item['unit']}'),
              _buildDetailRow('Status', item['status']),
              _buildDetailRow('Location', item['location']),
              _buildDetailRow('Batch Number', item['batch']),
              _buildDetailRow('Expiry Date', item['expiryDate']),
              _buildDetailRow('Price', '₹${item['price'].toStringAsFixed(2)}/${item['unit']}'),
              _buildDetailRow('Supplier', item['supplier']),
              _buildDetailRow('Quality Grade', item['quality']),
              const SizedBox(height: 16),
              const Text(
                'Certifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: (item['certifications'] as List<String>)
                    .map((cert) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue[400]!, width: 1.5),
                          ),
                          child: Text(
                            cert,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _editQuantity(item),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Quantity'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _generateBarcode(item),
                      icon: const Icon(Icons.qr_code),
                      label: const Text('Generate QR'),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    final batchController = TextEditingController();
    final supplierController = TextEditingController();
    String selectedCategory = 'Grains';
    String selectedLocation = 'Warehouse A';
    String selectedQuality = 'Grade A';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_box, color: Colors.blue),
              SizedBox(width: 8),
              Text('Add New Item'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: _categories.skip(1).map((category) => 
                            DropdownMenuItem(value: category, child: Text(category))
                          ).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity *',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price per unit',
                            border: OutlineInputBorder(),
                            prefixText: '₹ ',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedLocation,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                          items: _locations.skip(1).map((location) => 
                            DropdownMenuItem(value: location, child: Text(location))
                          ).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedLocation = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: batchController,
                    decoration: const InputDecoration(
                      labelText: 'Batch Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.qr_code),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: supplierController,
                    decoration: const InputDecoration(
                      labelText: 'Supplier',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedQuality,
                    decoration: const InputDecoration(
                      labelText: 'Quality Grade',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Premium', 'Grade A', 'Grade B', 'Grade C'].map((quality) => 
                      DropdownMenuItem(value: quality, child: Text(quality))
                    ).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedQuality = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                  _addNewItem(
                    nameController.text,
                    selectedCategory,
                    int.tryParse(quantityController.text) ?? 0,
                    double.tryParse(priceController.text) ?? 0.0,
                    selectedLocation,
                    batchController.text.isEmpty ? 'AUTO-${DateTime.now().millisecondsSinceEpoch}' : batchController.text,
                    supplierController.text,
                    selectedQuality,
                  );
                  Navigator.pop(context);
                  // Dispose controllers after dialog closes
                  nameController.dispose();
                  quantityController.dispose();
                  priceController.dispose();
                  batchController.dispose();
                  supplierController.dispose();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill required fields')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewItem(String name, String category, int quantity, double price, 
                   String location, String batch, String supplier, String quality) {
    final newItem = {
      'id': 'INV${(_allInventory.length + 1).toString().padLeft(3, '0')}',
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': _getUnitForCategory(category),
      'status': quantity > 100 ? 'In Stock' : quantity > 0 ? 'Low Stock' : 'Out of Stock',
      'location': location,
      'batch': batch,
      'expiryDate': _getDefaultExpiryDate(category),
      'price': price,
      'supplier': supplier.isEmpty ? 'Direct Purchase' : supplier,
      'lastUpdated': 'Just now',
      'quality': quality,
      'certifications': <String>[],
      'minStock': (quantity * 0.2).round(),
      'maxStock': quantity * 3,
      'costPrice': price * 0.85,
      'alertLevel': (quantity * 0.3).round(),
    };

    setState(() {
      _allInventory.add(newItem);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${name} added to inventory successfully!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _allInventory.removeLast();
            });
          },
        ),
      ),
    );
  }

  String _getUnitForCategory(String category) {
    switch (category) {
      case 'Oils': return 'liters';
      case 'Fiber': return 'bales';
      default: return 'kg';
    }
  }

  String _getDefaultExpiryDate(String category) {
    final now = DateTime.now();
    switch (category) {
      case 'Fruits':
      case 'Vegetables':
        return '${now.add(const Duration(days: 14)).year}-${now.add(const Duration(days: 14)).month.toString().padLeft(2, '0')}-${now.add(const Duration(days: 14)).day.toString().padLeft(2, '0')}';
      case 'Oils':
        return '${now.add(const Duration(days: 365)).year}-${now.add(const Duration(days: 365)).month.toString().padLeft(2, '0')}-${now.add(const Duration(days: 365)).day.toString().padLeft(2, '0')}';
      case 'Grains':
        return '${now.add(const Duration(days: 180)).year}-${now.add(const Duration(days: 180)).month.toString().padLeft(2, '0')}-${now.add(const Duration(days: 180)).day.toString().padLeft(2, '0')}';
      default:
        return 'N/A';
    }
  }

  void _editQuantity(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: item['quantity'].toString());
        return AlertDialog(
          title: Text('Edit Quantity - ${item['name']}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity (${item['unit']})',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  item['quantity'] = int.tryParse(controller.text) ?? item['quantity'];
                  item['lastUpdated'] = 'Just now';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['name']} quantity updated')),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _generateBarcode(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.qr_code_2, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'QR Code - ${item['name']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: 220,
              height: 220,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.qr_code,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['id'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    item['batch'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Scan this QR code to view item details, track location, and verify authenticity.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('QR Code shared successfully')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('QR Code for ${item['name']} downloaded'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _printQRCode(item);
              },
              icon: const Icon(Icons.print),
              label: const Text('Print QR Code'),
            ),
          ],
        ),
      ),
    );
  }

  void _printQRCode(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print QR Code'),
        content: Text('Print QR code for ${item['name']}?\n\nThis will generate a printable version with item details.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Printing QR code for ${item['name']}...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Print'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}