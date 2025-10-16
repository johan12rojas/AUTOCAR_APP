/// Textos y strings de la aplicación AutoCare
/// 
/// Centraliza todos los textos utilizados en la aplicación
/// para facilitar la localización y mantenimiento.
class AppStrings {
  // Títulos de pantallas
  static const String welcomeTitle = 'Bienvenido a AutoCare';
  static const String loginTitle = 'Iniciar Sesión';
  static const String signupTitle = 'Crear Cuenta';
  static const String homeTitle = 'Inicio';
  static const String logbookTitle = 'Historial';
  static const String notificationsTitle = 'Notificaciones';
  static const String profileTitle = 'Perfil';
  
  // Mensajes de bienvenida
  static const String welcomeMessage = 'Gestiona el mantenimiento de tus vehículos de manera inteligente';
  static const String welcomeSubtitle = 'Mantén tus vehículos en perfecto estado con recordatorios automáticos';
  
  // Botones
  static const String loginButton = 'Iniciar Sesión';
  static const String signupButton = 'Crear Cuenta';
  static const String logoutButton = 'Cerrar Sesión';
  static const String saveButton = 'Guardar';
  static const String cancelButton = 'Cancelar';
  static const String deleteButton = 'Eliminar';
  static const String editButton = 'Editar';
  static const String addButton = 'Agregar';
  static const String completeButton = 'Completar';
  static const String scheduleButton = 'Programar';
  static const String updateButton = 'Actualizar';
  
  // Formularios
  static const String nameLabel = 'Nombre completo';
  static const String emailLabel = 'Correo electrónico';
  static const String passwordLabel = 'Contraseña';
  static const String confirmPasswordLabel = 'Confirmar contraseña';
  static const String makeLabel = 'Marca';
  static const String modelLabel = 'Modelo';
  static const String yearLabel = 'Año';
  static const String mileageLabel = 'Kilometraje actual';
  static const String typeLabel = 'Tipo de vehículo';
  static const String notesLabel = 'Notas';
  static const String costLabel = 'Costo';
  static const String locationLabel = 'Ubicación';
  static const String dateLabel = 'Fecha';
  
  // Placeholders
  static const String namePlaceholder = 'Ingresa tu nombre completo';
  static const String emailPlaceholder = 'ejemplo@correo.com';
  static const String passwordPlaceholder = 'Mínimo 6 caracteres';
  static const String makePlaceholder = 'Ej: Toyota, Honda, Ford';
  static const String modelPlaceholder = 'Ej: Corolla, Civic, Focus';
  static const String mileagePlaceholder = 'Ej: 45000';
  static const String notesPlaceholder = 'Observaciones adicionales...';
  static const String costPlaceholder = '0.00';
  static const String locationPlaceholder = 'Taller, ubicación...';
  
  // Validaciones
  static const String nameRequired = 'El nombre es requerido';
  static const String nameMinLength = 'El nombre debe tener al menos 2 caracteres';
  static const String emailRequired = 'El correo electrónico es requerido';
  static const String emailInvalid = 'Ingresa un correo electrónico válido';
  static const String passwordRequired = 'La contraseña es requerida';
  static const String passwordMinLength = 'La contraseña debe tener al menos 6 caracteres';
  static const String passwordsNotMatch = 'Las contraseñas no coinciden';
  static const String makeRequired = 'La marca es requerida';
  static const String modelRequired = 'El modelo es requerido';
  static const String yearRequired = 'El año es requerido';
  static const String yearInvalid = 'Ingresa un año válido';
  static const String mileageRequired = 'El kilometraje es requerido';
  static const String mileageInvalid = 'Ingresa un kilometraje válido';
  
  // Mensajes de éxito
  static const String loginSuccess = '¡Bienvenido de nuevo!';
  static const String signupSuccess = '¡Cuenta creada exitosamente!';
  static const String vehicleAddedSuccess = '¡Vehículo agregado exitosamente!';
  static const String maintenanceScheduledSuccess = '¡Mantenimiento programado!';
  static const String maintenanceCompletedSuccess = '¡Mantenimiento completado!';
  static const String profileUpdatedSuccess = '¡Perfil actualizado!';
  
  // Mensajes de error
  static const String loginError = 'Error al iniciar sesión';
  static const String signupError = 'Error al crear la cuenta';
  static const String networkError = 'Error de conexión';
  static const String unknownError = 'Error desconocido';
  static const String userNotFound = 'Usuario no encontrado';
  static const String wrongPassword = 'Contraseña incorrecta';
  static const String emailExists = 'Ya existe una cuenta con este correo';
  
