import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../providers/vehicle_provider.dart';
import '../providers/maintenance_provider.dart';
import '../widgets/vehicle_header.dart';
import '../widgets/maintenance_progress_bar.dart';

/// Pantalla principal de inicio
/// 
/// Muestra:
/// - Información del vehículo seleccionado
/// - Estados de mantenimiento con barras de progreso
/// - Alertas importantes
/// - Acceso rápido a funciones principales
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeTitle),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Consumer<VehicleProvider>(
          builder: (context, vehicleProvider, child) {
            if (vehicleProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!vehicleProvider.hasVehicles) {
              return _buildNoVehiclesState();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header del vehículo
                  VehicleHeader(
                    vehicle: vehicleProvider.selectedVehicle!,
                    onVehicleChanged: (vehicle) {
                      vehicleProvider.selectVehicle(vehicle);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Estados de mantenimiento
                  _buildMaintenanceStates(),
                  
                  const SizedBox(height: 24),
                  
                  // Alertas importantes
                  _buildAlertsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Acciones rápidas
                  _buildQuickActions(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoVehiclesState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 60,
                color: AppColors.primaryBlue,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              AppStrings.noVehiclesMessage,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Agrega tu primer vehículo para comenzar a gestionar sus mantenimientos',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementar diálogo para agregar vehículo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función en desarrollo'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar Vehículo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceStates() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estados de Mantenimiento',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de estados de mantenimiento
            ...List.generate(7, (index) {
              final maintenanceTypes = [
                'oil', 'tires', 'brakes', 'battery', 
                'coolant', 'airFilter', 'alignment'
              ];
              final type = maintenanceTypes[index];
              final percentage = 100 - (index * 15); // Datos de ejemplo
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: MaintenanceProgressBar(
                  maintenanceType: type,
                  percentage: percentage,
                  onTap: () {
                    // TODO: Implementar navegación a detalles
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: AppColors.warningOrange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Alertas Importantes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Lista de alertas (datos de ejemplo)
            _buildAlertItem(
              'Aceite de Motor',
              'Nivel crítico - Cambio requerido',
              AppColors.urgentRed,
              Icons.oil_barrel_outlined,
            ),
            
            const SizedBox(height: 12),
            
            _buildAlertItem(
              'Frenos',
              'Próximo mantenimiento en 500 km',
              AppColors.pendingOrange,
              Icons.car_repair_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(String title, String message, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHint,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones Rápidas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    'Programar Mantenimiento',
                    Icons.schedule_outlined,
                    AppColors.primaryBlue,
                    () {
                      // TODO: Implementar diálogo de programación
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    'Actualizar Kilometraje',
                    Icons.speed_outlined,
                    AppColors.oilGreen,
                    () {
                      // TODO: Implementar diálogo de kilometraje
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
