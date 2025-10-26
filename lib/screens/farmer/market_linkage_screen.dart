import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarketLinkageScreen extends StatefulWidget {
  const MarketLinkageScreen({super.key});

  @override
  State<MarketLinkageScreen> createState() => _MarketLinkageScreenState();
}

class _MarketLinkageScreenState extends State<MarketLinkageScreen> {
  bool _isListView = true;
  final TextEditingController _searchController = TextEditingController();
  bool _hasLocationPermission = false;
  String? _userLocation;
  bool _isLoadingLocation = false;
  GoogleMapController? _mapController;
  
  // Sample buyer locations for map markers
  final List<Map<String, dynamic>> _buyerLocations = [
    {'name': 'GreenLeaf FPO', 'price': '₹4,550', 'lat': 28.6139, 'lng': 77.2090, 'color': Colors.green},
    {'name': 'AgriCorp', 'price': '₹5,150', 'lat': 28.6189, 'lng': 77.2150, 'color': Colors.orange},
    {'name': 'PrimeGrains', 'price': '₹2,350', 'lat': 28.6089, 'lng': 77.2040, 'color': Colors.green},
    {'name': 'RiceMax', 'price': '₹3,200', 'lat': 28.6239, 'lng': 77.2190, 'color': Colors.orange},
    {'name': 'Golden Harvest', 'price': '₹2,850', 'lat': 28.6139, 'lng': 77.2140, 'color': Colors.green},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                _buildHeader(),

                // Price Ticker
                _buildPriceTicker(),

                // Search Bar
                _buildSearchBar(),

                // Filter Chips
                _buildFilterChips(),

                // View Toggle
                _buildViewToggle(),

                // Market Analysis Section
                _buildAnalysisSection(),

                // Market Cards List or Map View
                Expanded(
                  child: _isListView ? ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                      _buildMarketCard(
                        name: 'GreenLeaf FPO',
                        rating: 4.8,
                        reviews: 120,
                        distance: '7 km away',
                        price: 'Soybean: ₹4,550/quintal',
                        demand: 'High Demand',
                        paymentTerms: '30 days',
                        volume: '500+ quintals',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBhYYIOa2Cxyj3DZ5gY0YplNSimc32DD0JgVVv1dmNzUNWcGy--Umt9G7b6wpnfqQgYuioAO5tZv8PTCXKaq_nekXAN0zazwijUG0gpGp-FbiVzHXSm8hioR0c0NP5bQeFJrEg0tDp5NYXmCG6P0PrnYkGMbPXncHQteRQiZn_8yMAodgow7v4wEwJsDdQNKz2uvoEb_qwKGdpbC876DTT0_ZBl_CDrLAJJwXBXH-QbWQMPAtkHZY83CDqrr9fZwqqvJoRPRdHR928',
                      ),
                      _buildMarketCard(
                        name: 'AgriCorp Processors',
                        rating: 4.5,
                        reviews: 85,
                        distance: '15 km away',
                        price: 'Mustard: ₹5,150/quintal',
                        demand: 'Medium Demand',
                        paymentTerms: '15 days',
                        volume: '300+ quintals',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBa06IZHJ0wC81ZoAtnPG8F4ZkP1DXUOjlZ_okUCtVl4uFItEuO7xeW5LAyhxcTlsWKUetPrWzJvng6xg4qUQeOT1uvOyggaGS14obAiQVKexZn4QeFLFxzdvut6lYSkCmQfT412jYbYhLTHqurHHR4E58eMW4mDdEDn7IOivQ6pjLFWn5AJP-JyW3PRb5dXAQybFFqgp7geeoWIItYYIkczSZYQtu2E1r52nqeH8xpACdP-jhZcble0QQ7c_4ujtcNAjfFAAP4Y0c',
                      ),
                      _buildMarketCard(
                        name: 'SunSeeds Buyers',
                        rating: 4.2,
                        reviews: 43,
                        distance: '22 km away',
                        price: 'Sunflower: ₹4,820/quintal',
                        demand: 'Low Demand',
                        paymentTerms: '45 days',
                        volume: '200+ quintals',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuACFAWmVMP7w4-dE-YupX5W4-kwACPic29UPbSWKKAR6FBHnMyYqDbje6hZg6CNpLs2ebxTbKm6MHFjBi-sLiuyRsmoDx1xscvDXwbUacpavyGKR77DGT6AJIWL7cRE-JWw5s-RJnuOJ39qyyXN8QCnkdQ7kJ64vOO6a3P-tZ0qnByC1iR5H4o9HdgSOZ-M4LG-x907Om7f2ps4UlfKMGZW3pemmZRJIR0Jcajy2G2Sw8f9g2HXXdMogcGJkAAXPzOH8-5Z5I1C7rU',
                      ),
                      _buildMarketCard(
                        name: 'PrimeGrains Export',
                        rating: 4.7,
                        reviews: 95,
                        distance: '12 km away',
                        price: 'Wheat: ₹2,350/quintal',
                        demand: 'High Demand',
                        paymentTerms: '7 days',
                        volume: '1000+ quintals',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBhYYIOa2Cxyj3DZ5gY0YplNSimc32DD0JgVVv1dmNzUNWcGy--Umt9G7b6wpnfqQgYuioAO5tZv8PTCXKaq_nekXAN0zazwijUG0gpGp-FbiVzHXSm8hioR0c0NP5bQeFJrEg0tDp5NYXmCG6P0PrnYkGMbPXncHQteRQiZn_8yMAodgow7v4wEwJsDdQNKz2uvoEb_qwKGdpbC876DTT0_ZBl_CDrLAJJwXBXH-QbWQMPAtkHZY83CDqrr9fZwqqvJoRPRdHR928',
                      ),
                      _buildMarketCard(
                        name: 'RiceMax Industries',
                        rating: 4.3,
                        reviews: 67,
                        distance: '25 km away',
                        price: 'Rice: ₹3,200/quintal',
                        demand: 'Medium Demand',
                        paymentTerms: '21 days',
                        volume: '750+ quintals',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBa06IZHJ0wC81ZoAtnPG8F4ZkP1DXUOjlZ_okUCtVl4uFItEuO7xeW5LAyhxcTlsWKUetPrWzJvng6xg4qUQeOT1uvOyggaGS14obAiQVKexZn4QeFLFxzdvut6lYSkCmQfT412jYbYhLTHqurHHR4E58eMW4mDdEDn7IOivQ6pjLFWn5AJP-JyW3PRb5dXAQybFFqgp7geeoWIItYYIkczSZYQtu2E1r52nqeH8xpACdP-jhZcble0QQ7c_4ujtcNAjfFAAP4Y0c',
                      ),
                      _buildMarketCard(
                        name: 'Golden Harvest Co-op',
                        rating: 4.6,
                        reviews: 132,
                        distance: '18 km away',
                        price: 'Corn: ₹2,850/quintal',
                        demand: 'High Demand',
                        paymentTerms: '14 days',
                        volume: '600+ quintals',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuACFAWmVMP7w4-dE-YupX5W4-kwACPic29UPbSWKKAR6FBHnMyYqDbje6hZg6CNpLs2ebxTbKm6MHFjBi-sLiuyRsmoDx1xscvDXwbUacpavyGKR77DGT6AJIWL7cRE-JWw5s-RJnuOJ39qyyXN8QCnkdQ7kJ64vOO6a3P-tZ0qnByC1iR5H4o9HdgSOZ-M4LG-x907Om7f2ps4UlfKMGZW3pemmZRJIR0Jcajy2G2Sw8f9g2HXXdMogcGJkAAXPzOH8-5Z5I1C7rU',
                      ),
                    ],
                  ) : _buildMapView(),
                ),
              ],
            ),

            // Floating Action Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0A1931).withOpacity(0),
                      const Color(0xFF0A1931),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _initiateSale();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A2BE2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF8A2BE2).withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Initiate Sale',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
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
        children: const [
          Icon(
            Icons.menu,
            color: Colors.white,
            size: 28,
          ),
          Expanded(
            child: Text(
              'Market Linkage',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Icon(
            Icons.notifications,
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTicker() {
    return Container(
      height: 40,
      color: Colors.black.withOpacity(0.3),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTickerItem('Soybean: ₹4,500/quintal', true),
          _buildTickerItem('Mustard: ₹5,200/quintal', false),
          _buildTickerItem('Sunflower: ₹4,800/quintal', true),
          _buildTickerItem('Groundnut: ₹5,500/quintal', false),
          _buildTickerItem('Sesame: ₹6,000/quintal', true),
        ],
      ),
    );
  }

  Widget _buildTickerItem(String text, bool isUp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isUp ? Icons.arrow_upward : Icons.arrow_downward,
            color: isUp ? Colors.green : Colors.red,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.search,
                color: Color(0xFFC0C0C0),
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
                  hintText: 'Search for FPOs, processors, or buyers',
                  hintStyle: TextStyle(
                    color: Color(0xFFA9A9A9),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildChip(Icons.swap_vert, 'Sort by'),
          _buildChip(Icons.place, 'Distance'),
          _buildChip(Icons.monetization_on, 'Price'),
          _buildChip(Icons.groups, 'Buyer Type'),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => _handleFilterTap(label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF374151),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: const Color(0xFFC0C0C0),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFilterTap(String filterType) {
    switch (filterType) {
      case 'Sort by':
        _showSortOptions();
        break;
      case 'Distance':
        _showDistanceFilter();
        break;
      case 'Price':
        _showPriceFilter();
        break;
      case 'Buyer Type':
        _showBuyerTypeFilter();
        break;
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption('Rating (High to Low)', Icons.star),
            _buildSortOption('Distance (Near to Far)', Icons.location_on),
            _buildSortOption('Price (High to Low)', Icons.monetization_on),
            _buildSortOption('Payment Terms (Fast to Slow)', Icons.schedule),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sorted by: $title'),
            backgroundColor: const Color(0xFF4F46E5),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF4F46E5),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDistanceFilter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🗺️ Distance filter: Showing buyers within 25km'),
        backgroundColor: Color(0xFF4F46E5),
      ),
    );
  }

  void _showPriceFilter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💰 Price filter: Showing competitive rates only'),
        backgroundColor: Color(0xFF4F46E5),
      ),
    );
  }

  void _showBuyerTypeFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Filter by Buyer Type',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBuyerTypeOption('🏢 FPO (Farmer Producer Organizations)'),
            _buildBuyerTypeOption('🏭 Processors & Mills'),
            _buildBuyerTypeOption('🌍 Export Companies'),
            _buildBuyerTypeOption('🤝 Cooperatives'),
            _buildBuyerTypeOption('🛒 Direct Retailers'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF4F46E5))),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerTypeOption(String type) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Filtered by: $type'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                type,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFA9A9A9),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isListView = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isListView ? const Color(0xFF8A2BE2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: _isListView
                        ? [
                            BoxShadow(
                              color: const Color(0xFF8A2BE2).withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'List View',
                    style: TextStyle(
                      color: _isListView ? Colors.white : const Color(0xFFC0C0C0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _handleMapViewTap();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: !_isListView ? const Color(0xFF8A2BE2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: !_isListView
                        ? [
                            BoxShadow(
                              color: const Color(0xFF8A2BE2).withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Map View',
                    style: TextStyle(
                      color: !_isListView ? Colors.white : const Color(0xFFC0C0C0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Market Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisCard(
                  'Price Trends',
                  '📈 +12%',
                  'Last 30 days',
                  Colors.green,
                  () => _showPriceTrends(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalysisCard(
                  'Best Buyers',
                  '🏆 Top 5',
                  'Near you',
                  const Color(0xFF4F46E5),
                  () => _showBestBuyers(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisCard(
                  'Market Demand',
                  '🔥 High',
                  'Soybean & Wheat',
                  Colors.orange,
                  () => _showMarketDemand(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalysisCard(
                  'Payment Terms',
                  '💰 Analysis',
                  'Compare options',
                  const Color(0xFF00FFFF),
                  () => _showPaymentAnalysis(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(String title, String value, String subtitle, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFFA9A9A9),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketCard({
    required String name,
    required double rating,
    required int reviews,
    required String distance,
    required String price,
    required String demand,
    required String paymentTerms,
    required String volume,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: const Color(0xFF1F2937),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.business,
                            color: Color(0xFF9D9DB8),
                            size: 32,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$rating ($reviews)',
                              style: const TextStyle(
                                color: Color(0xFFA9A9A9),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF4F46E5),
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              distance,
                              style: const TextStyle(
                                color: Color(0xFFA9A9A9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937).withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  // Detail chips row
                  Row(
                    children: [
                      Flexible(child: _buildDetailChip(demand, _getDemandColor(demand))),
                      const SizedBox(width: 6),
                      Flexible(child: _buildDetailChip('₹ $paymentTerms', Colors.green)),
                      const SizedBox(width: 6),
                      Flexible(child: _buildDetailChip('📦 $volume', const Color(0xFF00FFFF))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Action buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildActionButton('Analyze', Icons.analytics, () => _analyzeMarket(name))),
                      const SizedBox(width: 4),
                      Expanded(child: _buildActionButton('Contact', Icons.phone, () => _contactBuyer(name))),
                      const SizedBox(width: 4),
                      Expanded(child: _buildActionButton('Quote', Icons.request_quote, () => _requestQuote(name))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF4F46E5).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF4F46E5),
              size: 10,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF4F46E5),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDemandColor(String demand) {
    switch (demand.toLowerCase()) {
      case 'high demand':
        return Colors.green;
      case 'medium demand':
        return Colors.orange;
      case 'low demand':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Analysis Section Actions
  void _showPriceTrends() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📈 Price Trends Analysis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last 30 Days Performance:',
              style: TextStyle(
                color: Color(0xFFA9A9A9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            _buildTrendItem('Soybean', '+12%', '₹4,550/quintal', Colors.green),
            _buildTrendItem('Wheat', '+8%', '₹2,350/quintal', Colors.green),
            _buildTrendItem('Mustard', '-3%', '₹5,150/quintal', Colors.red),
            _buildTrendItem('Rice', '+5%', '₹3,200/quintal', Colors.green),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(String crop, String change, String price, Color changeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            crop,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                change,
                style: TextStyle(
                  color: changeColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFFA9A9A9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBestBuyers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '🏆 Best Buyers Near You',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBuyerRankItem('1', 'PrimeGrains Export', '4.7★', '7 days payment'),
            _buildBuyerRankItem('2', 'GreenLeaf FPO', '4.8★', '30 days payment'),
            _buildBuyerRankItem('3', 'Golden Harvest Co-op', '4.6★', '14 days payment'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF4F46E5))),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerRankItem(String rank, String name, String rating, String payment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                rank,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$rating • $payment',
                  style: const TextStyle(
                    color: Color(0xFFA9A9A9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMarketDemand() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔥 High demand detected for Soybean and Wheat in your area!'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showPaymentAnalysis() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💰 Payment Terms Analysis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentAnalysisItem('Fastest Payment', 'PrimeGrains Export', '7 days', Colors.green),
            _buildPaymentAnalysisItem('Average Payment', 'Industry Average', '21 days', Colors.orange),
            _buildPaymentAnalysisItem('Slowest Payment', 'SunSeeds Buyers', '45 days', Colors.red),
            const SizedBox(height: 16),
            const Text(
              '💡 Tip: Choose buyers with faster payment terms for better cash flow.',
              style: TextStyle(
                color: Color(0xFF00FFFF),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Understood'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentAnalysisItem(String category, String buyer, String term, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                buyer,
                style: const TextStyle(
                  color: Color(0xFFA9A9A9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              term,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Market Card Actions
  void _analyzeMarket(String buyerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '📊 Market Analysis: $buyerName',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnalysisPoint('💹 Price Competitiveness', 'Above average by 8%', Colors.green),
            _buildAnalysisPoint('⚡ Payment Speed', 'Faster than 75% of buyers', Colors.blue),
            _buildAnalysisPoint('📦 Volume Capacity', 'Can handle large orders', Colors.orange),
            _buildAnalysisPoint('⭐ Reliability Score', '9.2/10 based on reviews', Colors.purple),
            const SizedBox(height: 12),
            const Text(
              '🎯 Recommendation: Highly recommended for bulk sales with competitive pricing.',
              style: TextStyle(
                color: Color(0xFF00FFFF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF4F46E5))),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisPoint(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _contactBuyer(String buyerName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '📞 Contact $buyerName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactOption('📱 Call Now', '+91 98765 43210', Icons.phone, () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling buyer...')),
              );
            }),
            _buildContactOption('💬 WhatsApp', 'Send message on WhatsApp', Icons.message, () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening WhatsApp...')),
              );
            }),
            _buildContactOption('✉️ Email', 'Send business inquiry', Icons.email, () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening email app...')),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF4F46E5),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFA9A9A9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFA9A9A9),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _requestQuote(String buyerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '₹ Request Quote from $buyerName',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select your crop and quantity:',
              style: TextStyle(color: Color(0xFFA9A9A9), fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildQuoteOption('🌾 Soybean', '50 quintals', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Quote request sent to $buyerName for Soybean'),
                  backgroundColor: Colors.green,
                ),
              );
            }),
            _buildQuoteOption('🌾 Wheat', '75 quintals', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Quote request sent to $buyerName for Wheat'),
                  backgroundColor: Colors.green,
                ),
              );
            }),
            _buildQuoteOption('🌻 Mustard', '30 quintals', () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Quote request sent to $buyerName for Mustard'),
                  backgroundColor: Colors.green,
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFFA9A9A9))),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteOption(String crop, String quantity, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              crop,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              quantity,
              style: const TextStyle(
                color: Color(0xFF4F46E5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initiateSale() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🚀 Initiate Sale Process',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSaleStep('1', 'Select Your Crop', 'Choose what you want to sell', Icons.grass, true),
                  _buildSaleStep('2', 'Set Quantity & Quality', 'Specify volume and grade', Icons.scale, false),
                  _buildSaleStep('3', 'Choose Buyers', 'Select from interested buyers', Icons.people, false),
                  _buildSaleStep('4', 'Negotiate Terms', 'Discuss price and delivery', Icons.handshake, false),
                  _buildSaleStep('5', 'Finalize Contract', 'Sign the deal digitally', Icons.assignment, false),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '💡 Quick Sale Options',
                          style: TextStyle(
                            color: Color(0xFF4F46E5),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildQuickSaleOption('🌾 Soybean - 50 quintals', '₹4,550/quintal'),
                        _buildQuickSaleOption('🌾 Wheat - 75 quintals', '₹2,350/quintal'),
                        _buildQuickSaleOption('🌻 Mustard - 30 quintals', '₹5,150/quintal'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFA9A9A9),
                      side: const BorderSide(color: Color(0xFFA9A9A9)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎉 Sale process initiated! Buyers will be notified.'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A2BE2),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Start Selling'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleStep(String step, String title, String description, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4F46E5).withOpacity(0.1) : const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? const Color(0xFF4F46E5) : Colors.transparent,
          width: isActive ? 1 : 0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF4F46E5) : const Color(0xFF374151),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFFA9A9A9),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            color: isActive ? const Color(0xFF4F46E5) : const Color(0xFFA9A9A9),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFFA9A9A9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: isActive ? const Color(0xFF4F46E5) : const Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSaleOption(String crop, String price) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quick sale initiated for $crop'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              crop,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Color(0xFF00FFFF),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMapViewTap() async {
    if (!_hasLocationPermission && _userLocation == null) {
      _showLocationPermissionDialog();
    } else {
      setState(() {
        _isListView = false;
      });
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF4F46E5), size: 24),
            SizedBox(width: 8),
            Text(
              'Location Access',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To show nearby buyers on the map, we need your location.',
              style: TextStyle(
                color: Color(0xFFA9A9A9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📍 We use your location to:',
                    style: TextStyle(
                      color: Color(0xFF4F46E5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '• Find buyers near your farm\n• Calculate accurate distances\n• Show optimal delivery routes\n• Provide location-based recommendations',
                    style: TextStyle(
                      color: Color(0xFFA9A9A9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _enterLocationManually();
            },
            child: const Text(
              'Enter Manually',
              style: TextStyle(color: Color(0xFFA9A9A9)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _requestLocationPermission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Allow Location'),
          ),
        ],
      ),
    );
  }

  void _requestLocationPermission() async {
    setState(() {
      _isLoadingLocation = true;
    });

    // Simulate location permission request
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Simulate getting location
    setState(() {
      _hasLocationPermission = true;
      _userLocation = 'Bangalore, Karnataka (12.9716°N, 77.5946°E)';
      _isLoadingLocation = false;
      _isListView = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📍 Location access granted! Map view enabled.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _enterLocationManually() {
    final TextEditingController locationController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '📍 Enter Your Location',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please enter your farm location:',
              style: TextStyle(
                color: Color(0xFFA9A9A9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'e.g., Bangalore, Karnataka',
                hintStyle: TextStyle(color: Color(0xFF6B7280)),
                filled: true,
                fillColor: Color(0xFF1F2937),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.location_city,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    locationController.text = 'Bangalore, Karnataka';
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Bangalore',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    locationController.text = 'Mysore, Karnataka';
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Mysore',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    locationController.text = 'Hubli, Karnataka';
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Hubli',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFA9A9A9)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (locationController.text.isNotEmpty) {
                setState(() {
                  _userLocation = locationController.text;
                  _hasLocationPermission = true;
                  _isListView = false;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📍 Location set to: ${locationController.text}'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    // Show location prompt if no permission/location set
    if (_userLocation == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      color: Color(0xFF4F46E5),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '📍 Location Required',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'To view buyers on the map, please\nallow location access or enter manually',
                      style: TextStyle(
                        color: Color(0xFFA9A9A9),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _requestLocationPermission,
                          icon: const Icon(Icons.gps_fixed, size: 14),
                          label: const Text(
                            'Allow Location',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _enterLocationManually,
                          icon: const Icon(Icons.edit_location, size: 14),
                          label: const Text(
                            'Enter Manually',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFA9A9A9),
                            side: const BorderSide(color: Color(0xFFA9A9A9)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show interactive Google Map with buyer locations
    return Container(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          // User Location Display
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.my_location,
                  color: Color(0xFF4F46E5),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your Location: $_userLocation',
                    style: const TextStyle(
                      color: Color(0xFF4F46E5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _enterLocationManually(),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Color(0xFF4F46E5),
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Google Map
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(28.6139, 77.2090), // Delhi, India coordinates
                    zoom: 13,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: _buyerLocations.map((buyer) {
                    return Marker(
                      markerId: MarkerId(buyer['name']),
                      position: LatLng(buyer['lat'], buyer['lng']),
                      infoWindow: InfoWindow(
                        title: buyer['name'],
                        snippet: '${buyer['price']} per quintal',
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        buyer['color'] == Colors.green 
                            ? BitmapDescriptor.hueGreen 
                            : BitmapDescriptor.hueOrange,
                      ),
                    );
                  }).toSet(),
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  buildingsEnabled: true,
                ),
              ),
            ),
          ),
          
          // Map controls and zoom buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF4F46E5), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your Location: $_userLocation',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    if (_mapController != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                          const CameraPosition(
                            target: LatLng(28.6139, 77.2090),
                            zoom: 13,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 20,
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

  Widget _buildMapMarker(String name, String price, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name - $price per quintal'),
            backgroundColor: color,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.white,
              size: 16,
            ),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
