import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación AutoCare
/// 
/// Define todos los colores utilizados en la aplicación siguiendo
/// Material Design 3 y las mejores prácticas de UX.
class AppColors {
  // Colores principales de la marca
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color gradientStart = Color(0xFF1E3C72);
  static const Color gradientEnd = Color(0xFF2A5298);
  
  // Colores específicos para cada tipo de mantenimiento
  static const Color oilGreen = Color(0xFF4CAF50);        // 🛢️ Aceite
  static const Color tiresOrange = Color(0xFFFF9800);     // 🚗 Llantas
  static const Color brakesRed = Color(0xFFF44336);       // 🛑 Frenos
  static const Color batteryYellow = Color(0xFFFFEB3B);   // 🔋 Batería
  static const Color coolantBlue = Color(0xFF2196F3);     // 🌡️ Refrigerante
  static const Color airFilterPurple = Color(0xFF9C27B0); // 💨 Filtro Aire
  static const Color alignmentTeal = Color(0xFF009688);  // ⚖️ Alineación
  static const Color chainGray = Color(0xFF607D8B);       // ⛓️ Cadena
  static const Color sparkPlugOrange = Color(0xFFFF5722); // ⚡ Bujía
  
  // Colores de estado
  static const Color completedGreen = Color(0xFF4CAF50);
  static const Color pendingOrange = Color(0xFFFF9800);
  static const Color urgentRed = Color(0xFFF44336);
  static const Color goodBlue = Color(0xFF2196F3);
  
  // Colores de prioridad
  static const Color highPriorityRed = Color(0xFFE53935);
  static const Color mediumPriorityOrange = Color(0xFFFF9800);
  static const Color lowPriorityBlue = Color(0xFF2196F3);
  
  // Colores de fondo
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Colores de borde y divisores
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
  
  // Colores de éxito, error y advertencia
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFF44336);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Colores de sombra
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  /// Obtiene el color asociado a un tipo de mantenimiento
  static Color getMaintenanceColor(String type) {
    switch (type) {
      case 'oil':
        return oilGreen;
      case 'tires':
        return tiresOrange;
      case 'brakes':
        return brakesRed;
      case 'battery':
        return batteryYellow;
      case 'coolant':
        return coolantBlue;
      case 'airFilter':
        return airFilterPurple;
      case 'alignment':
        return alignmentTeal;
      case 'chain':
        return chainGray;
      case 'sparkPlug':
        return sparkPlugOrange;
      default:
        return primaryBlue;
    }
  }
  
  /// Obtiene el color asociado a un estado de mantenimiento
  static Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return completedGreen;
      case 'pending':
        return pendingOrange;
      case 'urgent':
        return urgentRed;
      case 'good':
        return goodBlue;
      default:
        return Colors.grey;
    }
  }
  
  /// Obtiene el color asociado a una prioridad
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return highPriorityRed;
      case 'medium':
        return mediumPriorityOrange;
      case 'low':
        return lowPriorityBlue;
      default:
        return Colors.grey;
    }
  }
  
  /// Obtiene el color asociado a un porcentaje de mantenimiento
  static Color getPercentageColor(int percentage) {
    if (percentage < 30) return urgentRed;
    if (percentage < 50) return pendingOrange;
    if (percentage < 80) return goodBlue;
    return completedGreen;
  }
  
  /// Obtiene el color de fondo para un porcentaje específico
  static Color getPercentageBackgroundColor(int percentage) {
    if (percentage < 30) return urgentRed.withOpacity(0.1);
    if (percentage < 50) return pendingOrange.withOpacity(0.1);
    if (percentage < 80) return goodBlue.withOpacity(0.1);
    return completedGreen.withOpacity(0.1);
  }
  
  /// Obtiene el gradiente principal de la aplicación
  static LinearGradient get primaryGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [gradientStart, gradientEnd],
    );
  }
  
  /// Obtiene el gradiente de fondo
  static LinearGradient get backgroundGradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        backgroundLight,
        backgroundLight.withOpacity(0.8),
      ],
    );
  }
  
  /// Obtiene el gradiente para cards
  static LinearGradient get cardGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        surfaceLight,
        surfaceLight.withOpacity(0.95),
      ],
    );
  }
  
  /// Obtiene el color de sombra según la elevación
  static Color getShadowColor(int elevation) {
    switch (elevation) {
      case 1:
        return shadowLight;
      case 2:
        return shadowMedium;
      case 3:
        return shadowDark;
      default:
        return shadowMedium;
    }
  }
  
  /// Obtiene el color de texto según el fondo
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calcular el brillo del color de fondo
    final brightness = backgroundColor.computeLuminance();
    
    // Si el fondo es claro, usar texto oscuro
    if (brightness > 0.5) {
      return textPrimary;
    } else {
      return textOnPrimary;
    }
  }
  
  /// Obtiene el color de texto secundario según el fondo
  static Color getSecondaryTextColorForBackground(Color backgroundColor) {
    final brightness = backgroundColor.computeLuminance();
    
    if (brightness > 0.5) {
      return textSecondary;
    } else {
      return textOnPrimary.withOpacity(0.7);
    }
  }
  
  /// Obtiene el color de borde según el fondo
  static Color getBorderColorForBackground(Color backgroundColor) {
    final brightness = backgroundColor.computeLuminance();
    
    if (brightness > 0.5) {
      return borderLight;
    } else {
      return borderDark;
    }
  }
  
  /// Obtiene el color de divisor según el fondo
  static Color getDividerColorForBackground(Color backgroundColor) {
    final brightness = backgroundColor.computeLuminance();
    
    if (brightness > 0.5) {
      return dividerLight;
    } else {
      return dividerDark;
    }
  }
}
