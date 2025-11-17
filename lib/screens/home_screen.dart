import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  String? _userName;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userName == null) {
      _loadUserName();
    }
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

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '☀️';
    } else if (hour < 17) {
      return '🌤️';
    } else {
      return '🌙';
    }
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardBottomNavigationBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      elevation: 5,
      backgroundColor: isDark ? AppTheme.darkCardBackground : Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryRetroModern,
      unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category_rounded), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }

  void _showProfileMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.darkCardBackground : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings_rounded, color: AppTheme.primaryRetroModern),
              title: Text('Settings', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6_rounded, color: AppTheme.primaryRetroModern),
              title: Text(
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: Colors.red),
              title: Text('Logout', style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context); 
                _authService.logout();
                Navigator.pushReplacementNamed(context, '/'); 
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: AppTheme.primaryRetroModern.withOpacity(0.1),
            child: ClipOval(
              child: Image.asset(
                appLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Godam',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
              ),
              Text(
                'Management your stock',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryRetroModern,
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
            ),
            onPressed: _showProfileMenu,
            tooltip: 'Profile & Actions',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingHeader(context),
            const SizedBox(height: 32),
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMetricCard(
                    context,
                    'Total Products',
                    '24',
                    'In stock',
                    Icons.inventory_2_rounded,
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _buildMetricCard(
                    context,
                    'Categories',
                    '8',
                    'Active',
                    Icons.category_rounded,
                    AppTheme.primaryRetroModern,
                  ),
                  const SizedBox(width: 12),
                  _buildMetricCard(
                    context,
                    'Low Stock',
                    '3',
                    'Need restock',
                    Icons.warning_amber_rounded,
                    Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildFeatureCard(
                  context,
                  'Product Master',
                  'Manage your product catalog and inventory',
                  Icons.category_rounded,
                  AppTheme.primaryRetroModern,
                  () {
                    Navigator.pushNamed(context, '/product_master');
                  },
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  context,
                  'Stock Management',
                  'Track inventory levels and movements',
                  Icons.inventory_2_rounded,
                  Colors.blue,
                  () {
                    // Navigate to stock management
                  },
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  context,
                  'Reports & Analytics',
                  'View insights and generate reports',
                  Icons.bar_chart_rounded,
                  Colors.green,
                  () {
                    // Navigate to reports
                  },
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/product_master');
        },
        backgroundColor: AppTheme.primaryRetroModern,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildStandardBottomNavigationBar(),
    );
  }

  Widget _buildGreetingHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryRetroModern.withOpacity(0.9),
              AppTheme.primaryRetroModern,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getGreetingEmoji(),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _isLoading
                      ? SizedBox(
                          height: 24,
                          width: 120,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _userName ?? 'User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to manage your inventory?',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(
                Icons.warehouse_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}