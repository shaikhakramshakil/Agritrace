import 'package:flutter/material.dart';
import 'package:agritrace/screens/retailer/order_tracking_screen.dart';
import 'package:agritrace/screens/retailer/retailer_profile_screen.dart';
import 'package:agritrace/screens/blockchain/blockchain_trace_screen.dart';
import 'package:agritrace/widgets/agritrace_logo.dart';

class RetailerInventoryScreen extends StatefulWidget {
  const RetailerInventoryScreen({super.key});

  @override
  State<RetailerInventoryScreen> createState() => _RetailerInventoryScreenState();
}

class _RetailerInventoryScreenState extends State<RetailerInventoryScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  int _selectedNavIndex = 0;
  late AnimationController _animationController;
  
  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'name': 'Premium Basmati Rice',
      'location': 'Punjab, India',
      'details': 'Length: 8mm, Purity: 99.9%',
      'available': '500 Quintal',
      'price': '₹4,500/Quintal',
      'rating': 4.8,
      'reviews': 234,
      'category': 'Rice',
      'organic': true,
      'trending': true,
      'image': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=800',
    },
    {
      'name': 'Organic Sunflower Seeds',
      'location': 'Karnataka, India',
      'details': 'Oil: 48%, Moisture: 7%',
      'available': '300 Quintal',
      'price': '₹3,800/Quintal',
      'rating': 4.6,
      'reviews': 189,
      'category': 'Sunflower',
      'organic': true,
      'trending': false,
      'image': 'https://images.unsplash.com/photo-1612500473841-e23fd5d5f1e0?w=800',
    },
    {
      'name': 'Premium Soybean',
      'location': 'Madhya Pradesh, India',
      'details': 'Protein: 40%, Oil: 20%',
      'available': '750 Quintal',
      'price': '₹5,200/Quintal',
      'rating': 4.9,
      'reviews': 312,
      'category': 'Soybean',
      'organic': false,
      'trending': true,
      'image': 'https://images.unsplash.com/photo-1588595148293-f8e56a0a5c1f?w=800',
    },
    {
      'name': 'Golden Mustard Seeds',
      'location': 'Rajasthan, India',
      'details': 'Oil: 42%, Purity: 98%',
      'available': '200 Quintal',
      'price': '₹7,500/Quintal',
      'rating': 4.7,
      'reviews': 156,
      'category': 'Mustard',
      'organic': true,
      'trending': false,
      'image': 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=800',
    },
    {
      'name': 'Organic Wheat Grain',
      'location': 'Haryana, India',
      'details': 'Protein: 12%, Gluten: High',
      'available': '900 Quintal',
      'price': '₹2,800/Quintal',
      'rating': 4.5,
      'reviews': 421,
      'category': 'Wheat',
      'organic': true,
      'trending': true,
      'image': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800',
    },
    {
      'name': 'Premium Chickpeas',
      'location': 'Maharashtra, India',
      'details': 'Size: 8-9mm, Moisture: 10%',
      'available': '400 Quintal',
      'price': '₹6,200/Quintal',
      'rating': 4.8,
      'reviews': 267,
      'category': 'Pulses',
      'organic': false,
      'trending': true,
      'image': 'https://images.unsplash.com/photo-1599639832305-ae7ba9c0ed8e?w=800',
    },
    {
      'name': 'Red Lentils (Masoor Dal)',
      'location': 'Uttar Pradesh, India',
      'details': 'Split: Yes, Polished: Yes',
      'available': '350 Quintal',
      'price': '₹5,800/Quintal',
      'rating': 4.6,
      'reviews': 198,
      'category': 'Pulses',
      'organic': true,
      'trending': false,
      'image': 'https://images.unsplash.com/photo-1596803244618-8dbee441ed78?w=800',
    },
    {
      'name': 'Organic Canola Oil Seeds',
      'location': 'Gujarat, India',
      'details': 'Oil: 44%, Omega-3: High',
      'available': '250 Quintal',
      'price': '₹4,200/Quintal',
      'rating': 4.4,
      'reviews': 143,
      'category': 'Canola',
      'organic': true,
      'trending': false,
      'image': 'https://images.unsplash.com/photo-1582137544757-2b44e6fcc871?w=800',
    },
    {
      'name': 'Premium Cotton Seeds',
      'location': 'Telangana, India',
      'details': 'Oil: 18%, Fiber: 35%',
      'available': '600 Quintal',
      'price': '₹3,200/Quintal',
      'rating': 4.5,
      'reviews': 176,
      'category': 'Cotton',
      'organic': false,
      'trending': false,
      'image': 'https://images.unsplash.com/photo-1602073618465-b7bf3e8b3c1d?w=800',
    },
  ];
  
  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedFilter == 'All') return _inventoryItems;
    if (_selectedFilter == 'Organic') {
      return _inventoryItems.where((item) => item['organic'] == true).toList();
    }
    if (_selectedFilter == 'Trending') {
      return _inventoryItems.where((item) => item['trending'] == true).toList();
    }
    return _inventoryItems.where((item) => item['category'] == _selectedFilter).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: _selectedNavIndex == 0
          ? _buildInventoryContent()
          : _selectedNavIndex == 1
              ? const OrderTrackingScreen()
              : const RetailerProfileScreen(),
      floatingActionButton: _selectedNavIndex == 0 ? _buildFloatingActionButton() : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Filter applied successfully!'),
            backgroundColor: Color(0xFF9D4EDD),
          ),
        );
      },
      backgroundColor: const Color(0xFF9D4EDD),
      icon: const Icon(Icons.filter_list, color: Colors.white),
      label: const Text('Advanced Filters', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildInventoryContent() {
    return SafeArea(
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Search Bar
          _buildSearchBar(),

          // Filter Chips
          _buildFilterChips(),

          // Inventory List
          Expanded(
            child: _buildInventoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerLeft,
            child: const Icon(
              Icons.menu,
              color: Color(0xFFF1FAEE),
              size: 30,
            ),
          ),
          // AgriTrace Logo
          const AgriTraceHeaderLogo(
            height: 28.0,
            iconColor: Color(0xFF1D3557),
            textColor: Color(0xFFF1FAEE),
          ),
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: Show filter options
              },
              icon: const Icon(
                Icons.tune,
                color: Color(0xFFF1FAEE),
                size: 30,
              ),
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
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.search,
                color: Color(0xFFA8DADC),
                size: 24,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: Color(0xFFF1FAEE),
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search for products...',
                  hintStyle: TextStyle(
                    color: Color(0xFFA8DADC),
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
    final filters = ['All', 'Rice', 'Sunflower', 'Soybean', 'Wheat', 'Pulses', 'Canola', 'Organic', 'Trending'];
    
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
                _animationController.reset();
                _animationController.forward();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF9D4EDD) : const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF9D4EDD) : const Color(0xFF2D2D44),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFA8DADC),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInventoryList() {
    final filteredItems = _filteredItems;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.1,
                1.0,
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  index * 0.1,
                  1.0,
                  curve: Curves.easeIn,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInventoryCard(item),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D4EDD).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2A3E),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Color(0xFFA8DADC),
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (item['trending'] == true)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.trending_up, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Trending',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (item['organic'] == true)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.eco, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Organic',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: const TextStyle(
                          color: Color(0xFFF1FAEE),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.27,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item['rating'].toString(),
                          style: const TextStyle(
                            color: Color(0xFFF1FAEE),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' (${item['reviews']})',
                          style: const TextStyle(
                            color: Color(0xFFA8DADC),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF9D4EDD),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['location'],
                      style: const TextStyle(
                        color: Color(0xFFA8DADC),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A192F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['details'],
                            style: const TextStyle(
                              color: Color(0xFFA8DADC),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available',
                                style: TextStyle(
                                  color: Color(0xFFA8DADC),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['available'],
                                style: const TextStyle(
                                  color: Color(0xFFF1FAEE),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  color: Color(0xFFA8DADC),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['price'],
                                style: const TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Blockchain Link and Button
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlockchainTraceScreen(
                                productName: item['name'],
                                batchId: 'BT${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.link, size: 16),
                        label: const Text('Trace'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF9D4EDD),
                          side: const BorderSide(color: Color(0xFF9D4EDD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Purchase request sent for ${item['name']}'),
                              backgroundColor: const Color(0xFF4CAF50),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9D4EDD),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Request Purchase',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF9D4EDD).withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.inventory_2, 'Inventory', 0),
              _buildNavItem(Icons.local_shipping, 'Orders', 1),
              _buildNavItem(Icons.person, 'Profile', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9D4EDD).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF9D4EDD) : const Color(0xFFA8DADC),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF9D4EDD) : const Color(0xFFA8DADC),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
