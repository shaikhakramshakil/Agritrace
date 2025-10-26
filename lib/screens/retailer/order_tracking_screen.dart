import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    this.orderId = 'AGRI-12345',
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  GoogleMapController? _mapController;
  
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

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Map View
                        _buildMapView(),

                        // Current Status Card
                        _buildCurrentStatusCard(),

                        // Timeline
                        _buildTimeline(),

                        // Order Details Accordion
                        _buildOrderDetailsAccordion(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // FAB
            _buildFloatingActionButton(),
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
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              'Order #${widget.orderId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.27,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.2156, 77.4126), // Bhopal, Madhya Pradesh
              zoom: 6,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: {
              // Origin marker (Jaipur Warehouse)
              const Marker(
                markerId: MarkerId('origin'),
                position: LatLng(26.9124, 75.7873), // Jaipur, Rajasthan
                infoWindow: InfoWindow(
                  title: 'जयपुर वेयरहाउस • Jaipur Warehouse',
                  snippet: 'पैकेज उठाया गया • Package picked up',
                ),
                icon: BitmapDescriptor.defaultMarker,
              ),
              // Destination marker (Delhi Store)
              const Marker(
                markerId: MarkerId('destination'),
                position: LatLng(28.6139, 77.2090), // New Delhi
                infoWindow: InfoWindow(
                  title: 'आपका स्टोर, नई दिल्ली • Your Store, New Delhi',
                  snippet: 'डिलीवरी गंतव्य • Delivery destination',
                ),
                icon: BitmapDescriptor.defaultMarker,
              ),
              // Current location marker (Truck near Bhopal)
              Marker(
                markerId: const MarkerId('current'),
                position: const LatLng(23.2156, 77.4126), // Bhopal, MP
                infoWindow: const InfoWindow(
                  title: 'वर्तमान स्थान • Current Location',
                  snippet: 'परिवहन में - 350 किमी बाकी • In transit - 350 km remaining',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFF00B0FF),
                width: 4,
                points: const [
                  LatLng(26.9124, 75.7873), // Jaipur
                  LatLng(26.8467, 75.8061), // Jaipur outskirts
                  LatLng(26.2389, 76.4317), // Dausa
                  LatLng(25.0961, 76.9635), // Gwalior
                  LatLng(24.0734, 77.6865), // Shivpuri
                  LatLng(23.2156, 77.4126), // Bhopal (current)
                  LatLng(24.5854, 77.7970), // Vidisha
                  LatLng(25.4484, 78.5685), // Jhansi
                  LatLng(26.8467, 78.6938), // Agra
                  LatLng(27.5706, 78.0081), // Mathura
                  LatLng(28.6139, 77.2090), // New Delhi
                ],
              ),
            },
            mapType: MapType.normal,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            compassEnabled: true,
            buildingsEnabled: true,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStatusCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A237E).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'वर्तमान स्थिति • CURRENT STATUS',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 14,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00B0FF),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'परिवहन में • In Transit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'मध्य प्रदेश, भोपाल के पास • Near Bhopal, Madhya Pradesh',
              style: TextStyle(
                color: Color(0xFFB0BEC5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFFB0BEC5),
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Text(
                  'अंतिम अपडेट: 5 मिनट पहले • Last updated: 5 mins ago',
                  style: TextStyle(
                    color: Color(0xFFB0BEC5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A4E),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'वाहन विवरण • Vehicle Details',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'ट्रक नंबर • Truck No.',
                            style: TextStyle(
                              color: Color(0xFFB0BEC5),
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'MP 04 AB 1234',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'चालक • Driver',
                            style: TextStyle(
                              color: Color(0xFFB0BEC5),
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'राहुल शर्मा',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'फोन • Phone',
                            style: TextStyle(
                              color: Color(0xFFB0BEC5),
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '+91 98765-43210',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ऑर्डर ट्रैकिंग • Order Tracking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildTimelineItem(
                icon: Icons.check_circle,
                iconColor: const Color(0xFF00B0FF),
                title: 'ऑर्डर प्राप्त • Order Placed',
                subtitle: 'जयपुर, राजस्थान • Jaipur, Rajasthan',
                time: '25 अक्टूबर, सुबह 9:30 • Oct 25, 9:30 AM',
                isCompleted: true,
                isLast: false,
              ),
              _buildTimelineItem(
                icon: Icons.inventory_2,
                iconColor: const Color(0xFF00B0FF),
                title: 'पैकेजिंग पूर्ण • Packaging Complete',
                subtitle: 'जयपुर वेयरहाउस • Jaipur Warehouse',
                time: '25 अक्टूबर, दोपहर 2:15 • Oct 25, 2:15 PM',
                isCompleted: true,
                isLast: false,
              ),
              _buildTimelineItem(
                icon: Icons.local_shipping,
                iconColor: const Color(0xFF00B0FF),
                title: 'परिवहन में • In Transit',
                subtitle: 'भोपाल के पास • Near Bhopal, MP',
                time: '25 अक्टूबर, शाम 6:45 • Oct 25, 6:45 PM',
                isCompleted: true,
                isLast: false,
              ),
              _buildTimelineItem(
                icon: Icons.outbox,
                iconColor: Colors.white.withOpacity(0.5),
                title: 'डिलीवरी के लिए निकला • Out for Delivery',
                subtitle: 'नई दिल्ली • New Delhi',
                time: 'अपेक्षित: 26 अक्टूबर, सुबह 10:00 • Expected: Oct 26, 10:00 AM',
                isCompleted: false,
                isLast: false,
              ),
              _buildTimelineItem(
                icon: Icons.task_alt,
                iconColor: Colors.white.withOpacity(0.5),
                title: 'डिलीवर हो गया • Delivered',
                subtitle: 'आपके स्टोर पर • At Your Store',
                time: 'अपेक्षित: 26 अक्टूबर, दोपहर 2:00 • Expected: Oct 26, 2:00 PM',
                isCompleted: false,
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isCompleted,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isLast)
                  Container(
                    height: 8,
                    width: 1.5,
                    color: isCompleted
                        ? const Color(0xFFB0BEC5)
                        : const Color(0xFFB0BEC5).withOpacity(0.5),
                  ),
                Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: isCompleted
                          ? const Color(0xFFB0BEC5)
                          : const Color(0xFFB0BEC5).withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isCompleted
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isCompleted
                            ? const Color(0xFFB0BEC5)
                            : const Color(0xFFB0BEC5).withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isCompleted
                          ? const Color(0xFF00B0FF)
                          : const Color(0xFFB0BEC5).withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

  Widget _buildOrderDetailsAccordion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          backgroundColor: const Color(0xFF292938),
          collapsedBackgroundColor: const Color(0xFF292938),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text(
            'ऑर्डर विवरण • Order Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.expand_more,
            color: Colors.white,
            size: 20,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('उत्पाद • Product:', 'प्रीमियम सूरजमुखी के बीज • Premium Sunflower Seeds'),
                  const SizedBox(height: 8),
                  _buildDetailRow('मात्रा • Quantity:', '500 किग्रा • 500 kg'),
                  const SizedBox(height: 8),
                  _buildDetailRow('कीमत • Price:', '₹45,000 (₹90/किग्रा • ₹90/kg)'),
                  const SizedBox(height: 8),
                  _buildDetailRow('अपेक्षित डिलीवरी • Est. Delivery:', '26 अक्टूबर, 2025 • Oct 26, 2025'),
                  const SizedBox(height: 8),
                  _buildDetailRow('उत्पत्ति • Origin:', '123 फार्म रोड, जयपुर, राजस्थान • 123 Farm Rd, Jaipur, Rajasthan'),
                  const SizedBox(height: 8),
                  _buildDetailRow('गंतव्य • Destination:', '456 मार्केट स्ट्रीट, नई दिल्ली • 456 Market St, New Delhi'),
                  const SizedBox(height: 8),
                  _buildDetailRow('भुगतान स्थिति • Payment Status:', 'भुगतान हो गया • Paid'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'कृषक विवरण • Farmer Details',
                          style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow('नाम • Name:', 'राजेश कुमार शर्मा • Rajesh Kumar Sharma'),
                        const SizedBox(height: 4),
                        _buildDetailRow('फार्म • Farm:', 'ग्रीन वैली फार्म, जयपुर • Green Valley Farm, Jaipur'),
                        const SizedBox(height: 4),
                        _buildDetailRow('प्रमाणन • Certification:', 'जैविक प्रमाणित • Organic Certified'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Color(0xFFB0BEC5),
          fontSize: 14,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement QR scanner
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('QR स्कैनर यहाँ खुलेगा • QR Scanner will open here'),
                backgroundColor: Color(0xFF00B0FF),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B0FF),
            foregroundColor: const Color(0xFF111121),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            elevation: 8,
            shadowColor: const Color(0xFF00B0FF).withOpacity(0.3),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                color: Color(0xFF111121),
                size: 24,
              ),
              SizedBox(width: 16),
              Text(
                'शिपमेंट सत्यापित करने के लिए स्कैन करें • Scan to Verify Shipment',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