  // Estados de mantenimiento
  static const String completedStatus = 'Completado';
  static const String pendingStatus = 'Pendiente';
  static const String urgentStatus = 'Urgente';
  static const String goodStatus = 'Bueno';
  static const String criticalStatus = 'Crítico';
  static const String upcomingStatus = 'Próximo';
  
  // Tipos de vehículos
  static const String carType = 'Carro';
  static const String motorcycleType = 'Moto';
  
  // Tipos de mantenimiento
  static const String oilMaintenance = 'Aceite de Motor';
  static const String tiresMaintenance = 'Llantas';
  static const String brakesMaintenance = 'Frenos';
  static const String batteryMaintenance = 'Batería';
  static const String coolantMaintenance = 'Refrigerante';
  static const String airFilterMaintenance = 'Filtro de Aire';
  static const String alignmentMaintenance = 'Alineación';
  static const String chainMaintenance = 'Cadena';
  static const String sparkPlugMaintenance = 'Bujía';
  
  // Prioridades
  static const String highPriority = 'Alta';
  static const String mediumPriority = 'Media';
  static const String lowPriority = 'Baja';
  
  // Mensajes de notificaciones
  static const String welcomeNotificationTitle = '¡Bienvenido a AutoCare!';
  static const String welcomeNotificationMessage = 'Gracias por usar AutoCare. Tu vehículo ha sido configurado con datos de ejemplo.';
  static const String vehicleAddedNotificationTitle = '¡Vehículo Agregado!';
  static const String vehicleAddedNotificationMessage = 'Tu vehículo ha sido agregado exitosamente.';
  static const String maintenanceCriticalTitle = 'Mantenimiento Crítico';
  static const String maintenanceCriticalMessage = 'El mantenimiento está en nivel crítico. Se recomienda atención inmediata.';
  static const String maintenancePendingTitle = 'Mantenimiento Pendiente';
  static const String maintenancePendingMessage = 'Tienes un mantenimiento programado próximamente.';
  static const String maintenanceCompletedTitle = 'Mantenimiento Completado';
  static const String maintenanceCompletedMessage = '¡Excelente! El mantenimiento ha sido completado exitosamente.';
  
  // Estadísticas
  static const String totalMaintenance = 'Total Mantenimientos';
  static const String onTimeCompletions = 'Completados a Tiempo';
  static const String currentStreak = 'Racha Actual';
  static const String experienceLevel = 'Nivel de Experiencia';
  static const String punctualityLevel = 'Nivel de Puntualidad';
  
  // Configuración
  static const String settingsTitle = 'Configuración';
  static const String notificationsSettings = 'Notificaciones';
  static const String themeSettings = 'Tema';
  static const String languageSettings = 'Idioma';
  static const String aboutSettings = 'Acerca de';
  static const String privacySettings = 'Privacidad';
  static const String termsSettings = 'Términos de Servicio';
  
  // Información de la app
  static const String aboutApp = 'AutoCare es una aplicación para gestionar el mantenimiento de tus vehículos de manera inteligente.';
  static const String versionInfo = 'Versión';
  static const String developerInfo = 'Desarrollado por';
  static const String contactInfo = 'Contacto';
  
  // Mensajes de confirmación
  static const String confirmDelete = '¿Estás seguro de que quieres eliminar este elemento?';
  static const String confirmLogout = '¿Estás seguro de que quieres cerrar sesión?';
  static const String confirmDeleteAccount = '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.';
  
  // Mensajes informativos
  static const String noVehiclesMessage = 'No tienes vehículos registrados. Agrega tu primer vehículo para comenzar.';
  static const String noMaintenancesMessage = 'No hay mantenimientos registrados para este vehículo.';
  static const String noNotificationsMessage = 'No tienes notificaciones pendientes.';
  static const String loadingMessage = 'Cargando...';
  static const String emptyStateMessage = 'No hay datos para mostrar';
  
  // Accesibilidad
  static const String accessibilityAddVehicle = 'Agregar nuevo vehículo';
  static const String accessibilityScheduleMaintenance = 'Programar mantenimiento';
  static const String accessibilityCompleteMaintenance = 'Completar mantenimiento';
  static const String accessibilityViewProfile = 'Ver perfil';
  static const String accessibilitySettings = 'Configuración';
}
