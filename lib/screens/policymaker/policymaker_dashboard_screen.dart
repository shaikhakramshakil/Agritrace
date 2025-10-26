import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:agritrace/screens/policymaker/price_forecast_screen.dart';
import 'package:agritrace/screens/policymaker/performance_incentives_screen.dart';
import 'package:agritrace/screens/policymaker/policymaker_profile_screen.dart';
import 'package:agritrace/services/gemini_ai_service.dart';
import 'package:agritrace/widgets/agritrace_logo.dart';
import 'dart:convert';

class PolicyMakerDashboardScreen extends StatefulWidget {
  const PolicyMakerDashboardScreen({super.key});

  @override
  State<PolicyMakerDashboardScreen> createState() => _PolicyMakerDashboardScreenState();
}

class _PolicyMakerDashboardScreenState extends State<PolicyMakerDashboardScreen> {
  String _selectedCrop = 'Soy';
  int _selectedNavIndex = 0;
  bool _isLoadingKPI = false;
  bool _isLoadingChart = false;
  bool _isLoadingRegional = false;
  bool _isLoadingInsights = false;
  
  // Real data from AI
  Map<String, dynamic> _kpiData = {
    'totalProduction': '1,234,567 MT',
    'totalProductionTrend': '+5.2%',
    'demandSupplyGap': '15%',
    'demandSupplyTrend': '-1.8%',
    'importDependency': '25%',
    'importTrend': '+3.1%',
    'marketIndex': '112.5',
    'marketTrend': '+0.5%',
  };
  
  List<Map<String, dynamic>> _chartData = [];
  List<String> _chartMonths = [];
  
  List<Map<String, dynamic>> _regionalData = [
    {'region': 'North India', 'value': 0.4, 'percentage': '40%'},
    {'region': 'South India', 'value': 0.7, 'percentage': '70%'},
    {'region': 'East India', 'value': 0.25, 'percentage': '25%'},
    {'region': 'West India', 'value': 0.6, 'percentage': '60%'},
  ];
  
