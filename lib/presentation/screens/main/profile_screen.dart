import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/welcome_screen.dart';

/// Pantalla de perfil del usuario
/// 
/// Muestra información del usuario, estadísticas
/// y opciones de configuración.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profileTitle),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.currentUser == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final user = authProvider.currentUser!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Información del usuario
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primaryBlue,
                            child: Text(
                              user.initials,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Text(
                            user.displayName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          
                          const SizedBox(height: 4),
                          
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.oilGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              user.experienceLevel,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.oilGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Estadísticas
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estadísticas',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Vehículos',
                                  '1',
                                  Icons.directions_car_outlined,
                                  AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  'Mantenimientos',
                                  '5',
                                  Icons.build_outlined,
                                  AppColors.oilGreen,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Completados',
                                  '3',
                                  Icons.check_circle_outlined,
                                  AppColors.completedGreen,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  'Pendientes',
                                  '2',
                                  Icons.schedule_outlined,
                                  AppColors.pendingOrange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Opciones
                  Card(
                    child: Column(
                      children: [
                        _buildOptionTile(
                          'Configuración',
                          Icons.settings_outlined,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Configuración en desarrollo'),
                              ),
                            );
                          },
                        ),
                        
                        const Divider(height: 1),
                        
                        _buildOptionTile(
                          'Acerca de',
                          Icons.info_outlined,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Acerca de en desarrollo'),
                              ),
                            );
                          },
                        ),
                        
                        const Divider(height: 1),
                        
                        _buildOptionTile(
                          'Ayuda',
                          Icons.help_outlined,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ayuda en desarrollo'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botón de cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout),
                      label: const Text(AppStrings.logoutButton),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        side: BorderSide(color: AppColors.errorRed),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textHint,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                );
              }
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }
}
