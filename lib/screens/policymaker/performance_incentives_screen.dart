import 'package:flutter/material.dart';
import 'package:agritrace/services/gemini_ai_service.dart';
import 'dart:convert';

class PerformanceIncentivesScreen extends StatefulWidget {
  const PerformanceIncentivesScreen({super.key});

  @override
  State<PerformanceIncentivesScreen> createState() =>
      _PerformanceIncentivesScreenState();
}

class _PerformanceIncentivesScreenState
    extends State<PerformanceIncentivesScreen> {
  bool _isLoadingAIRecommendations = false;
  List<Map<String, dynamic>> _aiRecommendations = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAIRecommendations();
  }

  Future<void> _loadAIRecommendations() async {
    setState(() {
      _isLoadingAIRecommendations = true;
      _errorMessage = '';
    });

    try {
      // Generate AI subsidy recommendations using Gemini
      final recommendations = await _generateSubsidyRecommendations();
      
      if (!mounted) return; // Check if widget is still mounted
      
      setState(() {
        _aiRecommendations = recommendations;
        _isLoadingAIRecommendations = false;
      });
    } catch (e) {
      if (!mounted) return; // Check before setState
      
      setState(() {
        _errorMessage = 'Failed to load AI recommendations: ${e.toString()}';
        _isLoadingAIRecommendations = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _generateSubsidyRecommendations() async {
    final prompt = '''
    You are an expert agricultural policy analyst. Generate 3 specific subsidy recommendations for farmers based on current agricultural data and trends.
    
    Return a JSON array with exactly 3 recommendations, each following this structure (return ONLY valid JSON, no markdown):
    [
      {
        "title": "Subsidy program name",
        "description": "Brief description of the subsidy",
        "eligibility": "Who can apply",
        "amount": "Financial amount or percentage",
        "deadline": "Application deadline",
        "priority": "HIGH, MEDIUM, or LOW",
        "region": "Target region or nationwide",
        "cropType": "Applicable crops or ALL",
        "estimatedImpact": "Expected positive outcome"
      }
    ]
    
    Focus on realistic, actionable subsidies that would benefit farmers in different regions and crop types.
    ''';

    try {
      final response = await GeminiAIService.generateContent(prompt);
      String jsonString = response.trim();
      
      // Clean up the response to extract JSON
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.startsWith('```')) {
        jsonString = jsonString.substring(3);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      
      // Parse the JSON response
      final List<dynamic> jsonData = jsonDecode(jsonString.trim());
      return jsonData.cast<Map<String, dynamic>>();
    } catch (e) {
      // Return fallback data if API fails
      return [
        {
          "title": "Precision Agriculture Tech Subsidy",
          "description": "Support for GPS-guided tractors, soil sensors, and drone technology",
          "eligibility": "Farms 20+ hectares with annual revenue under ₹4 Cr",
          "amount": "Up to 70% of equipment cost (max ₹40,00,000)",
          "deadline": "December 31, 2024",
          "priority": "HIGH",
          "region": "Punjab, Haryana, Uttar Pradesh",
          "cropType": "Wheat, Rice, Sugarcane",
          "estimatedImpact": "15-25% increase in yield efficiency"
        },
        {
          "title": "Sustainable Water Management Grant",
          "description": "Funding for drip irrigation systems and water conservation technology",
          "eligibility": "Small to medium farms in drought-prone areas",
          "amount": "60% cost coverage (max ₹25,00,000)",
          "deadline": "March 15, 2025",
          "priority": "MEDIUM",
          "region": "Maharashtra, Karnataka, Rajasthan",
          "cropType": "Cotton, Vegetables, Fruits",
          "estimatedImpact": "30-40% reduction in water usage"
        },
        {
          "title": "Organic Transition Support Program",
          "description": "Financial assistance during 3-year organic certification transition",
          "eligibility": "Conventional farms transitioning to organic",
          "amount": "₹12,000 per hectare annually for 3 years",
          "deadline": "June 30, 2025",
          "priority": "MEDIUM",
          "region": "Nationwide",
          "cropType": "ALL",
          "estimatedImpact": "Access to premium organic markets"
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // KPI Cards
                      _buildKPICards(),

                      const SizedBox(height: 32),

                      // Performance Trends Section
                      const Text(
                        'Performance Trends',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _buildCreditDisbursementCard(),

                      const SizedBox(height: 16),

                      // AI Subsidy Recommendations
                      _buildAISubsidyCard(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Logo and Title
          const Icon(
            Icons.agriculture,
            color: Color(0xFF4A90E2),
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text(
            'AgriTrace',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // Center Title
          const Expanded(
            flex: 2,
            child: Text(
              'Performance & Incentives',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          // Profile Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () {
                // Navigate to profile
              },
              icon: const Icon(
                Icons.person,
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

  Widget _buildKPICards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Performance Indicators',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              // Determine number of columns based on screen width
              int crossAxisCount = 2;
              if (constraints.maxWidth > 1200) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth > 800) {
                crossAxisCount = 3;
              }

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildKPICard(
                    'Total Farmers',
                    '2,847',
                    Icons.people,
                    Colors.blue,
                    '+12% this month',
                  ),
                  _buildKPICard(
                    'Crop Yield',
                    '18.5 tons/ha',
                    Icons.agriculture,
                    Colors.green,
                    '+8.3% vs last year',
                  ),
                  _buildKPICard(
                    'Revenue Generated',
                    '₹45.2M',
                    Icons.currency_rupee,
                    Colors.orange,
                    '+15.7% growth',
                  ),
                  _buildKPICard(
                    'Sustainability Score',
                    '87%',
                    Icons.eco,
                    Colors.teal,
                    '+5 points',
                  ),
                  _buildKPICard(
                    'Market Efficiency',
                    '92.3%',
                    Icons.trending_up,
                    Colors.purple,
                    '+3.1% improvement',
                  ),
                  _buildKPICard(
                    'Quality Rating',
                    '4.8/5',
                    Icons.star,
                    Colors.amber,
                    'Excellent standard',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: color,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditDisbursementCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B3A),
        border: Border.all(
          color: const Color(0xFF4A90E2).withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Credit Disbursement',
                style: TextStyle(
                  color: Color(0xFFF0F0F0),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Last updated: 2 mins ago',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.expand_more,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Value
          const Text(
            '₹96 Cr',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 4),

          // Period and Change
          const Row(
            children: [
              Text(
                'Last 6 Months',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '+15%',
                style: TextStyle(
                  color: Color(0xFF0BDA68),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Chart
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _PerformanceChartPainter(),
              size: const Size(double.infinity, 148),
            ),
          ),

          const SizedBox(height: 16),

          // Month Labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Jan',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
              ),
              Text(
                'Feb',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
              ),
              Text(
                'Mar',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
              ),
              Text(
                'Apr',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
              ),
              Text(
                'May',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
              ),
              Text(
                'Jun',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.015,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAISubsidyCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple[700]!,
            Colors.blue[600]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Subsidy Recommendations',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Powered by Gemini AI for optimal policy decisions',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _loadAIRecommendations,
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          // Content Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: _isLoadingAIRecommendations
                ? _buildLoadingState()
                : _errorMessage.isNotEmpty
                    ? _buildErrorState()
                    : _buildRecommendationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Generating AI recommendations...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white.withOpacity(0.8),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAIRecommendations,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple[700],
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsList() {
    if (_aiRecommendations.isEmpty) {
      return Container(
        height: 200,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.white70,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No recommendations available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_aiRecommendations.length} Recommendations',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => _showAllRecommendations(),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate card width based on available space
              double cardWidth = constraints.maxWidth > 600 ? 280 : constraints.maxWidth * 0.8;
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _aiRecommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = _aiRecommendations[index];
                  return Container(
                    width: cardWidth,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(recommendation['priority']),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              recommendation['priority'] ?? 'MEDIUM',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            recommendation['amount'] ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      recommendation['title'] ?? 'Unknown Subsidy',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Text(
                        recommendation['description'] ?? 'No description available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white.withOpacity(0.7),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            recommendation['deadline'] ?? 'No deadline',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
            },
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toUpperCase()) {
      case 'HIGH':
        return Colors.red[600]!;
      case 'MEDIUM':
        return Colors.orange[600]!;
      case 'LOW':
        return Colors.green[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  void _showAllRecommendations() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[700]!, Colors.blue[600]!],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Text(
                    'AI Subsidy Recommendations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _aiRecommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = _aiRecommendations[index];
                  return _buildDetailedRecommendationCard(recommendation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedRecommendationCard(Map<String, dynamic> recommendation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(recommendation['priority']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    recommendation['priority'] ?? 'MEDIUM',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    recommendation['amount'] ?? 'N/A',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.green[100],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              recommendation['title'] ?? 'Unknown Subsidy',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recommendation['description'] ?? 'No description available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Eligibility', recommendation['eligibility']),
            _buildDetailRow('Region', recommendation['region']),
            _buildDetailRow('Crop Type', recommendation['cropType']),
            _buildDetailRow('Deadline', recommendation['deadline']),
            _buildDetailRow('Expected Impact', recommendation['estimatedImpact']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not specified',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B3A),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF4A90E2).withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard, 'Dashboard', 0, true),
              _buildNavItem(Icons.analytics, 'Analytics', 1, false),
              _buildNavItem(Icons.description, 'Reports', 2, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          // Navigate back to dashboard
          Navigator.pop(context);
        } else if (index == 1) {
          // Show Analytics
          _showAnalyticsView();
        } else if (index == 2) {
          // Show Reports
          _showReportsView();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF8A2BE2) : const Color(0xFF4A90E2),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF8A2BE2) : const Color(0xFF4A90E2),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showAnalyticsView() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Performance Analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildAnalyticsCard(
                      'Total Subsidies Allocated',
                      '₹96 Cr',
                      '+15.2%',
                      Colors.green,
                      Icons.trending_up,
                    ),
                    const SizedBox(height: 16),
                    _buildAnalyticsCard(
                      'Farms Benefited',
                      '12,450',
                      '+8.7%',
                      Colors.blue,
                      Icons.agriculture,
                    ),
                    const SizedBox(height: 16),
                    _buildAnalyticsCard(
                      'Average Processing Time',
                      '14 days',
                      '-12.3%',
                      Colors.orange,
                      Icons.schedule,
                    ),
                    const SizedBox(height: 16),
                    _buildAnalyticsCard(
                      'Success Rate',
                      '87.5%',
                      '+5.1%',
                      Colors.purple,
                      Icons.check_circle,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Regional Distribution',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRegionalBar('Punjab', 0.85, Colors.blue),
                    const SizedBox(height: 12),
                    _buildRegionalBar('Haryana', 0.72, Colors.green),
                    const SizedBox(height: 12),
                    _buildRegionalBar('Uttar Pradesh', 0.68, Colors.orange),
                    const SizedBox(height: 12),
                    _buildRegionalBar('Maharashtra', 0.55, Colors.purple),
                    const SizedBox(height: 12),
                    _buildRegionalBar('Karnataka', 0.48, Colors.pink),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    String change,
    Color color,
    IconData icon,
  ) {
    final isPositive = change.startsWith('+') || change.startsWith('-') && change.contains('-12');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalBar(String region, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              region,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  void _showReportsView() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subsidy Reports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildReportCard(
                      'Annual Performance Report 2024',
                      'Complete overview of subsidy distribution and impact',
                      'PDF • 2.4 MB',
                      'December 15, 2024',
                      Icons.picture_as_pdf,
                      Colors.red,
                    ),
                    const SizedBox(height: 16),
                    _buildReportCard(
                      'Q4 2024 Analytics Summary',
                      'Quarterly performance metrics and trends',
                      'PDF • 1.8 MB',
                      'October 1, 2024',
                      Icons.analytics,
                      Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    _buildReportCard(
                      'Regional Impact Assessment',
                      'State-wise subsidy utilization and farmer benefits',
                      'XLSX • 856 KB',
                      'September 20, 2024',
                      Icons.table_chart,
                      Colors.green,
                    ),
                    const SizedBox(height: 16),
                    _buildReportCard(
                      'Technology Adoption Report',
                      'Analysis of precision agriculture technology uptake',
                      'PDF • 3.1 MB',
                      'August 15, 2024',
                      Icons.computer,
                      Colors.purple,
                    ),
                    const SizedBox(height: 16),
                    _buildReportCard(
                      'Water Conservation Study',
                      'Impact of irrigation subsidy programs',
                      'PDF • 2.2 MB',
                      'July 30, 2024',
                      Icons.water_drop,
                      Colors.cyan,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    String description,
    String fileInfo,
    String date,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      fileInfo,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading: $title'),
                  backgroundColor: color,
                ),
              );
            },
            icon: const Icon(Icons.download, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the performance chart
class _PerformanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = 148.0;

    // Data points from SVG path
    final points = [
      Offset(0, 109),
      Offset(width * 0.077, 21),
      Offset(width * 0.154, 41),
      Offset(width * 0.231, 93),
      Offset(width * 0.308, 33),
      Offset(width * 0.385, 101),
      Offset(width * 0.462, 61),
      Offset(width * 0.539, 45),
      Offset(width * 0.616, 121),
      Offset(width * 0.693, 149),
      Offset(width * 0.770, 1),
      Offset(width * 0.847, 81),
      Offset(width * 0.924, 129),
      Offset(width, 25),
    ];

    // Create gradient fill
    final fillPath = Path();
    fillPath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF8A2BE2).withOpacity(0.3),
          const Color(0xFF8A2BE2).withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF8A2BE2)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
