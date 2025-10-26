import 'package:flutter/material.dart';
import 'dart:math' as math;

class InsuranceCreditScreen extends StatefulWidget {
  const InsuranceCreditScreen({super.key});

  @override
  State<InsuranceCreditScreen> createState() => _InsuranceCreditScreenState();
}

class _InsuranceCreditScreenState extends State<InsuranceCreditScreen> {
  bool _isCreditView = true;
  // filter selections
  final Map<String, String> _filterValues = {};

  // simple in-memory applications list
  final List<Map<String, dynamic>> _applications = [
    {
      'id': DateTime(2023, 10, 15).millisecondsSinceEpoch.toString(),
      'title': 'Short-Term Crop Loan',
      'provider': 'AgriBank',
      'submittedOn': DateTime(2023, 10, 15),
      'status': 'Under Review',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                _buildHeader(),

                // Toggle Buttons
                _buildToggle(),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AI Risk Rating Card
                        _buildRiskRatingCard(),

                        // Filter Chips
                        _buildFilterChips(),

                        // Option Cards
                        _buildOptionCards(),

                        // Application Status
                        _buildApplicationStatus(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating Action Button
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: Add new application
                },
                backgroundColor: const Color(0xFF4A0D66),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
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
              'Insurance & Credit',
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
                // TODO: Show help
              },
              icon: const Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1C2A3A),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isCreditView = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isCreditView ? const Color(0xFF4A0D66) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _isCreditView
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4A0D66).withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Credit Options',
                    style: TextStyle(
                      color: _isCreditView ? Colors.white : const Color(0xFFB0B0B0),
                      fontSize: 16,
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
                    _isCreditView = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: !_isCreditView ? const Color(0xFF4A0D66) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: !_isCreditView
                        ? [
                            BoxShadow(
                              color: const Color(0xFF4A0D66).withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Insurance Schemes',
                    style: TextStyle(
                      color: !_isCreditView ? Colors.white : const Color(0xFFB0B0B0),
                      fontSize: 16,
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

  Widget _buildRiskRatingCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1C2A3A),
              Color(0xFF25103A),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Your AI-Powered Risk Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: 0.75,
                      backgroundColor: const Color(0xFF1C2A3A),
                      progressColor: const Color(0xFF28A745),
                    ),
                  ),
                ),
                Column(
                  children: const [
                    Text(
                      '75',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/ 100',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _showRiskDetails,
              child: const Text(
                'Low Risk',
                style: TextStyle(
                  color: Color(0xFF28A745),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our AI analyzes your farm\'s data to provide a risk score, which may affect your loan and insurance eligibility.',
              style: TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip('Provider'),
          _buildFilterChip('Loan Type'),
          _buildFilterChip('Coverage Amount'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final value = _filterValues[label];

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => _showFilterOptions(label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2A3A),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label + (value != null ? ': ' : ''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: 6),
                Text(
                  value,
                  style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 13),
                ),
              ],
              const SizedBox(width: 6),
              const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(String filter) {
    final options = <String>[];
    if (filter == 'Provider') {
      options.addAll(['AgriBank', 'FarmCredit', 'Co-op Lenders']);
    } else if (filter == 'Loan Type') {
      options.addAll(['Short Term', 'Equipment', 'Seasonal']);
    } else if (filter == 'Coverage Amount') {
      options.addAll(['< 10,000', '10,000 - 50,000', '> 50,000']);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Choose $filter', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    ...options.map((o) => ListTile(
                          title: Text(o, style: const TextStyle(color: Colors.white)),
                          onTap: () {
                            setState(() {
                              _filterValues[filter] = o;
                            });
                            Navigator.of(ctx).pop();
                          },
                        )),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionCards() {
    if (_isCreditView) {
      return _buildCreditOptions();
    } else {
      return _buildInsuranceSchemes();
    }
  }

  Widget _buildCreditOptions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCreditCard(
            title: 'AgriGrowth Loan',
            provider: 'by AgriBank',
            details: [
              'Interest Rate: 5-8%',
              'Max Loan: ₹40,00,000',
              'Tenure: 12-36 months',
            ],
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 16),
          _buildCreditCard(
            title: 'Equipment Financing',
            provider: 'by FarmCredit',
            details: [
              'Interest Rate: 4.5-7%',
              'Max Loan: ₹80,00,000',
              'Tenure: 24-60 months',
            ],
            icon: Icons.agriculture,
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceSchemes() {
    final schemes = _getIndianInsuranceSchemes();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: schemes.map((scheme) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildInsuranceCard(scheme),
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getIndianInsuranceSchemes() {
    return [
      {
        'id': 'pmfby',
        'name': 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
        'provider': 'Government of India',
        'icon': Icons.shield,
        'color': const Color(0xFF10B981),
        'premium': '₹900 - ₹2,000 per acre',
        'coverage': 'Up to ₹50,000 per hectare',
        'crops': ['Wheat', 'Rice', 'Cotton', 'Sugarcane', 'Pulses'],
        'description': 'Comprehensive risk insurance covering yield loss due to non-preventable natural risks',
        'benefits': [
          'Premium subsidy: 50% for farmers',
          'Covers all stages from sowing to post-harvest',
          'Quick claim settlement within 2 months',
          'Coverage against natural calamities, pests & diseases',
        ],
        'eligibility': [
          'All farmers (Loanee & Non-Loanee)',
          'Sharecroppers & tenant farmers eligible',
          'Must have insurable interest in the crop',
        ],
        'documents': [
          'Aadhaar Card',
          'Land ownership documents / Tenancy agreement',
          'Bank account details',
          'Crop sowing certificate',
        ],
      },
      {
        'id': 'wbcis',
        'name': 'Weather Based Crop Insurance Scheme (WBCIS)',
        'provider': 'Government of India',
        'icon': Icons.wb_sunny,
        'color': const Color(0xFFF59E0B),
        'premium': '₹500 - ₹1,500 per acre',
        'coverage': 'Up to ₹30,000 per hectare',
        'crops': ['Bajra', 'Maize', 'Groundnut', 'Soybean', 'Millets'],
        'description': 'Insurance against adverse weather conditions affecting crop yields',
        'benefits': [
          'Coverage for rainfall, temperature, humidity',
          'Quick payout based on weather data',
          'No crop cutting experiments required',
          'Government subsidized premiums',
        ],
        'eligibility': [
          'All farmers growing notified crops',
          'Must be in notified areas',
          'Individual or group policies available',
        ],
        'documents': [
          'Aadhaar Card',
          'Land records / Lease agreement',
          'Bank account details',
          'Previous season yield records',
        ],
      },
      {
        'id': 'cis',
        'name': 'Coconut Palm Insurance Scheme (CPIS)',
        'provider': 'Coconut Development Board',
        'icon': Icons.park,
        'color': const Color(0xFF8B4513),
        'premium': '₹9 per palm per year',
        'coverage': '₹900 per palm',
        'crops': ['Coconut'],
        'description': 'Special insurance for coconut growers against natural and man-made risks',
        'benefits': [
          'Coverage for fire, lightning, earthquake',
          'Protection against floods and cyclones',
          'Very low premium rate',
          '75% premium subsidy for small farmers',
        ],
        'eligibility': [
          'Coconut growers with 1-50 palms',
          'Palms aged 4-60 years',
          'Must be in good health',
        ],
        'documents': [
          'Ownership proof of coconut garden',
          'Survey sketch of plantation',
          'Bank account details',
          'Previous insurance details (if any)',
        ],
      },
      {
        'id': 'mnais',
        'name': 'Modified National Agricultural Insurance Scheme',
        'provider': 'Ministry of Agriculture',
        'icon': Icons.inventory,
        'color': const Color(0xFF3B82F6),
        'premium': '₹1,000 - ₹3,000 per acre',
        'coverage': 'Up to ₹70,000 per hectare',
        'crops': ['All Food Crops', 'Oilseeds', 'Commercial Crops'],
        'description': 'Enhanced crop insurance with better claim settlement and coverage',
        'benefits': [
          'On-account payment up to 25%',
          'Individual farm level assessment option',
          'Coverage from sowing to harvesting',
          'Post-harvest coverage up to 14 days',
        ],
        'eligibility': [
          'All farmers including tenant farmers',
          'Must cultivate notified crops',
          'Land should be in notified area',
        ],
        'documents': [
          'Aadhaar Card & PAN Card',
          'Land documents / 7/12 extract',
          'Bank passbook',
          'Crop declaration form',
        ],
      },
    ];
  }

  Widget _buildOptionCard({
    required String title,
    required String provider,
    required List<String> details,
    required String logoUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2A3A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFF2A3A4A),
                  child: Image.network(
                    logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.account_balance,
                        color: Color(0xFFB0B0B0),
                        size: 24,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                    Text(
                      provider,
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...details.map((detail) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 6,
                    color: Color(0xFFB0B0B0),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showApplicationForm(title: title, provider: provider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A0D66),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Apply Now',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard({
    required String title,
    required String provider,
    required List<String> details,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2A3A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A0D66).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF4A0D66),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
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
                    Text(
                      provider,
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...details.map((detail) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showCreditApplicationForm(title: title, provider: provider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A0D66),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceCard(Map<String, dynamic> scheme) {
    return GestureDetector(
      onTap: () => _showInsuranceDetails(scheme),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1C2A3A),
              (scheme['color'] as Color).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (scheme['color'] as Color).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (scheme['color'] as Color).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    scheme['icon'] as IconData,
                    color: scheme['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheme['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scheme['provider'],
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Premium',
                          style: TextStyle(
                            color: Color(0xFFB0B0B0),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scheme['premium'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: const Color(0xFF374151),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coverage',
                          style: TextStyle(
                            color: Color(0xFFB0B0B0),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scheme['coverage'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              scheme['description'],
              style: const TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showInsuranceDetails(scheme),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme['color'] as Color,
                      side: BorderSide(color: scheme['color'] as Color),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showInsuranceApplicationForm(scheme),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme['color'] as Color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply Now',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatus() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Applications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_applications.isEmpty)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C2A3A),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Column(
                  children: const [
                    Icon(Icons.history, color: Color(0xFFB0B0B0), size: 48),
                    SizedBox(height: 12),
                    Text(
                      'No applications yet',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your credit and insurance applications will appear here',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._applications.map((app) {
              final submitted = app['submittedOn'] as DateTime;
              final status = app['status'] as String;
              final type = app['type'] as String? ?? 'Credit';
              final isInsurance = type == 'Insurance';
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2A3A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isInsurance 
                        ? const Color(0xFF10B981).withOpacity(0.3)
                        : const Color(0xFF4A0D66).withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isInsurance 
                                ? const Color(0xFF10B981).withOpacity(0.2)
                                : const Color(0xFF4A0D66).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isInsurance ? Icons.shield : Icons.account_balance,
                                size: 14,
                                color: isInsurance ? const Color(0xFF10B981) : const Color(0xFF4A0D66),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                type,
                                style: TextStyle(
                                  color: isInsurance ? const Color(0xFF10B981) : const Color(0xFF4A0D66),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: _getStatusColor(status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      app['title'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      app['provider'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Submitted on ${submitted.day} ${_monthName(submitted.month)} ${submitted.year}',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: _getProgressValue(status),
                        backgroundColor: const Color(0xFF0D1B2A),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isInsurance ? const Color(0xFF10B981) : const Color(0xFF4A0D66),
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Submitted',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'Review',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'Approved',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Submitted':
        return const Color(0xFF3B82F6);
      case 'Under Review':
        return const Color(0xFFF59E0B);
      case 'Approved':
        return const Color(0xFF10B981);
      case 'Rejected':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  double _getProgressValue(String status) {
    switch (status) {
      case 'Submitted':
        return 0.33;
      case 'Under Review':
        return 0.66;
      case 'Approved':
        return 1.0;
      default:
        return 0.0;
    }
  }

  String _monthName(int month) {
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return names[month - 1];
  }

  void _showRiskDetails() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text('Risk Analysis', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Your risk score is calculated from historical yields, weather stability and input usage. A lower score improves your loan terms and insurance premiums.',
          style: TextStyle(color: Color(0xFFB0B0B0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showApplicationForm({required String title, required String provider}) {
    final _formKey = GlobalKey<FormState>();
    String crop = '';
    String amount = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D1B2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apply for $title', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(labelText: 'Crop', labelStyle: TextStyle(color: Color(0xFFB0B0B0))),
                          onSaved: (v) => crop = v ?? '',
                          validator: (v) => (v == null || v.isEmpty) ? 'Please enter crop' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(labelText: 'Amount', labelStyle: TextStyle(color: Color(0xFFB0B0B0))),
                          keyboardType: TextInputType.number,
                          onSaved: (v) => amount = v ?? '',
                          validator: (v) => (v == null || v.isEmpty) ? 'Please enter amount' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    _formKey.currentState?.save();
                                    _submitApplication(title: title, provider: provider, crop: crop, amount: amount);
                                    Navigator.of(ctx).pop();
                                  }
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A0D66)),
                                child: const Text('Submit Application'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCreditApplicationForm({required String title, required String provider}) {
    _showApplicationForm(title: title, provider: provider);
  }

  void _showInsuranceDetails(Map<String, dynamic> scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF0D1B2A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (scheme['color'] as Color).withOpacity(0.2),
                      const Color(0xFF0D1B2A),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: (scheme['color'] as Color).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: scheme['color'] as Color,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        scheme['icon'] as IconData,
                        color: scheme['color'] as Color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            scheme['provider'],
                            style: const TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Premium & Coverage
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoBox('Premium', scheme['premium']),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoBox('Coverage', scheme['coverage']),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Description
                      const Text(
                        'About',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        scheme['description'],
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Covered Crops
                      const Text(
                        'Covered Crops',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (scheme['crops'] as List<String>).map((crop) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: (scheme['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: (scheme['color'] as Color).withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              crop,
                              style: TextStyle(
                                color: scheme['color'] as Color,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      // Benefits
                      const Text(
                        'Key Benefits',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(scheme['benefits'] as List<String>).map((benefit) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: scheme['color'] as Color,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: const TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                      // Eligibility
                      const Text(
                        'Eligibility Criteria',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(scheme['eligibility'] as List<String>).map((criterion) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: scheme['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  criterion,
                                  style: const TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                      // Required Documents
                      const Text(
                        'Required Documents',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(scheme['documents'] as List<String>).map((doc) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2A3A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF374151),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: scheme['color'] as Color,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  doc,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // Apply Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B2A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showInsuranceApplicationForm(scheme);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme['color'] as Color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply for This Scheme',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2A3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF374151),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showInsuranceApplicationForm(Map<String, dynamic> scheme) {
    final _formKey = GlobalKey<FormState>();
    String farmerName = '';
    String mobile = '';
    String aadhaar = '';
    String landArea = '';
    String selectedCrop = (scheme['crops'] as List<String>).first;
    String season = 'Kharif';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFF0D1B2A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                        Expanded(
                          child: Text(
                            'Apply for ${scheme['name']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF374151)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: scheme['color'] as Color),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1C2A3A),
                              ),
                              onSaved: (v) => farmerName = v ?? '',
                              validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF374151)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: scheme['color'] as Color),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1C2A3A),
                              ),
                              keyboardType: TextInputType.phone,
                              onSaved: (v) => mobile = v ?? '',
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Please enter mobile number';
                                if (v.length != 10) return 'Mobile number must be 10 digits';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Aadhaar Number',
                                labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF374151)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: scheme['color'] as Color),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1C2A3A),
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (v) => aadhaar = v ?? '',
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Please enter Aadhaar number';
                                if (v.length != 12) return 'Aadhaar must be 12 digits';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Farm Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Land Area (in acres)',
                                labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF374151)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: scheme['color'] as Color),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1C2A3A),
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onSaved: (v) => landArea = v ?? '',
                              validator: (v) => (v == null || v.isEmpty) ? 'Please enter land area' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedCrop,
                              dropdownColor: const Color(0xFF1C2A3A),
                              decoration: InputDecoration(
                                labelText: 'Select Crop',
                                labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF374151)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: scheme['color'] as Color),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1C2A3A),
                              ),
                              style: const TextStyle(color: Colors.white),
                              items: (scheme['crops'] as List<String>).map((crop) {
                                return DropdownMenuItem(
                                  value: crop,
                                  child: Text(crop),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  selectedCrop = value!;
                                });
                              },
                              onSaved: (v) => selectedCrop = v ?? selectedCrop,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: season,
                              dropdownColor: const Color(0xFF1C2A3A),
                              decoration: InputDecoration(
                                labelText: 'Season',
                                labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFF374151)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: scheme['color'] as Color),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF1C2A3A),
                              ),
                              style: const TextStyle(color: Colors.white),
                              items: ['Kharif', 'Rabi', 'Zaid'].map((s) {
                                return DropdownMenuItem(
                                  value: s,
                                  child: Text(s),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  season = value!;
                                });
                              },
                              onSaved: (v) => season = v ?? season,
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: (scheme['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (scheme['color'] as Color).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: scheme['color'] as Color,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Your application will be processed within 3-5 working days.',
                                      style: TextStyle(
                                        color: Color(0xFFB0B0B0),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    _formKey.currentState?.save();
                                    _submitInsuranceApplication(
                                      scheme: scheme,
                                      farmerName: farmerName,
                                      mobile: mobile,
                                      aadhaar: aadhaar,
                                      landArea: landArea,
                                      crop: selectedCrop,
                                      season: season,
                                    );
                                    Navigator.of(ctx).pop();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: scheme['color'] as Color,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Submit Application',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submitApplication({required String title, required String provider, required String crop, required String amount}) {
    setState(() {
      _applications.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'provider': provider,
        'submittedOn': DateTime.now(),
        'status': 'Submitted',
        'type': 'Credit',
        'meta': {'crop': crop, 'amount': amount},
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Credit application submitted successfully!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _submitInsuranceApplication({
    required Map<String, dynamic> scheme,
    required String farmerName,
    required String mobile,
    required String aadhaar,
    required String landArea,
    required String crop,
    required String season,
  }) {
    setState(() {
      _applications.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': scheme['name'],
        'provider': scheme['provider'],
        'submittedOn': DateTime.now(),
        'status': 'Submitted',
        'type': 'Insurance',
        'meta': {
          'farmerName': farmerName,
          'mobile': mobile,
          'aadhaar': aadhaar,
          'landArea': landArea,
          'crop': crop,
          'season': season,
          'premium': scheme['premium'],
          'coverage': scheme['coverage'],
        },
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Application Submitted!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your insurance application has been received',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: scheme['color'] as Color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
