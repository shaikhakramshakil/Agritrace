import 'package:flutter/material.dart';

class BatchDetailsScreen extends StatelessWidget {
  const BatchDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12182B),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Batch ID Card
                      _buildBatchIdCard(),

                      const SizedBox(height: 16),

                      // QR Code Card
                      _buildQRCodeCard(),

                      const SizedBox(height: 16),

                      // Batch Information Section
                      _buildBatchInformation(),

                      const SizedBox(height: 16),

                      // Verification History Section
                      _buildVerificationHistory(),

                      const SizedBox(height: 16),
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

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFB0C4DE),
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),

          // Title
          const Expanded(
            child: Text(
              'Batch Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Spacer for balance
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBatchIdCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A40),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batch ID',
            style: TextStyle(
              color: Color(0xFFB0C4DE),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'A-94B-Z45-C12',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Scan for Quick Access',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 192,
            height: 192,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBKg_yfwrXWCCT1hRTKas3n_p019-6B2F6b2Mfw7AQtiUjBy2vcPR2wl6l5gUW6kUMpQPgkSbI7jrxESIpjdxq_WLZ3DS4CN07dXvqG9Ugqq0E90CZ2HTAy9gjn-swq3cfGG7MAB9JseCP3AC_9ZpuHcVtOPxinlfqlD8jVI1ZSNQp14UlVBL8TyVxZyXV6TgBnzRAEKbw_0TLizxsfMZbYv6h7MwQeXlyn6X6KLQr9qhGaLmm4TXfwQ3pD0rTMPKMCOc9hoisNrno',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.qr_code_2,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Batch Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.015,
            ),
          ),
        ),
        Container(
          color: const Color(0xFF12182B),
          child: Column(
            children: [
              _buildInfoItem(
                icon: Icons.calendar_month,
                text: 'Harvested: Oct 23, 2023 10:00 AM',
              ),
              _buildInfoItem(
                icon: Icons.precision_manufacturing,
                text: 'Processed: Oct 25, 2023 02:30 PM',
              ),
              _buildInfoItem(
                icon: Icons.location_on,
                text: 'Origin: Green Valley Farms',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 56,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF292938),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6A5ACD),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFB0C4DE),
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Verification History on Blockchain',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.015,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              // Vertical Line
              Positioned(
                left: 11,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: const Color(0xFF292938),
                ),
              ),
              // Timeline Items
              Column(
                children: [
                  _buildTimelineItem(
                    title: 'Harvest Verification',
                    txId: 'TxID: 0x1a2b...c3d4',
                    date: 'Oct 23, 2023 10:05 AM',
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    title: 'Processing Verification',
                    txId: 'TxID: 0x5e6f...g7h8',
                    date: 'Oct 25, 2023 02:35 PM',
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    title: 'Quality Check Verification',
                    txId: 'TxID: 0x9i0j...k1l2',
                    date: 'Oct 26, 2023 09:15 AM',
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String txId,
    required String date,
    required bool isLast,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 32, bottom: isLast ? 0 : 32),
      child: Stack(
        children: [
          // Circle with check icon
          Positioned(
            left: -32,
            top: 2,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF6A5ACD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          // Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2A40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  txId,
                  style: const TextStyle(
                    color: Color(0xFFB0C4DE),
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFFB0C4DE),
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
}
