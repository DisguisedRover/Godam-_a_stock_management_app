import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk_content_analysis/constants/constants.dart';
import 'package:provider/provider.dart';

import '../model/milk_analysis_model.dart';
import '../providers/milk_mock_data_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  String? _userName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userName = await _authService.getUserName();
    setState(() {
      _userName = userName ?? 'User';
      _isLoading = false;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
    );
  }

  Widget _buildNavBarButton(
    BuildContext context,
    String title,
    String routeName,
  ) {
    final bool isCurrentRoute =
        ModalRoute.of(context)?.settings.name == routeName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {
          if (!isCurrentRoute) {
            Navigator.pushNamed(context, routeName);
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: isCurrentRoute
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
          backgroundColor: isCurrentRoute
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isCurrentRoute ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 17.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: iconColor.withOpacity(0.2),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isMobile ? 28 : 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisResultCard(
    BuildContext context,
    MilkAnalysisResult analysis,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing details for ${analysis.id}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Analysis ID: ${analysis.id}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM dd, yyyy • HH:mm').format(analysis.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildInfoChip(
                    context,
                    'Fat',
                    '${analysis.fatPercentage.toStringAsFixed(1)}%',
                    Colors.orange,
                  ),
                  _buildInfoChip(
                    context,
                    'Protein',
                    '${analysis.proteinPercentage.toStringAsFixed(1)}%',
                    Colors.green,
                  ),
                  _buildInfoChip(
                    context,
                    'Lactose',
                    '${analysis.lactosePercentage.toStringAsFixed(1)}%',
                    Colors.blue,
                  ),
                  _buildInfoChip(
                    context,
                    'SNF',
                    '${analysis.snfPercentage.toStringAsFixed(1)}%',
                    Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<MilkAnalysisResult> recentAnalyses =
        MockDataProvider.getRecentAnalyses(5);
    final double avgFat = MockDataProvider.getAverageFat();
    final double avgProtein = MockDataProvider.getAverageProtein();
    final double avgLactose = MockDataProvider.getAverageLactose();

    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
           child: Image.asset(
            appLogo,
            width: 40,
            height: 40,
           ),
          ),
        ),
        title: isMobile
            ? const Text('Godam')
            : Row(
                children: [
                  _buildNavBarButton(context, 'Master', '/master'),
                  _buildNavBarButton(context, 'Purchase', '/purchase'),
                  _buildNavBarButton(context, 'Sales', '/sales'),
                  _buildNavBarButton(context, 'Reports', '/reports'),
                ],
              ),
        actions: [
          if (!isMobile)
            IconButton(
              icon: const Icon(Icons.notifications),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          if (!isMobile)
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'notifications':
                  Navigator.pushNamed(context, '/notifications');
                  break;
                case 'settings':
                  Navigator.pushNamed(context, '/settings');
                  break;
                case 'logout':
                  Navigator.pushReplacementNamed(context, '/');
                  break;
              }
            },
            itemBuilder: (context) => [
              if (isMobile)
                const PopupMenuItem(
                  value: 'notifications',
                  child: Row(
                    children: [
                      Icon(Icons.notifications),
                      SizedBox(width: 12),
                      Text('Notifications'),
                    ],
                  ),
                ),
              if (isMobile)
                const PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 12),
                      Text('Settings'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 12),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: isMobile
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                            appLogo,
                            width: 60,
                            height: 60,
                       ),
                        const SizedBox(height: 8),
                        Text(
                          'Milk Analyzer',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _buildDrawerItem(context, 'Master', Icons.category, '/master'),
                  _buildDrawerItem(
                      context, 'Purchase', Icons.shopping_cart, '/purchase'),
                  _buildDrawerItem(
                      context, 'Sales', Icons.point_of_sale, '/sales'),
                  _buildDrawerItem(
                      context, 'Reports', Icons.bar_chart, '/reports'),
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.waving_hand,
                      size: 32,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getGreeting(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _userName ?? 'User',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome to your Godam dashboard.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Key Metrics Section
            Text(
              'Key Metrics Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: isMobile ? 1 : 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isMobile ? 6.5 : 1.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
              
            
                _buildMetricCard(
                  context,
                  'Avg. Fat',
                  '${avgFat.toStringAsFixed(2)}%',
                  Icons.opacity,
                  Colors.orange.shade700,
                ),
                _buildMetricCard(
                  context,
                  'Avg. Protein',
                  '${avgProtein.toStringAsFixed(2)}%',
                  Icons.egg,
                  Colors.green.shade700,
                ),
                _buildMetricCard(
                  context,
                  'Avg. Lactose',
                  '${avgLactose.toStringAsFixed(2)}%',
                  Icons.water_drop,
                  Colors.blue.shade700,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: isMobile ? 3 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isMobile ? 0.9 : 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: <Widget>[
                _buildQuickActionButton(
                  context,
                  'New Analysis',
                  Icons.add_chart,
                  '/new_analysis',
                ),
                _buildQuickActionButton(
                  context,
                  'History',
                  Icons.history,
                  '/history',
                ),
                _buildQuickActionButton(
                  context,
                  'Reports',
                  Icons.bar_chart,
                  '/reports',
                ),
                _buildQuickActionButton(
                  context,
                  'Quality',
                  Icons.check_circle_outline,
                  '/quality_standards',
                ),
                _buildQuickActionButton(
                  context,
                  'Vehicles',
                  Icons.local_shipping,
                  '/vehicle_registration',
                ),
                _buildQuickActionButton(
                  context,
                  'Drivers',
                  Icons.person,
                  '/driver_registration',
                ),
                _buildQuickActionButton(
                  context,
                  'Centers',
                  Icons.location_on,
                  '/collection_center',
                ),
                _buildQuickActionButton(
                  context,
                  'Delivery',
                  Icons.delivery_dining,
                  '/delivery_registration',
                ),
                _buildQuickActionButton(
                  context,
                  'Master',
                  Icons.category,
                  '/master_data',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Analyses Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Recent Analyses',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('View All'),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            recentAnalyses.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'No recent analyses available.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )
                : Column(
                    children: recentAnalyses
                        .map(
                          (analysis) =>
                              _buildAnalysisResultCard(context, analysis),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}