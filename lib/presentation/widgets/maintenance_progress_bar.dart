import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/maintenance_intervals.dart';

/// Widget que muestra una barra de progreso para un tipo de mantenimiento
/// 
/// Incluye:
/// - Icono del tipo de mantenimiento
/// - Barra de progreso con color según el estado
/// - Porcentaje de vida útil restante
/// - Información adicional
class MaintenanceProgressBar extends StatelessWidget {
  final String maintenanceType;
  final int percentage;
  final VoidCallback? onTap;

  const MaintenanceProgressBar({
    super.key,
    required this.maintenanceType,
    required this.percentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getPercentageColor(percentage);
    final backgroundColor = AppColors.getPercentageBackgroundColor(percentage);
    final maintenanceName = MaintenanceIntervals.getMaintenanceName(maintenanceType);
    final maintenanceIcon = MaintenanceIntervals.getMaintenanceIcon(maintenanceType);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  maintenanceIcon,
                  style: const TextStyle(fontSize: 20),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: Text(
                    maintenanceName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$percentage%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Información adicional
            Row(
              children: [
                Text(
                  _getStatusText(percentage),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const Spacer(),
                
                Text(
                  _getStatusDescription(percentage),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(int percentage) {
    if (percentage < 30) return 'Crítico';
    if (percentage < 50) return 'Próximo';
    if (percentage < 80) return 'Bueno';
    return 'Excelente';
  }

  String _getStatusDescription(int percentage) {
    if (percentage < 30) return 'Requiere atención inmediata';
    if (percentage < 50) return 'Próximo a mantenimiento';
    if (percentage < 80) return 'En buen estado';
    return 'Estado óptimo';
  }
}
