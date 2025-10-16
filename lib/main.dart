import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/local/database/app_database.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/vehicle_provider.dart';
import 'presentation/providers/maintenance_provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'presentation/screens/auth/welcome_screen.dart';
import 'presentation/screens/main/main_screen.dart';

/// Punto de entrada principal de la aplicación AutoCare
/// 
/// Configura la aplicación con:
/// - Tema personalizado
/// - Gestión de estado con Provider
/// - Inicialización de la base de datos
/// - Navegación principal
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar la base de datos
  await AppDatabase().database;
  
  runApp(const AutoCareApp());
}

class AutoCareApp extends StatelessWidget {
  const AutoCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => MaintenanceProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AppInitializer(),
      ),
    );
  }
}

/// Widget inicializador que determina qué pantalla mostrar
/// 
/// Verifica si hay un usuario logueado para decidir entre:
/// - WelcomeScreen (si no hay usuario)
/// - MainScreen (si hay usuario logueado)
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Verificar si hay un usuario logueado
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthStatus();
      
      // Cargar datos del usuario si está logueado
      if (authProvider.isLoggedIn) {
        await authProvider.loadUserData();
      }
    } catch (e) {
      print('Error inicializando app: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Inicializando AutoCare...'),
            ],
          ),
        ),
      );
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoggedIn) {
          return const MainScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
