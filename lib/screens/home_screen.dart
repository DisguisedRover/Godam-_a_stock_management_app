import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String? _userName;
  bool _isLoading = true;
  final AuthService _authService = AuthService();

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

  @override
  Widget build(BuildContext context) {
    final List<MilkAnalysisResult> recentAnalyses =
        MockDataProvider.getRecentAnalyses(5);
    final double avgFat = MockDataProvider.getAverageFat();
    final double avgProtein = MockDataProvider.getAverageProtein();
    final double avgLactose = MockDataProvider.getAverageLactose();

    final themeProvider = Provider.of<ThemeProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Icon(
                  Icons.water_drop,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            title: Row(
              children: [
                _buildNavBarButton(context, 'Master', '/master'),
                _buildNavBarButton(context, 'Purchase', '/purchase'),
                _buildNavBarButton(context, 'Sales', '/sales'),
                _buildNavBarButton(context, 'Reports', '/reports'),
              ],
            ),
            actions: [
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
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
          body: Row(
            // Main layout as a Row for two columns
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Left Column: Greeting Card and Quick Actions
              Expanded(
                flex: 1, // Takes 1 part of the available space (e.g., 33%)
                child: SingleChildScrollView(
                  // Allows content in this column to scroll if it overflows
                  padding: const EdgeInsets.all(
                    20.0,
                  ), // Slightly reduced padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            20.0,
                          ), // Reduced padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.waving_hand,
                                size: 36,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _getGreeting(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      _userName ?? 'User',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                              const SizedBox(height: 8),
                              Text(
                                'Welcome to your Milk Content Analyzer dashboard.',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary.withOpacity(0.8),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25), // Reduced spacing
                      // Quick Actions Section
                      Text(
                        'Quick Actions',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12), // Reduced spacing
                      GridView.count(
                        crossAxisCount: 2, // Two buttons per row
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // Handled by parent SingleChildScrollView
                        childAspectRatio:
                            1.5, // Adjusted aspect ratio for wider buttons, less height
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: <Widget>[
                          _buildQuickActionButton(
                            context,
                            'New Analysis',
                            Icons.add_chart,
                            '/new_analysis',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Analysis History',
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
                            'Settings',
                            Icons.settings,
                            '/settings',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Quality Standards',
                            Icons.check_circle_outline,
                            '/quality_standards',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Help & Support',
                            Icons.help_outline,
                            '/help_support',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Notification',
                            Icons.notifications,
                            '/notifications',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Vehicle Registration',
                            Icons.car_rental_outlined,
                            '/vehicle_registration',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Driver Registration',
                            Icons.perm_contact_calendar_outlined,
                            '/driver_registration',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Collection Center Registration',
                            Icons.collections_bookmark_outlined,
                            '/collection_center',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Delivery Entry',
                            Icons.delivery_dining_outlined,
                            '/delivery_registration',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Master Data',
                            Icons.category_outlined,
                            '/master_data',
                          ),
                          _buildQuickActionButton(
                            context,
                            'Product Master',
                            Icons.stacked_line_chart_outlined,
                            '/product_entry',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Right Column: Key Metrics and Recent Analyses
              Expanded(
                flex: 2, // Takes 2 parts of the available space (e.g., 67%)
                child: SingleChildScrollView(
                  // Allows content in this column to scroll independently
                  padding: const EdgeInsets.all(
                    20.0,
                  ), // Slightly reduced padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Key Metrics Section
                      Text(
                        'Key Metrics Overview',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12), // Reduced spacing
                      GridView.count(
                        crossAxisCount: 3, // Three cards per row
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio:
                            1.8, // Adjusted for slightly wider cards
                        crossAxisSpacing: 15, // Reduced spacing
                        mainAxisSpacing: 15, // Reduced spacing
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
                      const SizedBox(height: 25), // Reduced spacing
                      // Recent Analyses Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Analyses',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/history');
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12), // Reduced spacing
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
                                    (analysis) => _buildAnalysisResultCard(
                                      context,
                                      analysis,
                                    ),
                                  )
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ), // Spacing between buttons
      child: TextButton(
        onPressed: () {
          if (!isCurrentRoute) {
            Navigator.pushNamed(context, routeName);
          }
        },
        style:
            TextButton.styleFrom(
              foregroundColor: isCurrentRoute
                  ? Theme.of(context)
                        .colorScheme
                        .onPrimary // Highlight active button text
                  : Theme.of(context).colorScheme.primary, // Default text color
              backgroundColor: isCurrentRoute
                  ? Theme.of(context)
                        .colorScheme
                        .primary // Highlight active button background
                  : Colors.transparent, // No background for inactive
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.1); // Light hover
                }
                return null; // Defer to the widget's default.
              }),
            ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isCurrentRoute ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
            // Explicitly set text color here if foregroundColor in styleFrom isn't sufficient
            color: isCurrentRoute
                ? Theme.of(context)
                      .colorScheme
                      .onPrimary // Ensure visibility
                : Theme.of(
                    context,
                  ).colorScheme.onSurface, // Or another visible color
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
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: iconColor.withOpacity(0.2),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
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
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Theme.of(context).cardTheme.color,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ), // Slightly smaller icon
              const SizedBox(height: 8), // Reduced spacing
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
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
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12.0), // Reduced margin
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Theme.of(context).cardTheme.color,
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
            children: [
              Text(
                'Analysis ID: ${analysis.id}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6), // Reduced spacing
              Text(
                'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(analysis.date)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12.0, // Reduced horizontal space between chips
                runSpacing:
                    6.0, // Reduced vertical space between lines of chips
                children: [
                  _buildInfoChip(
                    context,
                    'Fat',
                    '${analysis.fatPercentage.toStringAsFixed(2)}%',
                    Colors.orange,
                  ),
                  _buildInfoChip(
                    context,
                    'Protein',
                    '${analysis.proteinPercentage.toStringAsFixed(2)}%',
                    Colors.green,
                  ),
                  _buildInfoChip(
                    context,
                    'Lactose',
                    '${analysis.lactosePercentage.toStringAsFixed(2)}%',
                    Colors.blue,
                  ),
                  _buildInfoChip(
                    context,
                    'SNF',
                    '${analysis.snfPercentage.toStringAsFixed(2)}%',
                    Colors.purple,
                  ),
                  _buildInfoChip(
                    context,
                    'Density',
                    analysis.density.toStringAsFixed(3),
                    Colors.brown,
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
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(Icons.info_outline, size: 16, color: color),
      ), // Smaller icon
      label: Text(
        '$label: $value',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ), // Reduced padding
    );
  }
}
