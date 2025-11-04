import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milk_content_analysis/bloc/bloc/login_bloc.dart/login_bloc.dart';
import 'package:milk_content_analysis/bloc/bloc/signup_bloc/signup_bloc.dart';
import 'package:milk_content_analysis/services/auth_service.dart';

import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/master_data_provider.dart';
import 'providers/collection_center_provider.dart';
import 'providers/delivery_provider.dart';
import 'providers/driver_provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/vehicle_provider.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/authentication/signup_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/home_screen.dart';
import 'screens/master_screen.dart';
import 'screens/modules/analysis_history_screen.dart';
import 'screens/modules/master_data_screen.dart';
import 'screens/modules/collection_center_screen.dart';
import 'screens/modules/delivery_entry_screen.dart';
import 'screens/modules/driver_registration_screen.dart';
import 'screens/modules/new_analysis_screen.dart';
import 'screens/modules/produtc_entry_screen.dart';
import 'screens/modules/quality_standards_screen.dart';
import 'screens/modules/report_screen.dart';
import 'screens/modules/vehicle_registration_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/purchase_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/user_profile_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginBloc(authService: AuthService())),
          BlocProvider(create: (context) => SignupBloc(authService: AuthService())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Godam: a stock management app',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/home': (context) => const HomeScreen(),
            '/new_analysis': (context) => const NewAnalysisScreen(),
            '/history': (context) => const AnalysisHistoryScreen(),
            '/reports': (context) => const ReportsScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/profile': (context) => const UserProfileScreen(),
            '/quality_standards': (context) => const QualityStandardsScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            '/help_support': (context) => const HelpSupportScreen(),
            '/master': (context) => const MasterScreen(),
            '/purchase': (context) => const PurchaseScreen(),
            '/sales': (context) => const SalesScreen(),
            '/vehicle_registration': (context) =>
                const VehicleRegistrationScreen(),
            '/driver_registration': (context) =>
                const DriverRegistrationScreen(),
            '/collection_center': (context) => const CollectionCenterScreen(),
            '/delivery_registration': (context) => const DeliveryEntryScreen(),
            '/master_data': (context) => const MasterDataScreen(),
            '/product_entry': (context) => const ProductEntryScreen(),
          },
        );
      },
    );
  }
}