  List<Map<String, dynamic>> _aiInsights = [
    {
      'type': 'alert',
      'text': 'Alert: Predicted drop in sunflower production in South India next quarter.',
      'icon': Icons.warning,
      'color': const Color(0xFFFB923C),
    },
    {
      'type': 'opportunity',
      'text': 'Opportunity: Favorable weather conditions suggest high yield potential for soy in North India.',
      'icon': Icons.trending_up,
      'color': const Color(0xFF14B8A6),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      _fetchKPIData(),
      _fetchChartData(),
      _fetchRegionalData(),
      _fetchAIInsights(),
    ]);
  }

  Future<void> _fetchKPIData() async {
    setState(() => _isLoadingKPI = true);
    
    try {
      final prompt = '''
You are an agricultural data analyst for India. Provide current KPI metrics in JSON format:

Generate realistic data for:
1. Total oilseed production in India (in metric tons MT)
2. Demand-supply gap percentage
3. Import dependency percentage  
4. Market price index

Return ONLY valid JSON in this exact format:
{
  "totalProduction": "value with MT unit",
  "totalProductionTrend": "+X.X%",
  "demandSupplyGap": "X%",
  "demandSupplyTrend": "+X.X% or -X.X%",
  "importDependency": "X%",
  "importTrend": "+X.X%",
  "marketIndex": "XXX.X",
  "marketTrend": "+X.X%"
}

Base on real Indian agricultural production data for 2024-2025.
''';

      final response = await GeminiAIService.generateContent(prompt);
      final jsonStr = _extractJSON(response);
      
      if (jsonStr.isNotEmpty && mounted) {
        final data = json.decode(jsonStr);
        setState(() => _kpiData = data);
      }
    } catch (e) {
      debugPrint('Error fetching KPI data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingKPI = false);
      }
    }
  }

  Future<void> _fetchChartData() async {
    setState(() => _isLoadingChart = true);
    
    try {
      final prompt = '''
Generate monthly production data for ${_selectedCrop} crop in India for the last 12 months.

Return ONLY valid JSON array with 12 months of data:
[
  {"month": "Jan", "production": numeric_value_between_80000_and_150000},
  {"month": "Feb", "production": numeric_value},
  ... (12 months total)
]

Make the data realistic with seasonal variations for Indian agriculture.
Ensure production values are between 80,000 and 150,000 MT.
''';

      final response = await GeminiAIService.generateContent(prompt);
      final jsonStr = _extractJSON(response);
      
      if (jsonStr.isNotEmpty && mounted) {
        final List<dynamic> data = json.decode(jsonStr);
        setState(() {
          _chartData = data.cast<Map<String, dynamic>>();
          _chartMonths = _chartData.map((d) => d['month'].toString()).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching chart data: $e');
      // Fallback data
      if (mounted) {
        _generateFallbackChartData();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingChart = false);
      }
    }
  }

  void _generateFallbackChartData() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    _chartData = months.map((month) {
      return {
        'month': month,
        'production': 80000 + math.Random().nextInt(70000),
      };
    }).toList();
    _chartMonths = months;
  }

  Future<void> _fetchRegionalData() async {
    setState(() => _isLoadingRegional = true);
    
    try {
      final prompt = '''
Generate regional demand-supply gap data for 4 major agricultural regions in India.

Return ONLY valid JSON array:
[
  {"region": "North India", "value": decimal_between_0.2_and_0.9, "percentage": "XX%"},
  {"region": "South India", "value": decimal, "percentage": "XX%"},
  {"region": "East India", "value": decimal, "percentage": "XX%"},
  {"region": "West India", "value": decimal, "percentage": "XX%"}
]

Value should be decimal representation of percentage (e.g., 0.75 for 75%).
Make it realistic based on actual Indian agricultural production patterns.
''';

      final response = await GeminiAIService.generateContent(prompt);
      final jsonStr = _extractJSON(response);
      
      if (jsonStr.isNotEmpty && mounted) {
        final List<dynamic> data = json.decode(jsonStr);
        // Validate and ensure each item has required fields
        final validData = data.map((item) {
          return {
            'region': item['region']?.toString() ?? 'Unknown',
            'value': (item['value'] is num) ? (item['value'] as num).toDouble() : 0.5,
            'percentage': item['percentage']?.toString() ?? '0%',
          };
        }).toList();
        setState(() => _regionalData = validData.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      debugPrint('Error fetching regional data: $e');
      // Keep default data on error
    } finally {
      if (mounted) {
        setState(() => _isLoadingRegional = false);
      }
    }
  }

  Future<void> _fetchAIInsights() async {
    setState(() => _isLoadingInsights = true);
    
    try {
      final prompt = '''
Generate 3 AI-powered insights for Indian agricultural policy makers based on current trends.

Include:
1. One alert/warning about potential production issues
2. One opportunity about favorable conditions
3. One policy recommendation

Return ONLY valid JSON array:
[
  {
    "type": "alert",
    "text": "Brief insight text (max 100 chars)",
    "actionText": "View Details or Take Action"
  },
  {
    "type": "opportunity",
    "text": "Brief insight text",
    "actionText": "Explore or Learn More"
  },
  {
    "type": "recommendation",
    "text": "Brief policy recommendation",
    "actionText": "Review Policy"
  }
]

Focus on realistic Indian agricultural scenarios for 2024-2025.
''';

      final response = await GeminiAIService.generateContent(prompt);
      final jsonStr = _extractJSON(response);
      
      if (jsonStr.isNotEmpty && mounted) {
        final List<dynamic> data = json.decode(jsonStr);
        setState(() {
          _aiInsights = data.map((item) {
            IconData icon;
            Color color;
            
            switch (item['type']) {
              case 'alert':
                icon = Icons.warning;
                color = const Color(0xFFFB923C);
                break;
              case 'opportunity':
                icon = Icons.trending_up;
                color = const Color(0xFF14B8A6);
                break;
              case 'recommendation':
                icon = Icons.lightbulb;
                color = const Color(0xFF8B5CF6);
                break;
              default:
                icon = Icons.info;
                color = const Color(0xFF3B82F6);
            }
            
            return {
              'type': item['type'],
              'text': item['text'],
              'actionText': item['actionText'] ?? 'View Details',
              'icon': icon,
              'color': color,
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching AI insights: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingInsights = false);
      }
    }
  }

  String _extractJSON(String response) {
    // Remove markdown code blocks
    String cleaned = response.replaceAll('```json', '').replaceAll('```', '').trim();
    
    // Find JSON object or array
    int startObj = cleaned.indexOf('{');
    int startArr = cleaned.indexOf('[');
    int start = -1;
    
    if (startObj != -1 && startArr != -1) {
      start = math.min(startObj, startArr);
    } else if (startObj != -1) {
      start = startObj;
    } else if (startArr != -1) {
      start = startArr;
    }
    
    if (start == -1) return '';
    
    int end = cleaned.lastIndexOf('}');
    int endArr = cleaned.lastIndexOf(']');
    
    if (endArr > end) end = endArr;
    
    if (end == -1 || end < start) return '';
    
    return cleaned.substring(start, end + 1);
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

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Headline
                    _buildHeadline(),

                    // KPI Cards
                    _buildKPICards(),

                    // Production Trends Chart
                    _buildProductionChart(),

                    // Regional Charts
                    _buildRegionalCharts(),

                    // AI Insights
                    _buildAIInsights(),

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
          const Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
          // AgriTrace Logo
          const AgriTraceHeaderLogo(
            height: 28.0,
            iconColor: Color(0xFF1919E6),
            textColor: Colors.white,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PolicymakerProfileScreen(),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF1919E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        'AI & Analytics Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildKPICards() {
    if (_isLoadingKPI) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF1919E6)),
        ),
      );
    }

    final kpiCards = [
      _buildKPICard(
        title: 'Total Production',
        value: _kpiData['totalProduction']?.toString() ?? '0 MT',
        trend: _kpiData['totalProductionTrend']?.toString() ?? '+0.0%',
        isPositive: (_kpiData['totalProductionTrend']?.toString() ?? '').startsWith('+'),
      ),
      _buildKPICard(
        title: 'Demand-Supply Gap',
        value: _kpiData['demandSupplyGap']?.toString() ?? '0%',
        trend: _kpiData['demandSupplyTrend']?.toString() ?? '+0.0%',
        isPositive: (_kpiData['demandSupplyTrend']?.toString() ?? '').startsWith('-'),
      ),
      _buildKPICard(
        title: 'Import Dependency',
        value: _kpiData['importDependency']?.toString() ?? '0%',
        trend: _kpiData['importTrend']?.toString() ?? '+0.0%',
        isPositive: (_kpiData['importTrend']?.toString() ?? '').startsWith('-'),
      ),
      _buildKPICard(
        title: 'Market Price Index',
        value: _kpiData['marketIndex']?.toString() ?? '0.0',
        trend: _kpiData['marketTrend']?.toString() ?? '+0.0%',
        isPositive: (_kpiData['marketTrend']?.toString() ?? '').startsWith('+'),
      ),
    ];
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Key Metrics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _fetchKPIData,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: kpiCards[0]),
                  const SizedBox(width: 16),
                  Expanded(child: kpiCards[1]),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: kpiCards[2]),
                  const SizedBox(width: 16),
                  Expanded(child: kpiCards[3]),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
  }) {
    final trendColor = isPositive ? const Color(0xFF14B8A6) : const Color(0xFFFB923C);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1919E6).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1919E6).withOpacity(0.3),
        ),
      ),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: trendColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: trendColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductionChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1919E6).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF1919E6).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Oilseed Production Over Time',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Last 12 Months',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (!_isLoadingChart)
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                    onPressed: _fetchChartData,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildCropButton('Soy', _selectedCrop == 'Soy'),
                const SizedBox(width: 8),
                _buildCropButton('Sunflower', _selectedCrop == 'Sunflower'),
                const SizedBox(width: 8),
                _buildCropButton('Rapeseed', _selectedCrop == 'Rapeseed'),
                const SizedBox(width: 8),
                _buildCropButton('Groundnut', _selectedCrop == 'Groundnut'),
              ],
            ),
            const SizedBox(height: 24),
            _isLoadingChart
                ? const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF1919E6)),
                    ),
                  )
                : SizedBox(
                    height: 200,
                    child: _chartData.isEmpty
                        ? const Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : CustomPaint(
                            painter: _ChartPainter(_chartData),
                            child: Container(),
                          ),
                  ),
            const SizedBox(height: 16),
            if (_chartMonths.isNotEmpty && _chartMonths.length >= 7)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _chartMonths.take(7).map((month) => Text(
                  month,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropButton(String crop, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCrop = crop;
        });
        _fetchChartData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1919E6) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFF1919E6) : const Color(0xFF9CA3AF).withOpacity(0.3),
          ),
        ),
        child: Text(
          crop,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRegionalCharts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildDemandSupplyChart(),
          const SizedBox(height: 24),
          _buildImportDependencyMap(),
        ],
      ),
    );
  }

  Widget _buildDemandSupplyChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1919E6).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1919E6).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Regional Demand-Supply Gap',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '2024-2025',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (!_isLoadingRegional)
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                  onPressed: _fetchRegionalData,
                ),
            ],
          ),
          const SizedBox(height: 24),
          _isLoadingRegional
              ? const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF1919E6)),
                  ),
                )
              : (_regionalData.isEmpty
                  ? const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'No regional data available',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _regionalData.map((data) {
                          try {
                            final value = ((data['value'] ?? 0.5) as num).toDouble();
                            final percentage = (data['percentage'] ?? '0%').toString();
                            final region = (data['region'] ?? 'Unknown').toString();
                            final color = value >= 0.5 
                                ? const Color(0xFF14B8A6) 
                                : const Color(0xFFFB923C);
                            return _buildBarColumn(percentage, value, color, region);
                          } catch (e) {
                            debugPrint('Error building bar column: $e');
                            return _buildBarColumn('0%', 0.5, const Color(0xFF9CA3AF), 'Error');
                          }
                        }).toList(),
                      ),
                    )),
        ],
      ),
    );
  }

  Widget _buildBarColumn(String value, double height, Color color, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 150 * height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportDependencyMap() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1919E6).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1919E6).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Import Dependency by Region',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap to view detailed statistics',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _showImportDependencyDetails(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF111121),
                  border: Border.all(
                    color: const Color(0xFF1919E6).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.map,
                        color: Color(0xFF1919E6),
                        size: 80,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1919E6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.touch_app, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Tap for Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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

  void _showImportDependencyDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
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
                    'Import Dependency Analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
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
                    _buildImportRegionCard('North India', '18%', const Color(0xFF14B8A6), 'Low'),
                    const SizedBox(height: 12),
                    _buildImportRegionCard('South India', '28%', const Color(0xFFFB923C), 'Moderate'),
                    const SizedBox(height: 12),
                    _buildImportRegionCard('East India', '35%', const Color(0xFFEF4444), 'High'),
                    const SizedBox(height: 12),
                    _buildImportRegionCard('West India', '22%', const Color(0xFFFB923C), 'Moderate'),
                    const SizedBox(height: 12),
                    _buildImportRegionCard('Central India', '15%', const Color(0xFF14B8A6), 'Low'),
                    const SizedBox(height: 24),
                    const Text(
                      'Key Insights:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInsightBullet('East India shows highest import dependency'),
                    _buildInsightBullet('North and Central regions are more self-sufficient'),
                    _buildInsightBullet('Focus on increasing production in deficit regions'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImportRegionCard(String region, String percentage, Color color, String level) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                percentage,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  region,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dependency Level: $level',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: color, size: 20),
        ],
      ),
    );
  }

  Widget _buildInsightBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, color: Color(0xFF1919E6), size: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsights() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1919E6).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF1919E6).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AI-Generated Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isLoadingInsights)
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                    onPressed: _fetchAIInsights,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _isLoadingInsights
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: Color(0xFF1919E6)),
                    ),
                  )
                : Column(
                    children: _aiInsights.map((insight) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildInsightCard(
                          icon: insight['icon'] as IconData,
                          iconColor: insight['color'] as Color,
                          text: insight['text'] as String,
                          actionText: insight['actionText'] as String,
                          type: insight['type'] as String,
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color iconColor,
    required String text,
    required String actionText,
    required String type,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111121),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _showInsightDetails(type, text);
            },
            child: Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFF1919E6),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInsightDetails(String type, String text) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1B2A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type == 'alert' ? 'Alert Details' : 
                    type == 'opportunity' ? 'Opportunity Details' : 
                    'Policy Recommendation',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
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
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Recommended Actions:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActionItem('1. Monitor production metrics closely'),
                    _buildActionItem('2. Coordinate with regional officials'),
                    _buildActionItem('3. Review subsidy allocation'),
                    _buildActionItem('4. Prepare contingency plans'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Action plan created successfully'),
                            backgroundColor: Color(0xFF14B8A6),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1919E6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Create Action Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildActionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF14B8A6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
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
        color: const Color(0xFF1919E6).withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF1919E6).withOpacity(0.5),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.dashboard, 'Dashboard', 0),
                  _buildNavItem(Icons.analytics, 'Reports', 1),
                  _buildNavItem(Icons.explore, 'Explorer', 2),
                  _buildNavItem(Icons.notifications, 'Alerts', 3),
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
        if (index == 1) {
          // Navigate to Price Forecast
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PriceForecastScreen()),
          );
        } else if (index == 2) {
          // Navigate to Performance & Incentives
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PerformanceIncentivesScreen()),
          );
        } else {
          setState(() {
            _selectedNavIndex = index;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF1919E6) : const Color(0xFF9CA3AF),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1919E6) : const Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  _ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFF1919E6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1919E6).withOpacity(0.4),
          const Color(0xFF111121).withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Find min and max values for scaling
    double maxValue = 0;
    double minValue = double.infinity;
    
    for (var item in data) {
      final value = (item['production'] as num).toDouble();
      if (value > maxValue) maxValue = value;
      if (value < minValue) minValue = value;
    }
    
    // Add padding to the range
    final range = maxValue - minValue;
    final paddedMin = minValue - (range * 0.1);
    final paddedMax = maxValue + (range * 0.1);
    final paddedRange = paddedMax - paddedMin;

    final path = Path();
    final fillPath = Path();

    // Generate points from real data
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final value = (data[i]['production'] as num).toDouble();
      final normalizedValue = (value - paddedMin) / paddedRange;
      final y = size.height * (1 - normalizedValue);
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;

    // Draw smooth curve using quadratic bezier
    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];
      
      final controlPointX = (currentPoint.dx + nextPoint.dx) / 2;
      final controlPointY = (currentPoint.dy + nextPoint.dy) / 2;
      
      path.quadraticBezierTo(
        currentPoint.dx,
        currentPoint.dy,
        controlPointX,
        controlPointY,
      );
      fillPath.quadraticBezierTo(
        currentPoint.dx,
        currentPoint.dy,
        controlPointX,
        controlPointY,
      );
    }

    // Draw to last point
    path.lineTo(points.last.dx, points.last.dy);
    fillPath.lineTo(points.last.dx, points.last.dy);

    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint = Paint()
      ..color = const Color(0xFF1919E6)
      ..style = PaintingStyle.fill;

    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var point in points) {
      canvas.drawCircle(point, 5, pointPaint);
      canvas.drawCircle(point, 5, pointBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => 
      oldDelegate.data != data;
}
