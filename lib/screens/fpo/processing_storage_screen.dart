import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProcessingStorageScreen extends StatefulWidget {
  const ProcessingStorageScreen({super.key});

  @override
  State<ProcessingStorageScreen> createState() => _ProcessingStorageScreenState();
}

class _ProcessingStorageScreenState extends State<ProcessingStorageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _selectedStatus = 'All Status';
  bool _isMillView = true;
  int _selectedNavIndex = 0;
  GoogleMapController? _mapController;
  
  // Sample warehouse locations for map
  final List<Map<String, dynamic>> _warehouseLocations = [
    {'name': 'Sunrise Mill', 'status': 'Active', 'lat': 28.6129, 'lng': 77.2070, 'color': Colors.green},
    {'name': 'Golden Grains Warehouse', 'status': 'Active', 'lat': 28.6159, 'lng': 77.2110, 'color': Colors.blue},
    {'name': 'AgriHub Processing', 'status': 'Active', 'lat': 28.6099, 'lng': 77.2050, 'color': Colors.green},
    {'name': 'PrimeGrains Storage', 'status': 'Inactive', 'lat': 28.6189, 'lng': 77.2160, 'color': Colors.orange},
  ];
  
  // Mock data for mills and warehouses
  final List<Map<String, dynamic>> _allFacilities = [
    {
      'type': 'mill',
      'title': 'Sunrise Mill',
      'location': 'Nagpur, Maharashtra',
      'status': 'In Progress',
      'extractionProgress': 0.65,
      'warehouseUtilization': 0.75,
      'predictiveText': 'Expected to reach full capacity in 5 days.',
      'id': 'mill_001',
    },
    {
      'type': 'mill',
      'title': 'Golden Fields Processing',
      'location': 'Indore, Madhya Pradesh',
      'status': 'Completed',
      'extractionProgress': 1.0,
      'warehouseUtilization': 0.90,
      'predictiveText': 'Capacity nearing limit. Action recommended.',
      'id': 'mill_002',
    },
    {
      'type': 'warehouse',
      'title': 'Central Storage Hub',
      'location': 'Mumbai, Maharashtra',
      'status': 'Active',
      'capacity': 0.85,
      'temperature': '18°C',
      'humidity': '45%',
      'id': 'warehouse_001',
    },
    {
      'type': 'warehouse',
      'title': 'Regional Distribution Center',
      'location': 'Delhi, Delhi',
      'status': 'Maintenance',
      'capacity': 0.60,
      'temperature': '20°C',
      'humidity': '40%',
      'id': 'warehouse_002',
    },
  ];

  List<Map<String, dynamic>> get _filteredFacilities {
    var filtered = _allFacilities;
    
    // Filter by type
    if (_selectedFilter == 'Mills') {
      filtered = filtered.where((f) => f['type'] == 'mill').toList();
    } else if (_selectedFilter == 'Warehouses') {
      filtered = filtered.where((f) => f['type'] == 'warehouse').toList();
    }
    
    // Filter by status
    if (_selectedStatus != 'All Status') {
      filtered = filtered.where((f) => f['status'] == _selectedStatus).toList();
    }
    
    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((f) => 
        f['title'].toLowerCase().contains(searchTerm) ||
        f['location'].toLowerCase().contains(searchTerm)
      ).toList();
    }
    
    return filtered;
  }

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
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Search Bar
            _buildSearchBar(),

            // Filter Chips
            _buildFilterChips(),

            // Segmented Toggle
            _buildSegmentedToggle(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Map View
                    _buildMapView(),

                    // Data Cards
                    _buildDataCards(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Processing & Storage',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                _showNotifications();
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24,
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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.search,
                color: Color(0xFF9CA3AF),
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
                onChanged: (value) {
                  setState(() {
                    // Trigger rebuild to update filtered results
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search by mill or warehouse',
                  hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.clear,
                  color: Color(0xFF9CA3AF),
                  size: 20,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildFilterChip('All'),
          _buildFilterChip('Mills'),
          _buildFilterChip('Warehouses'),
          _buildStatusChip(),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          _showStatusFilter();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedStatus,
                style: const TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.expand_more,
                color: Color(0xFFD1D5DB),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMillView = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isMillView ? const Color(0xFF111121) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _isMillView
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Mill Overview',
                    style: TextStyle(
                      color: _isMillView ? Colors.white : const Color(0xFF9CA3AF),
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
                  setState(() {
                    _isMillView = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: !_isMillView ? const Color(0xFF111121) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: !_isMillView
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Warehouse Details',
                    style: TextStyle(
                      color: !_isMillView ? Colors.white : const Color(0xFF9CA3AF),
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

  Widget _buildMapView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(28.6139, 77.2090), // Delhi, India
              zoom: 13,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _warehouseLocations.map((warehouse) {
              return Marker(
                markerId: MarkerId(warehouse['name']),
                position: LatLng(warehouse['lat'], warehouse['lng']),
                infoWindow: InfoWindow(
                  title: warehouse['name'],
                  snippet: 'Status: ${warehouse['status']}',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  warehouse['status'] == 'Active' 
                      ? BitmapDescriptor.hueGreen 
                      : BitmapDescriptor.hueOrange,
                ),
                onTap: () => _showMapDetails(),
              );
            }).toSet(),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
            buildingsEnabled: true,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCards() {
    final facilities = _filteredFacilities;
    
    if (facilities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              color: const Color(0xFF9CA3AF),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'No facilities found',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your filters or search term',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: facilities.map((facility) {
          if (facility['type'] == 'mill') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildMillCard(
                title: facility['title'],
                location: facility['location'],
                status: facility['status'],
                statusColor: _getStatusColor(facility['status']),
                statusBgColor: _getStatusBgColor(facility['status']),
                extractionProgress: facility['extractionProgress'].toDouble(),
                warehouseUtilization: facility['warehouseUtilization'].toDouble(),
                predictiveText: facility['predictiveText'],
                facilityData: facility,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildWarehouseCard(facility),
            );
          }
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
      case 'Active':
        return const Color(0xFF34D399);
      case 'Completed':
        return const Color(0xFFD1D5DB);
      case 'Maintenance':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'In Progress':
      case 'Active':
        return const Color(0xFF065F46).withOpacity(0.5);
      case 'Completed':
        return const Color(0xFF374151).withOpacity(0.5);
      case 'Maintenance':
        return const Color(0xFF92400E).withOpacity(0.5);
      default:
        return const Color(0xFF374151).withOpacity(0.5);
    }
  }

  Widget _buildMillCard({
    required String title,
    required String location,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required double extractionProgress,
    required double warehouseUtilization,
    required String predictiveText,
    required Map<String, dynamic> facilityData,
  }) {
    return GestureDetector(
      onTap: () => _showFacilityDetails(facilityData),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Oil Extraction Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Oil Extraction',
                  style: TextStyle(
                    color: Color(0xFFD1D5DB),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: extractionProgress,
                    backgroundColor: const Color(0xFF374151),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF7C3AED),
                    ),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(extractionProgress * 100).toInt()}% Complete',
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Warehouse Utilization
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Warehouse Utilization',
                  style: TextStyle(
                    color: Color(0xFFD1D5DB),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: warehouseUtilization,
                    backgroundColor: const Color(0xFF374151),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4F46E5),
                    ),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(warehouseUtilization * 100).toInt()}% Full',
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Predictive Capacity
            GestureDetector(
              onTap: () => _showPredictiveAnalysis(facilityData),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF111121),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.analytics_outlined,
                      color: Color(0xFF7C3AED),
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Predictive Capacity',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Color(0xFFD1D5DB),
                                fontSize: 12,
                              ),
                              children: _parsePredictiveText(predictiveText),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF9CA3AF),
                      size: 20,
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

  List<TextSpan> _parsePredictiveText(String text) {
    final boldPattern = RegExp(r'\*\*(.+?)\*\*');
    final matches = boldPattern.allMatches(text);
    
    if (matches.isEmpty) {
      // Simple parsing for "5 days"
      if (text.contains('5 days')) {
        final parts = text.split('5 days');
        return [
          TextSpan(text: parts[0]),
          const TextSpan(
            text: '5 days',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextSpan(text: parts[1]),
        ];
      }
      return [TextSpan(text: text)];
    }

    final spans = <TextSpan>[];
    var lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.8),
        border: const Border(
          top: BorderSide(
            color: Color(0xFF374151),
            width: 0.5,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.srcOver,
          ),
          child: SafeArea(
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 'Home', 0),
                  _buildNavItem(Icons.eco, 'Farms', 1),
                  _buildNavItem(Icons.inventory_2, 'Inventory', 2),
                  _buildNavItem(Icons.analytics, 'Reports', 3),
                  _buildNavItem(Icons.person, 'Profile', 4),
                ],
              ),
            ),
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
        _handleNavigation(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF9CA3AF),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF9CA3AF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation handler
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
      case 3: // Reports
        Navigator.pushReplacementNamed(context, '/reports');
        break;
      case 4: // Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  // Helper methods for interactions
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111121),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Processing Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationItem(
                      'Mill Alert',
                      'Machine #3 requires immediate maintenance',
                      Icons.warning,
                      const Color(0xFFF59E0B),
                      '2 hours ago',
                    ),
                    _buildNotificationItem(
                      'Storage Update',
                      'Warehouse capacity at 85% - consider expansion',
                      Icons.info,
                      const Color(0xFF4F46E5),
                      '4 hours ago',
                    ),
                    _buildNotificationItem(
                      'Processing Complete',
                      'Batch #123 oil extraction completed successfully',
                      Icons.check_circle,
                      const Color(0xFF34D399),
                      '6 hours ago',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(String title, String message, IconData icon, Color color, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111121),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...[
                'All Status',
                'In Progress',
                'Completed',
                'Active',
                'Maintenance',
              ].map((status) => ListTile(
                    title: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: _selectedStatus == status
                        ? const Icon(Icons.check, color: Color(0xFF4F46E5))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedStatus = status;
                      });
                      Navigator.pop(context);
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showMapDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111121),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interactive Map View',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildMapLocationItem(
                      'Sunrise Mill',
                      'Nagpur, Maharashtra',
                      Icons.factory,
                      const Color(0xFF34D399),
                      'Active Processing',
                    ),
                    _buildMapLocationItem(
                      'Golden Fields Processing',
                      'Indore, Madhya Pradesh',
                      Icons.factory,
                      const Color(0xFF4F46E5),
                      'Processing Complete',
                    ),
                    _buildMapLocationItem(
                      'Central Storage Hub',
                      'Mumbai, Maharashtra',
                      Icons.warehouse,
                      const Color(0xFFF59E0B),
                      '85% Capacity',
                    ),
                    _buildMapLocationItem(
                      'Regional Distribution',
                      'Delhi, Delhi',
                      Icons.warehouse,
                      const Color(0xFFEF4444),
                      'Under Maintenance',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapLocationItem(String name, String location, IconData icon, Color color, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 14,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFacilityDetails(Map<String, dynamic> facility) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111121),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      facility['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (facility['type'] == 'mill') ...[
                _buildDetailRow('Location', facility['location']),
                _buildDetailRow('Status', facility['status']),
                _buildDetailRow('Extraction Progress', '${(facility['extractionProgress'] * 100).toInt()}%'),
                _buildDetailRow('Warehouse Utilization', '${(facility['warehouseUtilization'] * 100).toInt()}%'),
                const SizedBox(height: 24),
                const Text(
                  'Controls',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildControlButton('Start Processing', Icons.play_arrow, const Color(0xFF34D399)),
                _buildControlButton('Pause Processing', Icons.pause, const Color(0xFFF59E0B)),
                _buildControlButton('Emergency Stop', Icons.stop, const Color(0xFFEF4444)),
              ] else ...[
                _buildDetailRow('Location', facility['location']),
                _buildDetailRow('Status', facility['status']),
                _buildDetailRow('Capacity', '${(facility['capacity'] * 100).toInt()}%'),
                _buildDetailRow('Temperature', facility['temperature']),
                _buildDetailRow('Humidity', facility['humidity']),
              ],
            ],
          ),
        );
      },
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
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(String label, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label action triggered')),
          );
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _showPredictiveAnalysis(Map<String, dynamic> facility) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111121),
          title: const Text(
            'Predictive Analysis',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                facility['predictiveText'],
                style: const TextStyle(color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 16),
              const Text(
                'AI Recommendations:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Monitor temperature levels closely\n• Schedule maintenance in next 48 hours\n• Optimize processing speed for efficiency',
                style: TextStyle(color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Build warehouse card method
  Widget _buildWarehouseCard(Map<String, dynamic> warehouse) {
    return GestureDetector(
      onTap: () => _showFacilityDetails(warehouse),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        warehouse['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        warehouse['location'],
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(warehouse['status']),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    warehouse['status'],
                    style: TextStyle(
                      color: _getStatusColor(warehouse['status']),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Capacity',
                        style: TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(warehouse['capacity'] * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temperature',
                        style: TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        warehouse['temperature'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Humidity',
                        style: TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        warehouse['humidity'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
