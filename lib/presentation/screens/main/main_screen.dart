import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/vehicle_provider.dart';
import '../providers/maintenance_provider.dart';
import '../providers/notification_provider.dart';
import 'home_screen.dart';
import 'logbook_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

/// Pantalla principal de la aplicación con navegación inferior
/// 
/// Contiene el Scaffold principal con BottomNavigationBar
/// y maneja la navegación entre las diferentes secciones.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const LogbookScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    final maintenanceProvider = Provider.of<MaintenanceProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      final userId = authProvider.currentUser!.id!;
      
      // Cargar datos en paralelo
      await Future.wait([
        vehicleProvider.loadVehicles(userId),
        maintenanceProvider.loadPendingMaintenances(userId),
        maintenanceProvider.loadUrgentMaintenances(userId),
        maintenanceProvider.loadCompletedMaintenances(userId),
        notificationProvider.loadNotifications(userId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surfaceLight,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.normal,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppStrings.homeTitle,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: AppStrings.logbookTitle,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: AppStrings.notificationsTitle,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: AppStrings.profileTitle,
            ),
          ],
        ),
      ),
    );
  }
}
