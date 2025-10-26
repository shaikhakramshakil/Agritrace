import 'package:flutter/material.dart';
import 'package:agritrace/screens/logistics/logistics_tracker_screen.dart';
import 'package:agritrace/screens/logistics/logistics_profile_screen.dart';
import 'package:agritrace/screens/admin/warehouse_details_screen.dart';
import 'package:agritrace/services/gemini_ai_service.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WarehouseMapScreen extends StatefulWidget {
  const WarehouseMapScreen({super.key});

  @override
  State<WarehouseMapScreen> createState() => _WarehouseMapScreenState();
}

class _WarehouseMapScreenState extends State<WarehouseMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Warehouse data state
  List<Map<String, dynamic>> _allWarehouses = [];
  List<Map<String, dynamic>> _filteredWarehouses = [];
  Map<String, dynamic>? _selectedWarehouse;
  String _selectedRegionFilter = 'All';
  String _selectedCropFilter = 'All';
  String _selectedCapacityFilter = 'All';
  bool _isLoading = true;
  
  GoogleMapController? _mapController;
  double _currentZoom = 5.0;
  
  @override
  void initState() {
    super.initState();
    _fetchWarehouseData();
    _searchController.addListener(_onSearchChanged);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _fetchWarehouseData() async {
    setState(() => _isLoading = true);
    try {
      final prompt = '''
Generate a realistic list of 10 warehouse locations in India suitable for agricultural produce. 
Provide the output as a valid JSON array only. Each object in the array should have the following structure:
{
  "id": "WH-XXX",
  "name": "Warehouse Name",
  "location": "City, State",
  "region": "Geographical Region (e.g., North India, South India)",
  "capacity": integer_between_30_and_95,
  "maxCapacity": integer_between_5000_and_15000,
  "currentStock": integer_value_based_on_capacity,
  "primaryCrops": ["Crop1", "Crop2", "Crop3"],
  "coordinates": {"lat": latitude, "lng": longitude},
  "status": "Active" or "Near Capacity" or "Low Stock",
  "manager": "Full Name",
  "phone": "+91 XXXXX XXXXX",
  "lastUpdated": "ISO8601_DateTime_String"
}
Ensure the coordinates are within India.
''';
      final response = await GeminiAIService.generateContent(prompt);
      final jsonStr = _extractJSON(response);
      if (jsonStr.isNotEmpty && mounted) {
        final List<dynamic> data = json.decode(jsonStr);
        setState(() {
          _allWarehouses = data.map((item) {
            var warehouse = Map<String, dynamic>.from(item);
            warehouse['lastUpdated'] = DateTime.tryParse(item['lastUpdated'] ?? '') ?? DateTime.now();
            return warehouse;
          }).toList();
          _filteredWarehouses = List.from(_allWarehouses);
          _selectedWarehouse = _allWarehouses.isNotEmpty ? _allWarehouses.first : null;
        });
      }
    } catch (e) {
      debugPrint('Error fetching warehouse data: $e');
      // Optionally, show an error message to the user
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _extractJSON(String response) {
    final startIndex = response.indexOf('[');
    final endIndex = response.lastIndexOf(']');
    if (startIndex != -1 && endIndex != -1) {
      return response.substring(startIndex, endIndex + 1);
    }
    return '';
  }
  
  void _onSearchChanged() {
    _filterWarehouses();
  }
  
  void _filterWarehouses() {
    setState(() {
      _filteredWarehouses = _allWarehouses.where((warehouse) {
        // Search text filter
        final searchTerm = _searchController.text.toLowerCase();
        final matchesSearch = searchTerm.isEmpty ||
            warehouse['name'].toString().toLowerCase().contains(searchTerm) ||
            warehouse['location'].toString().toLowerCase().contains(searchTerm) ||
            warehouse['region'].toString().toLowerCase().contains(searchTerm) ||
            warehouse['primaryCrops'].any((crop) => 
                crop.toString().toLowerCase().contains(searchTerm));
        
        // Region filter
        final matchesRegion = _selectedRegionFilter == 'All' ||
            warehouse['region'] == _selectedRegionFilter;
        
        // Crop filter
        final matchesCrop = _selectedCropFilter == 'All' ||
            warehouse['primaryCrops'].contains(_selectedCropFilter);
        
        // Capacity filter
        bool matchesCapacity = true;
        if (_selectedCapacityFilter != 'All') {
          final capacity = warehouse['capacity'] as int;
          switch (_selectedCapacityFilter) {
            case 'Low (0-30%)':
              matchesCapacity = capacity <= 30;
              break;
            case 'Medium (31-70%)':
              matchesCapacity = capacity > 30 && capacity <= 70;
              break;
            case 'High (71-100%)':
              matchesCapacity = capacity > 70;
              break;
          }
        }
        
        return matchesSearch && matchesRegion && matchesCrop && matchesCapacity;
      }).toList();
      
      // Update selected warehouse if current one is filtered out
      if (_selectedWarehouse != null && 
          !_filteredWarehouses.contains(_selectedWarehouse)) {
        _selectedWarehouse = _filteredWarehouses.isNotEmpty ? _filteredWarehouses.first : null;
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          // Map Background
          _buildMapBackground(),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Top App Bar
                _buildAppBar(),

                // Search and Filters
                _buildSearchAndFilters(),

                const Spacer(),
              ],
            ),
          ),

          // Floating Action Buttons
          _buildFloatingActionButtons(),

          // Warehouse Info Card (Bottom Sheet)
          _buildWarehouseInfoCard(),
        ],
      ),
    );
  }

  Widget _buildMapBackground() {
    return Positioned.fill(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(20.5937, 78.9629), // Centered on India
          zoom: _currentZoom,
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        markers: _filteredWarehouses.map((warehouse) {
          final coords = warehouse['coordinates'];
          return Marker(
            markerId: MarkerId(warehouse['id']),
            position: LatLng(
              coords['lat'] is double ? coords['lat'] : (coords['lat'] as num).toDouble(),
              coords['lng'] is double ? coords['lng'] : (coords['lng'] as num).toDouble(),
            ),
            infoWindow: InfoWindow(
              title: warehouse['name'],
              snippet: '${warehouse['location']} - Capacity: ${warehouse['capacity']}%',
            ),
            onTap: () {
              setState(() {
                _selectedWarehouse = warehouse;
              });
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _getMarkerHue(warehouse['capacity'] as int),
            ),
          );
        }).toSet(),
      ),
    );
  }

  double _getMarkerHue(int capacity) {
    if (capacity >= 90) return BitmapDescriptor.hueRed;
    if (capacity >= 70) return BitmapDescriptor.hueOrange;
    if (capacity >= 30) return BitmapDescriptor.hueGreen;
    return BitmapDescriptor.hueBlue;
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Menu Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () {
                // Open drawer
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),

          // Title
          const Expanded(
            child: Text(
              'Warehouse Map',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Notifications Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () {
                // Show notifications
              },
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
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
          // Search Bar
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF4B5563),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Search by warehouse, region...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade300,
                  size: 24,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                          _filterWarehouses();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Region', _selectedRegionFilter, _showRegionFilter),
                const SizedBox(width: 10),
                _buildFilterChip('Crop Type', _selectedCropFilter, _showCropFilter),
                const SizedBox(width: 10),
                _buildFilterChip('Capacity', _selectedCapacityFilter, _showCapacityFilter),
                const SizedBox(width: 10),
                _buildResetFiltersButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String currentValue, VoidCallback onTap) {
    final isSelected = currentValue != 'All';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFF374151),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF818CF8) : const Color(0xFF4B5563),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF4F46E5).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.filter_list,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isSelected && currentValue.length > 15 
                  ? '${currentValue.substring(0, 15)}...' 
                  : (isSelected ? currentValue : label),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetFiltersButton() {
    final hasActiveFilters = _selectedRegionFilter != 'All' || 
                           _selectedCropFilter != 'All' || 
                           _selectedCapacityFilter != 'All' ||
                           _searchController.text.isNotEmpty;
    
    if (!hasActiveFilters) return const SizedBox.shrink();
    
    return GestureDetector(
      onTap: _resetFilters,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF87171),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 6),
            Text(
              'Reset',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegionFilter() {
    final regions = ['All', ..._allWarehouses.map((w) => w['region'].toString()).toSet().toList()];
    _showFilterModal('Select Region', regions, _selectedRegionFilter, (value) {
      setState(() {
        _selectedRegionFilter = value;
      });
      _filterWarehouses();
    });
  }

  void _showCropFilter() {
    final crops = ['All', ..._allWarehouses.expand((w) => (w['primaryCrops'] as List).cast<String>()).toSet().toList()];
    _showFilterModal('Select Crop Type', crops, _selectedCropFilter, (value) {
      setState(() {
        _selectedCropFilter = value;
      });
      _filterWarehouses();
    });
  }

  void _showCapacityFilter() {
    final capacities = ['All', 'Low (0-30%)', 'Medium (31-70%)', 'High (71-100%)'];
    _showFilterModal('Select Capacity Range', capacities, _selectedCapacityFilter, (value) {
      setState(() {
        _selectedCapacityFilter = value;
      });
      _filterWarehouses();
    });
  }

  void _showFilterModal(String title, List<String> options, String currentValue, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2937),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 20),
              ...options.map((option) => ListTile(
                title: Text(
                  option,
                  style: const TextStyle(color: Colors.white),
                ),
                leading: Radio<String>(
                  value: option,
                  groupValue: currentValue,
                  onChanged: (value) {
                    if (value != null) {
                      onSelect(value);
                      Navigator.pop(context);
                    }
                  },
                  activeColor: const Color(0xFF4F46E5),
                ),
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedRegionFilter = 'All';
      _selectedCropFilter = 'All';
      _selectedCapacityFilter = 'All';
      _searchController.clear();
    });
    _filterWarehouses();
  }

  Widget _buildFloatingActionButtons() {
    return Positioned(
      bottom: 200,
      right: 16,
      child: Column(
        children: [
          // Warehouse List Toggle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937).withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              onPressed: _showWarehouseList,
              icon: const Icon(
                Icons.list,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(height: 12),

          // Zoom Controls
          Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937).withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _zoomIn,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(
                width: 48,
                height: 1,
                color: Colors.grey.shade700,
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937).withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _zoomOut,
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Location Button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937).withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              onPressed: _centerOnUserLocation,
              icon: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(height: 12),

          // Refresh Button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937).withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              onPressed: _refreshWarehouseData,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _showWarehouseList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2937),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Warehouses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_filteredWarehouses.length} found',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredWarehouses.length,
                itemBuilder: (context, index) {
                  final warehouse = _filteredWarehouses[index];
                  final isSelected = warehouse == _selectedWarehouse;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4F46E5).withOpacity(0.2)
                          : const Color(0xFF0A192F),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4F46E5)
                            : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _selectedWarehouse = warehouse;
                        });
                        Navigator.pop(context);
                      },
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getCapacityColor(warehouse['capacity']).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${warehouse['capacity']}%',
                            style: TextStyle(
                              color: _getCapacityColor(warehouse['capacity']),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        warehouse['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${warehouse['location']} • ${warehouse['status']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showWarehouseDetails(warehouse);
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _zoomIn() {
    if (_mapController != null) {
      _currentZoom = (_currentZoom + 1).clamp(1.0, 20.0);
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          const LatLng(20.5937, 78.9629),
          _currentZoom,
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Zooming in...'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF4F46E5),
      ),
    );
  }

  void _zoomOut() {
    if (_mapController != null) {
      _currentZoom = (_currentZoom - 1).clamp(1.0, 20.0);
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          const LatLng(20.5937, 78.9629),
          _currentZoom,
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Zooming out...'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF4F46E5),
      ),
    );
  }

  void _centerOnUserLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          const LatLng(20.5937, 78.9629), // Default to India center
          5.0,
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centering on India...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _refreshWarehouseData() {
    _fetchWarehouseData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing warehouse data...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildWarehouseInfoCard() {
    if (_selectedWarehouse == null) {
      return const Positioned(
        bottom: 80,
        left: 8,
        right: 8,
        child: Center(
          child: Text(
            'No warehouse selected',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final warehouse = _selectedWarehouse!;
    return Positioned(
      bottom: 80,
      left: 8,
      right: 8,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937).withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ColorFilter.mode(
              Colors.white.withOpacity(0.1),
              BlendMode.srcOver,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Warehouse Header with Status
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    warehouse['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildStatusBadge(warehouse['status']),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              warehouse['location'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${warehouse['id']} • Manager: ${warehouse['manager']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Capacity Circle
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: CircularProgressIndicator(
                                value: warehouse['capacity'] / 100.0,
                                strokeWidth: 4,
                                backgroundColor: const Color(0xFF64FFDA).withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getCapacityColor(warehouse['capacity']),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                '${warehouse['capacity']}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Capacity Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildCapacityInfo(
                          'Current Stock',
                          '${warehouse['currentStock']} tons',
                          Icons.inventory,
                        ),
                      ),
                      Expanded(
                        child: _buildCapacityInfo(
                          'Max Capacity',
                          '${warehouse['maxCapacity']} tons',
                          Icons.warehouse,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Primary Crops
                  const Text(
                    'Primary Crops',
                    style: TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    children: (warehouse['primaryCrops'] as List<String>)
                        .map((crop) => _buildCropChip(crop))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showWarehouseDetails(warehouse),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.visibility, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => _callWarehouse(warehouse['phone']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Icon(Icons.phone, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Active':
        color = Colors.green;
        break;
      case 'Near Capacity':
        color = Colors.orange;
        break;
      case 'Low Stock':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCapacityInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCapacityColor(int capacity) {
    if (capacity >= 90) return Colors.red;
    if (capacity >= 70) return Colors.orange;
    if (capacity >= 30) return Colors.green;
    return Colors.blue;
  }

  void _showWarehouseDetails(Map<String, dynamic> warehouse) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WarehouseDetailsScreen(warehouse: warehouse),
      ),
    );
  }

  void _callWarehouse(String? phone) async {
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number is not available.')),
      );
      return;
    }
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not call $phone')),
      );
    }
  }

  Widget _buildCropChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5).withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4F46E5),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
