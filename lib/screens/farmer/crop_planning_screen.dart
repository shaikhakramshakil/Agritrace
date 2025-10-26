import 'package:flutter/material.dart';
import '../../services/gemini_ai_service.dart';

class CropPlanningScreen extends StatefulWidget {
  const CropPlanningScreen({super.key});

  @override
  State<CropPlanningScreen> createState() => _CropPlanningScreenState();
}

class _CropPlanningScreenState extends State<CropPlanningScreen> {
  String _selectedCrop = 'Soybean';
  bool _isLoadingAI = false;
  Map<String, dynamic>? _aiRecommendations;
  Map<String, dynamic>? _pestAnalysis;
  Map<String, dynamic>? _vegetationAnalysis;

  @override
  void initState() {
    super.initState();
    _loadAIRecommendations();
  }

  Future<void> _loadAIRecommendations() async {
    setState(() => _isLoadingAI = true);
    try {
      final recommendations = await GeminiAIService.getCropRecommendations(_selectedCrop, 'Midwest USA');
      final pestData = await GeminiAIService.analyzePestThreat(_selectedCrop, 'Aphids');
      final vegHealth = await GeminiAIService.analyzeVegetationHealth(0.82);
      
      setState(() {
        _aiRecommendations = recommendations;
        _pestAnalysis = pestData;
        _vegetationAnalysis = vegHealth;
        _isLoadingAI = false;
      });
    } catch (e) {
      setState(() => _isLoadingAI = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AI analysis error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),

                  // Hero Banner
                  _buildHeroBanner(),

                  // Weather Forecast Section
                  _buildWeatherSection(),

                  // Pest Alert
                  _buildPestAlert(),

                  // Vegetation Health (NDVI)
                  _buildVegetationHealth(),

                  // Crop Guidance
                  _buildCropGuidance(),

                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Floating Action Button
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                onPressed: () {
                  _showAddCropPlanDialog();
                },
                backgroundColor: const Color(0xFF00FFFF),
                icon: const Icon(
                  Icons.add,
                  color: Color(0xFF0D1B2A),
                ),
                label: const Text(
                  'New Plan',
                  style: TextStyle(
                    color: Color(0xFF0D1B2A),
                    fontWeight: FontWeight.bold,
                  ),
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
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          const Expanded(
            child: Text(
              'Crop Planning & Advisory',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              _showCropSelector();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00FFFF), width: 1),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedCrop,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF00FFFF),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCropSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Crop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...['Soybean', 'Wheat', 'Rice', 'Cotton', 'Corn'].map((crop) {
                final isSelected = crop == _selectedCrop;
                return ListTile(
                  leading: Icon(
                    Icons.agriculture,
                    color: isSelected ? const Color(0xFF00FFFF) : Colors.white54,
                  ),
                  title: Text(
                    crop,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF00FFFF) : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFF00FFFF))
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCrop = crop;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Switched to $crop planning'),
                        backgroundColor: const Color(0xFF00FFFF),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showAddCropPlanDialog() {
    final cropController = TextEditingController();
    final areaController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create New Crop Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: cropController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Crop Type',
                    labelStyle: const TextStyle(color: Color(0xFF9D9DB8)),
                    filled: true,
                    fillColor: const Color(0xFF0D1B2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.grass, color: Color(0xFF00FFFF)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: areaController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Area (acres)',
                    labelStyle: const TextStyle(color: Color(0xFF9D9DB8)),
                    filled: true,
                    fillColor: const Color(0xFF0D1B2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.square_foot, color: Color(0xFF00FFFF)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (cropController.text.isNotEmpty && areaController.text.isNotEmpty) {
                            Navigator.pop(context);
                            // Dispose controllers after dialog closes
                            cropController.dispose();
                            areaController.dispose();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Crop plan created: ${cropController.text} (${areaController.text} acres)',
                                ),
                                backgroundColor: const Color(0xFF00FFFF),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FFFF),
                          foregroundColor: const Color(0xFF0D1B2A),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Create'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroBanner() {
    final seedingWindow = _aiRecommendations?['seedingWindow'] ?? 'Next 7 Days';
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          _showSeedingDetails();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuC7hIOKX3bgNIai74txwDnH-wQHnecU4nOtXmWMQ-gov2LQ5fopBGWI-Vlkn07hiNrhI8lLfI8MXdGRo-9Y1EJwxECqjGZh_QW5G-vRP3Sq6kklq3UbViGnFoY8upxqVCvcrHpnri9WU_k0IBw6MybzB10OjsvjRnQcFx5Ptd80DgSDDIz4IeeZJv4IBTwEeyXngQdwK7HE-Q_qc7rjOx9a-9VynPYlDlRpPdYxr9BQs0Jqs1Om8B7NyxE9FYr-OX85syZqzQsRTQs',
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xFF1A1A2E),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 132, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Optimal Seeding Time: $seedingWindow',
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (_isLoadingAI)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Based on AI analysis of soil moisture and weather forecast.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF00FFFF),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSeedingDetails() async {
    // Show loading while fetching AI recommendations
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF00FFFF)),
      ),
    );

