import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Pantalla de historial de mantenimientos
/// 
/// Muestra el historial completo de mantenimientos
/// con filtros y opciones de gestión.
class LogbookScreen extends StatelessWidget {
  const LogbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.logbookTitle),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history_outlined,
                size: 80,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 16),
              Text(
                'Historial de Mantenimientos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Función en desarrollo',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
