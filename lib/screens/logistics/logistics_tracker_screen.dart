import 'package:flutter/material.dart';
import 'package:agritrace/widgets/agritrace_logo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LogisticsTrackerScreen extends StatefulWidget {
  const LogisticsTrackerScreen({super.key});

  @override
  State<LogisticsTrackerScreen> createState() => _LogisticsTrackerScreenState();
}

class _LogisticsTrackerScreenState extends State<LogisticsTrackerScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showDriverInfo = false;
  bool _showTimeline = false;
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Column(
        children: [
          // Top App Bar
          SafeArea(child: _buildAppBar()),

          // Alert Banners
          _buildAlertBanners(),

          // Map View with Bottom Sheet
          Expanded(
            child: Stack(
              children: [
                // Map View
                _buildMapView(),

                // Bottom Sheet
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomSheet(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF0D1B2A),
      child: Row(
        children: [
          // Menu Button
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerLeft,
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

          // AgriTrace Logo
          const AgriTraceHeaderLogo(
            height: 28.0,
            iconColor: Color(0xFF00FFFF),
            textColor: Colors.white,
          ),

          // Notifications Button
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerRight,
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

  Widget _buildAlertBanners() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Delay Alert
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFA500).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Color(0xFFFFA500),
                  size: 24,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Potential Delay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'New ETA: 3:15 PM due to traffic congestion.',
                        style: TextStyle(
                          color: Color(0xFFA9A9A9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Spoilage Risk Alert
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4136).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.error,
                  color: Color(0xFFFF4136),
                  size: 24,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spoilage Risk Alert',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Temperature fluctuation detected in container.',
                        style: TextStyle(
                          color: Color(0xFFA9A9A9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        // Google Map Background
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(28.6139, 77.2090), // Delhi, India
            zoom: 14,
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          markers: {
            Marker(
              markerId: const MarkerId('truck'),
              position: const LatLng(28.6139, 77.2090),
              infoWindow: const InfoWindow(
                title: 'Truck TN-23-XY-1234',
                snippet: 'In transit - 45 km/h',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            ),
            const Marker(
              markerId: MarkerId('pickup'),
              position: LatLng(28.5939, 77.1890),
              infoWindow: InfoWindow(
                title: 'Pickup Point',
                snippet: 'Warehouse A',
              ),
            ),
            const Marker(
              markerId: MarkerId('delivery'),
              position: LatLng(28.6339, 77.2290),
              infoWindow: InfoWindow(
                title: 'Delivery Point',
                snippet: 'Store B',
              ),
            ),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              color: const Color(0xFF00FFFF),
              width: 3,
              points: const [
                LatLng(28.5939, 77.1890),
                LatLng(28.6039, 77.1990),
                LatLng(28.6139, 77.2090),
                LatLng(28.6239, 77.2190),
                LatLng(28.6339, 77.2290),
              ],
            ),
          },
          mapType: MapType.normal,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          buildingsEnabled: true,
          trafficEnabled: true,
        ),

        // Search Bar
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search Truck ID...',
                hintStyle: TextStyle(color: Color(0xFFA9A9A9)),
                prefixIcon: Icon(Icons.search, color: Color(0xFFA9A9A9)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),

        // Zoom Controls
        Positioned(
          bottom: 80,
          right: 16,
          child: Column(
            children: [
              // Zoom In
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF1B263B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(
                width: 40,
                height: 1,
                color: const Color(0xFFA9A9A9).withOpacity(0.3),
              ),
              // Zoom Out
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF1B263B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),

        // Navigation Button
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.navigation,
                color: Colors.white,
                size: 20,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B2A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 48,
            height: 6,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFA9A9A9).withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Shipment Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ETA: 2:30 PM',
                            style: TextStyle(
                              color: Color(0xFFA9A9A9),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Shipment ID: AGT-83729',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.015,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.local_shipping,
                      color: Color(0xFF00FFFF),
                      size: 32,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Details
                const Text(
                  'Sunflower Seeds - 50 Tons',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Origin: Farm A | Destination: Warehouse B',
                  style: TextStyle(
                    color: Color(0xFFA9A9A9),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // Progress Bar
                Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Journey Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '75%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1B2A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.75,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FFFF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Accordions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildDriverInfoAccordion(),
                const SizedBox(height: 12),
                _buildTimelineAccordion(),
              ],
            ),
          ),

          // Contact Driver Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calling driver...'),
                      backgroundColor: Color(0xFF1919E6),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1919E6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Contact Driver',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.015,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfoAccordion() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text(
            'Driver Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            _showDriverInfo ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _showDriverInfo = expanded;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBqdb1ygrkXqPku_bF7-CgZRqQ2reXeRouEOTxyF34o3S0RXIgVkeSb5u-tZrB3gYuyJGpbkEhRTNdU0-5_6h9B8-KGwpJsma54yiaKJxbEPbRgmy3HCtZb2V4lozRRvFps6zQffFDUOuEn7PuHMml2UZqsTWzZR5saY_ptr88qAVEMXpWTkIk26uYeFB5hYcvNabh5glXM89tiXuG7ixPiPsuORjo00lTmiN-6zPqlmwz1iRkqmYZgSgLOKhZZKDfmAgI39vnmYII',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey,
                          child: const Icon(Icons.person, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '+1 234 567 890',
                        style: TextStyle(
                          color: Color(0xFFA9A9A9),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Truck Plate: XYZ-123',
                        style: TextStyle(
                          color: Color(0xFFA9A9A9),
                          fontSize: 14,
                        ),
                      ),
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

  Widget _buildTimelineAccordion() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text(
            'Historical Timeline',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            _showTimeline ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _showTimeline = expanded;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _buildTimelineItem(
                    'Departed Origin',
                    'Mon, 10:05 AM',
                    true,
                    false,
                  ),
                  _buildTimelineItem(
                    'Reached Checkpoint Alpha',
                    'Mon, 12:30 PM',
                    true,
                    false,
                  ),
                  _buildTimelineItem(
                    'Arrived at Destination',
                    'Pending',
                    false,
                    true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String time,
    bool isCompleted,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? const Color(0xFF00FFFF)
                      : const Color(0xFFA9A9A9),
                  border: Border.all(
                    color: const Color(0xFF0D1B2A),
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFA9A9A9).withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFFA9A9A9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