    try {
      final seedingData = await GeminiAIService.getSeedingRecommendations(
        _selectedCrop,
        {'moisture': 65, 'temp': 72, 'ph': 6.5},
        {'temp': '25-30°C', 'conditions': 'Clear'},
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF1A1A2E),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.psychology, color: Color(0xFF00FFFF), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'AI Seeding Recommendations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.calendar_today, 'Optimal Window', 
                    seedingData['optimalWindow'] ?? 'Next 7 days'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.grass, 'Seed Depth', 
                    seedingData['seedDepth'] ?? '1.5-2 inches'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.space_dashboard, 'Row Spacing', 
                    seedingData['rowSpacing'] ?? '30 inches'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.numbers, 'Seed Rate', 
                    seedingData['seedRate'] ?? '150,000/acre'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.thermostat, 'Soil Temperature', 
                    seedingData['soilTemp'] ?? '50-55°F'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1B2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Color(0xFFFFD700), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          seedingData['reasoning'] ?? 'Optimal conditions detected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Seeding schedule added to calendar'),
                        backgroundColor: Color(0xFF00FFFF),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FFFF),
                    foregroundColor: const Color(0xFF0D1B2A),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add to Schedule',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading AI recommendations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00FFFF), size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9D9DB8),
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card size based on screen width
        final screenWidth = constraints.maxWidth;
        final cardWidth = screenWidth > 1200 
            ? 140.0  // Desktop
            : screenWidth > 600 
                ? 110.0  // Tablet
                : 100.0; // Mobile
        
        final cardHeight = screenWidth > 1200 
            ? 160.0  // Desktop
            : screenWidth > 600 
                ? 130.0  // Tablet
                : 109.0; // Mobile
        
        final iconSize = screenWidth > 1200 ? 36.0 : screenWidth > 600 ? 32.0 : 26.0;
        final dayFontSize = screenWidth > 1200 ? 16.0 : screenWidth > 600 ? 14.0 : 12.0;
        final tempFontSize = screenWidth > 1200 ? 20.0 : screenWidth > 600 ? 16.0 : 14.0;
        final rainFontSize = screenWidth > 1200 ? 14.0 : screenWidth > 600 ? 12.0 : 10.0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                '7-Day Weather Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: cardHeight,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildWeatherCard('Mon', 'partly_cloudy_day', '28°C', '10%', 
                      cardWidth, iconSize, dayFontSize, tempFontSize, rainFontSize),
                  _buildWeatherCard('Tue', 'cloudy', '26°C', '20%',
                      cardWidth, iconSize, dayFontSize, tempFontSize, rainFontSize),
                  _buildWeatherCard('Wed', 'rainy', '24°C', '80%',
                      cardWidth, iconSize, dayFontSize, tempFontSize, rainFontSize),
                  _buildWeatherCard('Thu', 'sunny', '29°C', '5%',
                      cardWidth, iconSize, dayFontSize, tempFontSize, rainFontSize),
                  _buildWeatherCard('Fri', 'partly_cloudy_day', '27°C', '15%',
                      cardWidth, iconSize, dayFontSize, tempFontSize, rainFontSize),
                  _buildWeatherCard('Sat', 'thunderstorm', '25°C', '60%',
                      cardWidth, iconSize, dayFontSize, tempFontSize, rainFontSize),
                  _buildWeatherCard('Sun', 'sunny', '30°C', '0%',
                      cardWidth, iconSize, dayFontSize, tempFontSize, rainFontSize),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeatherCard(String day, String iconName, String temp, String rain,
      double cardWidth, double iconSize, double dayFontSize, double tempFontSize, double rainFontSize) {
    IconData icon;
    switch (iconName) {
      case 'sunny':
        icon = Icons.wb_sunny;
        break;
      case 'cloudy':
        icon = Icons.cloud;
        break;
      case 'rainy':
        icon = Icons.water_drop;
        break;
      case 'thunderstorm':
        icon = Icons.thunderstorm;
        break;
      default:
        icon = Icons.wb_cloudy;
    }

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(
        horizontal: cardWidth > 120 ? 12 : 8,
        vertical: cardWidth > 120 ? 10 : 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: TextStyle(
              color: Colors.white,
              fontSize: dayFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: cardWidth > 120 ? 8 : 4),
          Icon(
            icon,
            color: const Color(0xFFFFD700),
            size: iconSize,
          ),
          SizedBox(height: cardWidth > 120 ? 8 : 4),
          Text(
            temp,
            style: TextStyle(
              color: Colors.white,
              fontSize: tempFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            rain,
            style: TextStyle(
              color: const Color(0xFF9D9DB8),
              fontSize: rainFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPestAlert() {
    final threatLevel = _pestAnalysis?['threatLevel'] ?? 'HIGH';
    final symptoms = _pestAnalysis?['symptoms'] as List<dynamic>? ?? ['Analyzing...'];
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          _showPestDetails();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2E1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.red,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  const Icon(
                    Icons.bug_report,
                    color: Colors.red,
                    size: 32,
                  ),
                  if (_isLoadingAI)
                    const Positioned(
                      right: -4,
                      top: -4,
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$threatLevel Pest Threat: Aphids',
                          style: const TextStyle(
                            color: Color(0xFFFF6B6B),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.psychology, color: Color(0xFF00FFFF), size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      symptoms.isNotEmpty ? symptoms[0] : 'Loading AI analysis...',
                      style: const TextStyle(
                        color: Color(0xFF9D9DB8),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPestDetails() {
    final symptoms = _pestAnalysis?['symptoms'] as List<dynamic>? ?? [];
    final recommendations = _pestAnalysis?['recommendations'] as List<dynamic>? ?? [];
    final threatLevel = _pestAnalysis?['threatLevel'] ?? 'HIGH';
    final estimatedDamage = _pestAnalysis?['estimatedDamage'] ?? 'Calculating...';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bug_report, color: Colors.red, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'AI Pest Analysis: Aphids',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.psychology, color: Color(0xFF00FFFF), size: 20),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Threat Level: $threatLevel',
                    style: const TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      estimatedDamage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Symptoms:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (symptoms.isNotEmpty)
                ...symptoms.map((symptom) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: Color(0xFF9D9DB8))),
                          Expanded(
                            child: Text(
                              symptom.toString(),
                              style: const TextStyle(color: Color(0xFF9D9DB8), fontSize: 14, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ))
              else
                const Text('Loading...', style: TextStyle(color: Color(0xFF9D9DB8), fontSize: 14)),
              const SizedBox(height: 16),
              const Text(
                'AI Recommended Actions:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (recommendations.isNotEmpty)
                ...recommendations.map((rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF00FFFF), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rec.toString(),
                              style: const TextStyle(color: Color(0xFF9D9DB8), fontSize: 14, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ))
              else
                const Text('Loading...', style: TextStyle(color: Color(0xFF9D9DB8), fontSize: 14)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('AI treatment guide downloaded'),
                            backgroundColor: Color(0xFF00FFFF),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00FFFF),
                        side: const BorderSide(color: Color(0xFF00FFFF)),
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Download Guide'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reminder set for daily monitoring'),
                            backgroundColor: Color(0xFF00FFFF),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FFFF),
                        foregroundColor: const Color(0xFF0D1B2A),
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Set Reminder'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVegetationHealth() {
    final healthStatus = _vegetationAnalysis?['healthStatus'] ?? 'Good';
    final healthScore = 82; // Based on NDVI 0.82
    
    Color statusColor;
    if (healthScore >= 80) {
      statusColor = const Color(0xFF00FF00);
    } else if (healthScore >= 60) {
      statusColor = const Color(0xFFFFD700);
    } else {
      statusColor = const Color(0xFFFF6B6B);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      'Vegetation Health (NDVI)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.psychology, color: Color(0xFF00FFFF), size: 18),
                  ],
                ),
                IconButton(
                  icon: _isLoadingAI 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00FFFF)),
                          ),
                        )
                      : const Icon(Icons.refresh, color: Color(0xFF00FFFF)),
                  onPressed: _isLoadingAI ? null : () async {
                    setState(() => _isLoadingAI = true);
                    await _loadAIRecommendations();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('AI analysis updated'),
                          backgroundColor: Color(0xFF00FFFF),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  tooltip: 'Refresh AI Analysis',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Health Score: $healthScore/100 ($healthStatus)',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white24,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: healthScore / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: statusColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_vegetationAnalysis != null) ...[
              const SizedBox(height: 8),
              Text(
                _vegetationAnalysis!['analysis'] ?? '',
                style: const TextStyle(
                  color: Color(0xFF9D9DB8),
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                // Responsive aspect ratio based on screen width
                double aspectRatio = 1.5;
                if (constraints.maxWidth > 600) {
                  aspectRatio = 2.0;
                }
                if (constraints.maxWidth > 900) {
                  aspectRatio = 2.5;
                }
                
                return InkWell(
                  onTap: () {
                    _showNDVIDetails();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxWidth > 600 ? 300 : 250,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: aspectRatio,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCubfq_Zud8Gwk1sjX8wJK47iC-iAP9QHE2rGrkFCPST4laCAkO6lw-25sVJ8TDrJnA8toFEyDm6_Kc41H3WSss3RV3xY1swLOX-uC6nOt-RmDI0uaJrJsIRkk6LBD-s9aaiMWBCiPPHQl_kBuPCozEKN5_9tLF21VVNU1WhV4-7eKlzIzo1oSUCswr29z8D32KgrtPKK70k7gkp9R_ItZwlZNgcIXGEYkchIGzRQBtYODl4yxWpCJr9ByVvykv1f4V8vun_D5le2o',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFF2A2A3E),
                                  child: const Icon(
                                    Icons.satellite_alt,
                                    color: Color(0xFF9D9DB8),
                                    size: 48,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.zoom_in, color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Tap to expand',
                                      style: TextStyle(color: Colors.white, fontSize: 11),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNDVIDetails() {
    final recommendations = _vegetationAnalysis?['recommendations'] as List<dynamic>? ?? [];
    final concernAreas = _vegetationAnalysis?['concernAreas'] as List<dynamic>? ?? [];
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1A2E),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
              maxWidth: MediaQuery.of(context).size.width > 600 ? 600 : double.infinity,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCubfq_Zud8Gwk1sjX8wJK47iC-iAP9QHE2rGrkFCPST4laCAkO6lw-25sVJ8TDrJnA8toFEyDm6_Kc41H3WSss3RV3xY1swLOX-uC6nOt-RmDI0uaJrJsIRkk6LBD-s9aaiMWBCiPPHQl_kBuPCozEKN5_9tLF21VVNU1WhV4-7eKlzIzo1oSUCswr29z8D32KgrtPKK70k7gkp9R_ItZwlZNgcIXGEYkchIGzRQBtYODl4yxWpCJr9ByVvykv1f4V8vun_D5le2o',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'AI NDVI Analysis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.psychology, color: Color(0xFF00FFFF), size: 18),
                          ],
                        ),
                      const SizedBox(height: 12),
                      _buildColorLegend(),
                      if (recommendations.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'AI Recommendations:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...recommendations.map((rec) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle, 
                                      color: Color(0xFF00FFFF), size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      rec.toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF9D9DB8),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                      if (concernAreas.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Areas to Monitor:',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...concernAreas.map((concern) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.warning, 
                                      color: Color(0xFFFFD700), size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      concern.toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF9D9DB8),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                        const SizedBox(height: 12),
                        const Text(
                          'Last Updated: Oct 23, 2025',
                          style: TextStyle(color: Color(0xFF9D9DB8), fontSize: 12),
                        ),
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

  Widget _buildColorLegend() {
    return Column(
      children: [
        _buildLegendItem(Colors.red, 'Low Vegetation (0.0-0.2)'),
        _buildLegendItem(Colors.yellow, 'Moderate (0.2-0.4)'),
        _buildLegendItem(Colors.green, 'Healthy (0.4-0.6)'),
        _buildLegendItem(Colors.green[900]!, 'Very Healthy (0.6-1.0)'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCropGuidance() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Crop Guidance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildExpandableCard(
            icon: Icons.grass,
            title: 'Soil',
            description:
                'Ideal soil type: Loamy, pH: 6.0-7.0. Recommended nutrients: Nitrogen, Phosphorus, Potassium.',
            isExpanded: true,
          ),
          const SizedBox(height: 10),
          _buildExpandableCard(
            icon: Icons.water_drop,
            title: 'Irrigation',
            description:
                'Water deeply and infrequently. Aim for 1-1.5 inches per week, including rainfall. Check soil moisture before watering.',
          ),
          const SizedBox(height: 10),
          _buildExpandableCard(
            icon: Icons.compost,
            title: 'Seed Selection',
            description:
                'Choose varieties resistant to local pests and diseases. Consider maturity group based on your region\'s growing season.',
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard({
    required IconData icon,
    required String title,
    required String description,
    bool isExpanded = false,
  }) {
    return _ExpandableGuidanceCard(
      icon: icon,
      title: title,
      description: description,
      initiallyExpanded: isExpanded,
    );
  }
}

class _ExpandableGuidanceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool initiallyExpanded;

  const _ExpandableGuidanceCard({
    required this.icon,
    required this.title,
    required this.description,
    this.initiallyExpanded = false,
  });

  @override
  State<_ExpandableGuidanceCard> createState() => _ExpandableGuidanceCardState();
}

class _ExpandableGuidanceCardState extends State<_ExpandableGuidanceCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: const Color(0xFF00FFFF),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.7),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 16, 14),
              child: Text(
                widget.description,
                style: const TextStyle(
                  color: Color(0xFF9D9DB8),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
            crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
