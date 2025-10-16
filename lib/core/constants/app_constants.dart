/// Constantes generales de la aplicación AutoCare
/// 
/// Define valores constantes utilizados en toda la aplicación
/// como límites, configuraciones y valores por defecto.
class AppConstants {
  // Configuración de la aplicación
  static const String appName = 'AutoCare';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Gestión de mantenimiento vehicular';
  
  // Límites de validación
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxNotesLength = 500;
  static const int maxLocationLength = 100;
  static const int maxCostAmount = 999999;
  static const int maxMileageAmount = 999999;
  
  // Configuración de base de datos
  static const String databaseName = 'autocare.db';
  static const int databaseVersion = 1;
  
  // Configuración de notificaciones
  static const int maxNotificationAge = 30; // días
  static const int criticalPercentageThreshold = 30;
  static const int upcomingPercentageThreshold = 50;
  
  // Configuración de UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  
  // Configuración de animaciones
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Configuración de paginación
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Configuración de cache
  static const Duration cacheExpiration = Duration(hours: 1);
  
  // URLs y enlaces
  static const String supportEmail = 'support@autocare.com';
  static const String privacyPolicyUrl = 'https://autocare.com/privacy';
  static const String termsOfServiceUrl = 'https://autocare.com/terms';
  
  // Configuración de desarrollo
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
}
