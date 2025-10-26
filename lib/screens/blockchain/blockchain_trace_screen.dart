import 'package:flutter/material.dart';

class BlockchainTraceScreen extends StatefulWidget {
  final String productName;
  final String batchId;

  const BlockchainTraceScreen({
    super.key,
    required this.productName,
    required this.batchId,
  });

  @override
  State<BlockchainTraceScreen> createState() => _BlockchainTraceScreenState();
}

class _BlockchainTraceScreenState extends State<BlockchainTraceScreen> {
  final String transactionHash = '0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0';
  final String blockNumber = '18,452,837';
  final String smartContractAddress = '0x742b70151cd3bc5ab6cbb4e555b44937e2a9eb';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text(
          'ब्लॉकचेन ट्रेसिंग • Blockchain Tracing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Header
              _buildProductHeader(),
              const SizedBox(height: 24),

              // Transaction Overview
              _buildTransactionOverview(),
              const SizedBox(height: 24),

              // Blockchain Timeline
              _buildBlockchainTimeline(),
              const SizedBox(height: 24),

              // Smart Contract Details
              _buildSmartContractDetails(),
              const SizedBox(height: 24),

              // Verification Status
              _buildVerificationStatus(),
              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'बैच आईडी • Batch ID: ${widget.batchId}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'सत्यापित • Verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'लेनदेन अवलोकन • Transaction Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('ट्रांजेक्शन हैश • Transaction Hash:', transactionHash),
          const SizedBox(height: 12),
          _buildInfoRow('ब्लॉक नंबर • Block Number:', blockNumber),
          const SizedBox(height: 12),
          _buildInfoRow('नेटवर्क • Network:', 'Ethereum Mainnet'),
          const SizedBox(height: 12),
          _buildInfoRow('गैस फीस • Gas Fee:', '0.0021 ETH (~₹425)'),
          const SizedBox(height: 12),
          _buildInfoRow('टाइमस्टैम्प • Timestamp:', '25 अक्टूबर 2025, 10:30 AM IST'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SelectableText(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlockchainTimeline() {
    final events = [
      {
        'title': 'उत्पादन • Production',
        'subtitle': 'फार्म से हार्वेस्ट • Harvested from farm',
        'location': 'जयपुर, राजस्थान • Jaipur, Rajasthan',
        'timestamp': '20 अक्टूबर 2025, 8:00 AM',
        'txHash': '0x9f2a...b4c8',
        'status': 'confirmed',
      },
      {
        'title': 'प्रसंस्करण • Processing',
        'subtitle': 'गुणवत्ता जांच पूर्ण • Quality check completed',
        'location': 'जयपुर प्रसंस्करण केंद्र • Jaipur Processing Center',
        'timestamp': '22 अक्टूबर 2025, 2:15 PM',
        'txHash': '0x3d1f...e7a2',
        'status': 'confirmed',
      },
      {
        'title': 'पैकेजिंग • Packaging',
        'subtitle': 'रिटेल के लिए तैयार • Ready for retail',
        'location': 'वेयरहाउस, जयपुर • Warehouse, Jaipur',
        'timestamp': '23 अक्टूबर 2025, 11:30 AM',
        'txHash': '0x7e5b...c9d1',
        'status': 'confirmed',
      },
      {
        'title': 'शिपमेंट • Shipment',
        'subtitle': 'ट्रांजिट में • In transit',
        'location': 'भोपाल, मध्य प्रदेश • Bhopal, Madhya Pradesh',
        'timestamp': '24 अक्टूबर 2025, 6:45 PM',
        'txHash': '0x2c4a...f3e7',
        'status': 'pending',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ब्लॉकचेन टाइमलाइन • Blockchain Timeline',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...events.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            final isLast = index == events.length - 1;
            return _buildTimelineEvent(event, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineEvent(Map<String, dynamic> event, bool isLast) {
    final isConfirmed = event['status'] == 'confirmed';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isConfirmed ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isConfirmed ? const Color(0xFF66BB6A) : const Color(0xFFFFB74D),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isConfirmed ? Icons.check : Icons.access_time,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFF2A2A4E),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Event content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['subtitle'],
                    style: const TextStyle(
                      color: Color(0xFFB0BEC5),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['location'],
                    style: const TextStyle(
                      color: Color(0xFF9C27B0),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: isConfirmed ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event['timestamp'],
                        style: TextStyle(
                          color: isConfirmed ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.link,
                        color: Color(0xFF00B0FF),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'TX: ${event['txHash']}',
                        style: const TextStyle(
                          color: Color(0xFF00B0FF),
                          fontSize: 12,
                          fontFamily: 'monospace',
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

  Widget _buildSmartContractDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'स्मार्ट कॉन्ट्रैक्ट विवरण • Smart Contract Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('कॉन्ट्रैक्ट पता • Contract Address:', smartContractAddress),
          const SizedBox(height: 12),
          _buildInfoRow('कॉन्ट्रैक्ट नाम • Contract Name:', 'AgriTrace Supply Chain'),
          const SizedBox(height: 12),
          _buildInfoRow('संस्करण • Version:', 'v2.1.0'),
          const SizedBox(height: 12),
          _buildInfoRow('डेवलपर • Developer:', 'AgriTrace Foundation'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A4E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.security,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'सत्यापित और ऑडिट किया गया • Verified & Audited',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 14,
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

  Widget _buildVerificationStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'सत्यापन स्थिति • Verification Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard('ब्लॉकचेन • Blockchain', 'सत्यापित • Verified', Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard('गुणवत्ता • Quality', 'पास • Passed', Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard('प्रामाणिकता • Authenticity', '100%', Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard('ट्रेसेबिलिटी • Traceability', 'पूर्ण • Complete', Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Etherscan में खुल रहा है • Opening in Etherscan'),
                      backgroundColor: Color(0xFF00B0FF),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Etherscan में देखें • View on Etherscan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00B0FF),
                  side: const BorderSide(color: Color(0xFF00B0FF)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('रिपोर्ट डाउनलोड हो रही है • Downloading report'),
                      backgroundColor: Color(0xFF4CAF50),
                    ),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('रिपोर्ट डाउनलोड करें • Download Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('रिपोर्ट साझा की जा रही है • Sharing report'),
                      backgroundColor: Color(0xFF9C27B0),
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('साझा करें • Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}