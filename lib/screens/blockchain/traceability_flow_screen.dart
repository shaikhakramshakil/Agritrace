import 'package:flutter/material.dart';
import 'package:agritrace/screens/blockchain/batch_details_screen.dart';

class TraceabilityFlowScreen extends StatefulWidget {
  const TraceabilityFlowScreen({super.key});

  @override
  State<TraceabilityFlowScreen> createState() => _TraceabilityFlowScreenState();
}

class _TraceabilityFlowScreenState extends State<TraceabilityFlowScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F2B),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Card
                    _buildHeaderCard(),

                    // Timeline
                    _buildTimeline(),
                  ],
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
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F2B).withOpacity(0.8),
      ),
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
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),

          // Title
          const Expanded(
            child: Text(
              'Traceability Flow',
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

  Widget _buildHeaderCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BatchDetailsScreen()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuA4m8ciMAbfnL0lDRfG-oBaMXDw2AfLNIFjbMMmiqo-mep-68imSvsmKc5S9cTPBpPl_PMmuT107FvSF-AZPGJhdn7iiC6eVEhTkwV4tbfMLmbbGHKScMUpKlM3T7A1m_o9bERVASugPrb30Bldzlmg0tVFvogsUiYO1bINL70frki9LdK_hj2Un0fgswnEU5iaaG3JB43GPV2LlQ8TJbOR9y5dogk-ouYhrhS3KW2saoTFZSEvQrB6gEnjoALpnujEVu8VoPSwSGM',
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 132, 16, 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batch ID: AT-SS-84B10',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Product: Organic Sunflower Seeds',
                  style: TextStyle(
                    color: Color(0xFFE5E5E5),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Origin: Green Valley Farms',
                  style: TextStyle(
                    color: Color(0xFFE5E5E5),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 64),
      child: Column(
        children: [
          _buildTimelineItem(
            icon: Icons.spa,
            iconColor: const Color(0xFF8A2BE2),
            title: 'Planting',
            subtitle: '2023-04-15, Green Valley, Sungold Variety',
            titleColor: const Color(0xFF8A2BE2),
            blockchainHash: '0x4a2e...b8f1',
            isVerified: true,
            showLine: true,
            gradientStart: const Color(0xFF8A2BE2),
            gradientEnd: const Color(0xFF00BFFF),
          ),
          _buildTimelineItem(
            icon: Icons.agriculture,
            iconColor: const Color(0xFF00BFFF),
            title: 'Harvesting',
            subtitle: '2023-08-20, 5 Ton Yield, Grade A',
            titleColor: const Color(0xFF00BFFF),
            blockchainHash: '0x9c3d...a7e2',
            isVerified: true,
            showLine: true,
            gradientStart: const Color(0xFF00BFFF),
            gradientEnd: const Color(0xFF8A2BE2),
          ),
          _buildTimelineItem(
            icon: Icons.factory,
            iconColor: const Color(0xFF8A2BE2),
            title: 'Processing',
            subtitle: 'SunOil Inc, Cold Press, 2023-08-22',
            titleColor: const Color(0xFF8A2BE2),
            blockchainHash: '0x1b8f...c5d3',
            isVerified: true,
            showLine: true,
            gradientStart: const Color(0xFF8A2BE2),
            gradientEnd: const Color(0xFF00BFFF),
          ),
          _buildTimelineItem(
            icon: Icons.inventory_2,
            iconColor: const Color(0xFF00BFFF),
            title: 'Packaging',
            subtitle: '2023-08-25, Glass Bottles, Lot #L9284',
            titleColor: const Color(0xFF00BFFF),
            blockchainHash: '0x7d6a...e9f4',
            isVerified: true,
            showLine: true,
            gradientStart: const Color(0xFF00BFFF),
            gradientEnd: const Color(0xFF8A2BE2),
          ),
          _buildTimelineItem(
            icon: Icons.local_shipping,
            iconColor: const Color(0xFF8A2BE2),
            title: 'Distribution',
            subtitle: 'AgriLogistics, Dep: 08-26 Arr: 08-28',
            titleColor: const Color(0xFF8A2BE2),
            blockchainHash: '0x3f9e...b2a5',
            isVerified: true,
            showLine: true,
            gradientStart: const Color(0xFF8A2BE2),
            gradientEnd: const Color(0xFF00BFFF),
          ),
          _buildTimelineItem(
            icon: Icons.storefront,
            iconColor: const Color(0xFF00BFFF),
            title: 'Retail',
            subtitle: 'Whole Foods, NYC, On-Shelf: 2023-08-30',
            titleColor: const Color(0xFF00BFFF),
            blockchainHash: '0x8a2b...f6e7',
            isVerified: false,
            isConsumerPoint: true,
            showLine: false,
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
    required Color titleColor,
    required String blockchainHash,
    required bool isVerified,
    bool isConsumerPoint = false,
    required bool showLine,
    Color? gradientStart,
    Color? gradientEnd,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          Column(
            children: [
              // Circle Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withOpacity(0.2),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),

              // Connecting Line
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          gradientStart ?? iconColor,
                          gradientEnd ?? iconColor,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32, top: 4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isConsumerPoint
                                ? const Color(0xFFC0C0C0).withOpacity(0.2)
                                : const Color(0xFFFFD700).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isConsumerPoint ? Icons.check_circle : Icons.verified,
                                color: isConsumerPoint
                                    ? const Color(0xFFC0C0C0)
                                    : const Color(0xFFFFD700),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isConsumerPoint ? 'Consumer Point' : 'Verified',
                                style: TextStyle(
                                  color: isConsumerPoint
                                      ? const Color(0xFFC0C0C0)
                                      : const Color(0xFFFFD700),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Blockchain Hash
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.tag,
                            color: Color(0xFF9CA3AF),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              blockchainHash,
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
}
