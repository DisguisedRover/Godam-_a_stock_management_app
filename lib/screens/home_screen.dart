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
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
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
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy • HH:mm').format(analysis.date),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.9),
                  fontSize: 13,
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
        title: const Text('Godam'),
        actions: [
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
      drawer: Drawer(
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
                  const SizedBox(height: 12),
                  Text(
                    'Milk Analyzer',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
            _buildDrawerItem(context, 'Sales', Icons.point_of_sale, '/sales'),
            _buildDrawerItem(context, 'Reports', Icons.bar_chart, '/reports'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.waving_hand,
                            size: 28,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.notifications,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getGreeting(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
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
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                      const SizedBox(height: 8),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'Key Metrics Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: <Widget>[
                  _buildMetricCard(
                    context,
                    'Average Fat Content',
                    '${avgFat.toStringAsFixed(2)}%',
                    Icons.opacity,
                    Colors.orange.shade700,
                  ),
                  const SizedBox(height: 12),
                  _buildMetricCard(
                    context,
                    'Average Protein Content',
                    '${avgProtein.toStringAsFixed(2)}%',
                    Icons.egg,
                    Colors.green.shade700,
                  ),
                  const SizedBox(height: 12),
                  _buildMetricCard(
                    context,
                    'Average Lactose Content',
                    '${avgLactose.toStringAsFixed(2)}%',
                    Icons.water_drop,
                    Colors.blue.shade700,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
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
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.85,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              recentAnalyses.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No recent analyses available.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
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
      ),
    );
  }
}