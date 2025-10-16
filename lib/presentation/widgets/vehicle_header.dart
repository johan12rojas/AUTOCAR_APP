import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/vehicle_model.dart';

/// Widget que muestra la información del vehículo seleccionado
/// 
/// Incluye:
/// - Información básica del vehículo
/// - Selector de vehículos si hay múltiples
/// - Acceso rápido a funciones
class VehicleHeader extends StatelessWidget {
  final VehicleModel vehicle;
  final Function(VehicleModel) onVehicleChanged;

  const VehicleHeader({
    super.key,
    required this.vehicle,
    required this.onVehicleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    vehicle.isCar ? Icons.directions_car : Icons.motorcycle,
                    color: AppColors.primaryBlue,
                    size: 32,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        '${vehicle.formattedMileage} km',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                IconButton(
                  onPressed: () {
                    // TODO: Implementar selector de vehículos
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selector de vehículos en desarrollo'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Información adicional
            Row(
              children: [
                _buildInfoChip(
                  'Año',
                  vehicle.year.toString(),
                  Icons.calendar_today_outlined,
                ),
                
                const SizedBox(width: 12),
                
                _buildInfoChip(
                  'Tipo',
                  vehicle.typeText,
                  vehicle.isCar ? Icons.directions_car : Icons.motorcycle,
                ),
                
                const Spacer(),
                
                _buildInfoChip(
                  'Edad',
                  '${vehicle.ageInYears} años',
                  Icons.timeline_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
