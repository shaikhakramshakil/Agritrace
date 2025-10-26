import 'package:flutter/material.dart';
import 'package:agritrace/screens/farmer/crop_planning_screen.dart';
import 'package:agritrace/screens/farmer/market_linkage_screen.dart';
import 'package:agritrace/screens/farmer/insurance_credit_screen.dart';
import 'package:agritrace/screens/farmer/farmer_profile_screen.dart';
import 'package:agritrace/widgets/agritrace_logo.dart';

class FarmerHomeScreen extends StatelessWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        
        final navigator = Navigator.of(context);
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        
        if (shouldPop ?? false) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111121),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
            return Column(
              children: [
                // Header
                _buildHeader(context),
                
                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Section
                        _buildWelcomeSection(),
                        
                        // Horizontal Scrolling Cards
                        _buildHorizontalCards(context),
                        
                        // Quick Access Grid
                        _buildQuickAccessGrid(context, constraints),
                        
                        // AI Advisories Section
                        _buildAdvisoriesSection(context),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // AgriTrace Logo
          const AgriTraceHeaderLogo(
            height: 32.0,
            iconColor: Color(0xFF4F46E5),
            textColor: Colors.white,
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF4F46E5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FarmerProfileScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome, Farmer!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Here\'s a summary of your farm.',
            style: TextStyle(
              color: Color(0xFF9D9DB8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCards(BuildContext context) {
    final cards = [
      _CropCard(
        title: 'Soybean - Flowering',
        subtitle: 'Yield Estimate: 2.5 tons/ha',
        buttonText: 'View Details',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDscALJJ2FBWJpPslCXXpnjMra0p5KAcAKz9xVymLylFNijCyA9VzwW2lcoQF34eV4jCixdX2sENnPq-4H6eBD-x_DcCx-lV1E6M5woWf5vrZJ1d-fx-Zougu7hVTAgYKLB7u8echoGB6W6M0SpJHMAxOxYIBWypHcDKLgD8TX9w1ym-l1dNRsSFRqJDfoqmSaHh3gVp9YKexgH7_lBof36omWkBbrL114z_zmuwheoopNs1M5Cl4GEN67J3GwC4vBCMXN5X66QmNc',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CropPlanningScreen()),
          );
        },
      ),
      _CropCard(
        title: 'Expected Rainfall',
        subtitle: 'Next 7 days',
        buttonText: 'View Forecast',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB6StoM2tYVDkD__ZzIn0AZ4dvI6Dc3EXJROYVEGZDA-jEoWLkeKTJs0WzmFFXOiZ1eEMgBAbSrooJHFLinOoVMHSM8NGM2f3hUv4029mG5VU9YpzO6dmwvFWyCKWM3NNPR3Grsm5UruHY6Bp8LWqFJJ1ImzbX9BnZwsARuYGmFK5Nl707V15xZFyZf3GWvp2I7EPXDdq6HhagT1IddvEhuQbEz-1Wa1EasaDbA8ppN9YoZBZ52YrxNLxJWSfrIvfD9YIV7OCGYNLM',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Weather forecast coming soon!'),
              backgroundColor: Color(0xFF4F46E5),
            ),
          );
        },
      ),
      _CropCard(
        title: 'Price Forecast',
        subtitle: 'Next 30 days',
        buttonText: 'View Trends',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuATizC7xRju2vfsmz08rWAVl3abmxIZJj34n0ZU3lyslrvhZOMKCHu-4rrgudjsg4wvtimPLO7t1bOk_2LfTX7dwL_mR13Wtf7iFmb_JXGfXU3cjAyBoNoMrxa2VbWKvAyPi3CIXRoa1OEm7HRpiBD6OcW4-kQ-ctUFjyg434Q2E6dIkS-UoHbfj1nn7gKwbrQ8lwXi_HjEaLDkgp_JgabUfv0ZHfgS_faQHdsPpO8UC0bOfg1Cifst6F8mZKPlLSGb06kAgiJWRhk',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MarketLinkageScreen()),
          );
        },
      ),
      _CropCard(
        title: 'Soil Health - Good',
        subtitle: 'pH 6.5 | Nutrients: Optimal',
        buttonText: 'View Report',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCVPzK8lJ8vw3xBnZ-Ck3qFDhN1bqVLJ6CnjQpQmLVSUPD0SQx8PKJ6zVH4PByVrjvBZxmD1FoXN_wH1k8Px1dYJFXCFoRvCZh9KqLEqEIZ_-K0rCH5YnxU2rPmQHnIqQlj1aEwRzUoLoqx1PbqYq3EyuFV89lCnHLJtaT3gYWiLPKqwCsPjq8d_JhxZyE8cLMhRbTEQAXMbW8oCj0xT3A1MQxGn1KT9q3mA_4ZnR7sY5G8PvXJWmxA_L2qQwB1NnDxVzT8',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Soil analysis report coming soon!'),
              backgroundColor: Color(0xFF4F46E5),
            ),
          );
        },
      ),
      _CropCard(
        title: 'Water Usage',
        subtitle: '1,200 L/day | Efficiency: 85%',
        buttonText: 'Optimize',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBZnXB9h8_lYvKQxFLf3mKD7wPjBqTNj5RH8xVZGcK3dL2pQnM4sW9YfA0Rt7uJhCgO6ePvX2NlBwSk1aImH3qT5rDxC9gUvY8jE6wLfKpR2nMoA4sW1cXvB7hG5jT9qU3lPxN2rC8oE6yF4wL9pK7sR1nM5aD3vH8gJ2xU6yT4pL9sC7wF5rN1oK8jD2vG6xM3lS9pE4yR7uH',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Irrigation insights coming soon!'),
              backgroundColor: Color(0xFF4F46E5),
            ),
          );
        },
      ),
      _CropCard(
        title: 'Harvest Schedule',
        subtitle: '14 days remaining',
        buttonText: 'View Calendar',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8kR5yH3pL7mD9wF2xC6vJ4nB1gT8oP5qK9rE3sM7wY2aL6uF4dN8jC5xH9pR3oT7mV2bK6yL1sW8fE4gJ7rD5nP9xM3aC2vH6wO8lT4uF1bS7pK9yR5jN2mL8xC6dG3oV7wE4uH9pT2rF5sJ8nB1lK6yM4xP7aC3vD9wR2oJ5uT8gL',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CropPlanningScreen()),
          );
        },
      ),
      _CropCard(
        title: 'Equipment Status',
        subtitle: 'Tractor: Active | Sprayer: Idle',
        buttonText: 'Manage',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD5F8kL3nR7pJ9wM2xT6vH4aC8oP1yB5sG9rE7mK4dL2uF8jN6xC3wH9pT5oM7bR2yK6gL4vS1aJ8fE9rD3nP7xT5wH2cM6oV8lK4uB1gF9pS7yR3jL8nM2xC5dG9wE4vH7oJ2uT6rF3sK8lN1pB5mX4yC9aD7wR6oP2jT8gL',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Equipment tracking coming soon!'),
              backgroundColor: Color(0xFF4F46E5),
            ),
          );
        },
      ),
    ];

    return Container(
      height: 220,
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Container(
            width: 220,
            margin: EdgeInsets.only(right: index < cards.length - 1 ? 12 : 0),
            child: _buildCropCard(cards[index], context),
          );
        },
      ),
    );
  }

  Widget _buildCropCard(_CropCard data, BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: SizedBox(
                height: 110,
                child: Image.network(
                  data.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF2A2A3E),
                      child: const Icon(
                        Icons.image,
                        color: Color(0xFF9D9DB8),
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.subtitle,
                          style: const TextStyle(
                            color: Color(0xFFA0A0C0),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        data.buttonText,
                        style: const TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context, BoxConstraints constraints) {
    // Responsive grid: 2 columns on mobile, 3 on tablet, 4 on desktop
    int crossAxisCount = 2;
    if (constraints.maxWidth > 1200) {
      crossAxisCount = 4;
    } else if (constraints.maxWidth > 600) {
      crossAxisCount = 3;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: [
          _buildQuickAccessButton(
            icon: Icons.lightbulb,
            label: 'Advisory',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CropPlanningScreen(),
                ),
              );
            },
          ),
          _buildQuickAccessButton(
            icon: Icons.storefront,
            label: 'Market',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MarketLinkageScreen(),
                ),
              );
            },
          ),
          _buildQuickAccessButton(
            icon: Icons.shield,
            label: 'Insurance',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsuranceCreditScreen(),
                ),
              );
            },
          ),
          _buildQuickAccessButton(
            icon: Icons.account_balance_wallet,
            label: 'Credit',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsuranceCreditScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF4F46E5),
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            'AI Advisories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        
        // Best Time to Sow Advisory
        _buildAdvisoryCard(
          context: context,
          title: 'Best Time to Sow',
          description: 'Recommended: Oct 15 - Oct 25',
          buttonText: 'View Full Advisory',
          buttonColor: const Color(0xFF4F46E5),
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC4tZOozLI5uvJFeKQKwBk2bfYTe-ypDIlawM7u_Syo5z4O0VsGIMLmR754oTkGXJuj4hZlpK49vTj4XsBq7YR9BLcQvLMj-rdnFJyHWZUhvhh4MjfIfrpIUaj9krfBq0iKSTILAYOtrPZonmWDJ_9jyytztX0jNnZeFTlNYrb19UhnOcQx4wUUTR1ht-izpGylQoer5hGMiuUORH7SRtdWniR0sAnLS7frbVfFknxab223kk09pRn5anGfg82pFQqDBOgwyRV8Ugc',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CropPlanningScreen()),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Pest Alert Advisory
        _buildAdvisoryCard(
          context: context,
          title: 'Pest Alert',
          description: 'Aphid infestation detected in Sector B.',
          severity: 'Severity: High.',
          buttonText: 'Take Action',
          buttonColor: Colors.red,
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC2g0sgEW2cYcS3LjlnK2G--xhryGbCfBEWhEjsOo1Vz2evwIwincUPHhVuaAyj5MbAVFrlkp7XWbXd1EBzcU6apzQz5MMynaizWQqB-G3V7lvVYQDt51C1h_B8Ns4-TsDBETCF7wZYp4sebaTLKsTjwKfJpTZPCgehEEk3CoAAdKdTrJibR3ZETnCPhPZoVHKqimbIgUZJsDuiHuUe3829SiIIkLtPHZ4VnpZpnwj8PZU6ISBz8IdSK-L1UiAcoTlXIFUBI_ggFd4',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pest control recommendations coming soon!'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAdvisoryCard({
    required BuildContext context,
    required String title,
    required String description,
    String? severity,
    required String buttonText,
    required Color buttonColor,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Text Content
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFFA0A0C0),
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(text: description),
                          if (severity != null) ...[
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: severity,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2A3E),
                        child: const Icon(
                          Icons.image,
                          color: Color(0xFF9D9DB8),
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CropCard {
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageUrl;
  final VoidCallback onTap;

  _CropCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageUrl,
    required this.onTap,
  });
}
