// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'OpenCalories';

  @override
  String get scanMeal => 'Escanear Comida';

  @override
  String get proActive => 'OPEN CALORIES PRO: ACTIVO';

  @override
  String get alignFoodWithinFrame => 'Alinea la comida dentro del marco...';

  @override
  String get compressingImage => 'Comprimiendo imagen...';

  @override
  String get analyzingFood => 'Analizando comida...';

  @override
  String get analyzingProteins => 'Escaneando proteínas...';

  @override
  String get calculatingMacros => 'Calculando macros...';

  @override
  String get estimatingPortions => 'Estimando porciones...';

  @override
  String get analyzeFood => 'Analizar Comida';

  @override
  String analysisFailed(String error) {
    return 'Análisis fallido: $error';
  }

  @override
  String get tutorialCaptureTitle => 'Capturar Realidad';

  @override
  String get tutorialCaptureDesc =>
      'Toma una foto de tu comida directamente para iniciar el análisis.';

  @override
  String get tutorialLoadDataTitle => 'Cargar Datos';

  @override
  String get tutorialLoadDataDesc =>
      'Selecciona una foto existente de la galería de tu dispositivo.';

  @override
  String get tutorialTimeCapsuleTitle => 'Cápsula del Tiempo';

  @override
  String get tutorialTimeCapsuleDesc =>
      'Accede a tu registro completo de comidas pasadas y estadísticas diarias.';

  @override
  String get tutorialInspectComponentsTitle => 'Inspeccionar Componentes';

  @override
  String get tutorialInspectComponentsDesc =>
      'Cuando se detectan varios alimentos (ej. Hamburguesa + Papas), toca un elemento para ver su porción específica y macros individuales.';

  @override
  String get tutorialEraseHistoryTitle => 'Borrar Historial';

  @override
  String get tutorialEraseHistoryDesc =>
      'Desliza hacia la izquierda en cualquier tarjeta de comida para eliminarla de tu registro.';

  @override
  String get mealDetails => 'DETALLES DE COMIDA';

  @override
  String get analysis => 'ANÁLISIS';

  @override
  String get pro => 'Pro';

  @override
  String matchPercent(int percent) {
    return '$percent% Coincidencia';
  }

  @override
  String get detected => 'DETECTADO';

  @override
  String get detectedFoods => 'ALIMENTOS DETECTADOS';

  @override
  String get unknownFood => 'Alimento Desconocido';

  @override
  String get more => 'más';

  @override
  String get kcal => 'kcal';

  @override
  String get oneServing => '1 porción';

  @override
  String get notWhatYouAte => '¿No es lo que comiste? Ingresa manualmente';

  @override
  String get macroDistribution => 'DISTRIBUCIÓN DE MACROS';

  @override
  String get carbs => 'Carbos';

  @override
  String get protein => 'Proteína';

  @override
  String get fat => 'Grasa';

  @override
  String get retake => 'Repetir';

  @override
  String get logFood => 'Registrar Comida';

  @override
  String get noItemsToSave => 'No hay elementos para guardar';

  @override
  String get mealSavedToHistory => '¡Comida guardada en el historial!';

  @override
  String errorSavingMeal(String error) {
    return 'Error al guardar comida: $error';
  }

  @override
  String get connectIntelligence => 'Conectar Inteligencia';

  @override
  String get unlockGeminiAI => 'Desbloquea Gemini AI';

  @override
  String get geminiDescription =>
      'Para analizar tu comida con Open Calories, necesitamos conectar con el cerebro Gemini de Google.';

  @override
  String get apiKey => 'Clave API';

  @override
  String get getApiKeyHint =>
      '¿No tienes clave? Obtén una desde Google AI Studio';

  @override
  String get couldNotLaunchUrl => 'No se pudo abrir la URL';

  @override
  String get dailyCalorieGoal => 'Meta de Calorías Diarias';

  @override
  String get target => 'Meta';

  @override
  String get connectAndContinue => 'Conectar y Continuar';

  @override
  String get keyStoredLocally =>
      'Tu clave se guarda localmente en el dispositivo y nunca se comparte.';

  @override
  String get resetHints => 'Reiniciar Pistas';

  @override
  String get hintsReset =>
      '¡Pistas reiniciadas! Los tutoriales se mostrarán de nuevo.';

  @override
  String get pleaseEnterApiKey => 'Por favor ingresa una Clave API';

  @override
  String get invalidKeyFormat =>
      'Formato de clave inválido. Debe comenzar con \"AIza\" y tener 39 caracteres.';

  @override
  String get openCalories => 'OPEN CALORIES';

  @override
  String get seeWhat => 'Mira Lo Que ';

  @override
  String get youEat => 'Comes.';

  @override
  String get welcomeDescription =>
      'Análisis instantáneo de calorías y desglose de macros impulsado por Open Calories AI.';

  @override
  String get startScanning => 'Comenzar a Escanear';

  @override
  String get connectDevice => 'Conectar Dispositivo';

  @override
  String get deviceIntegrationComingSoon =>
      '¡Integración de dispositivo próximamente! ⌚';

  @override
  String get scanning => 'ESCANEANDO...';

  @override
  String get history => 'HISTORIAL';

  @override
  String get dailyTotal => 'TOTAL DIARIO';

  @override
  String percentOfDailyGoal(int percent, int goal) {
    return '$percent% de la meta diaria ($goal)';
  }

  @override
  String get noMealsLoggedToday => 'No hay comidas registradas hoy';

  @override
  String get noMealsLoggedForDay => 'No hay comidas registradas para este día';

  @override
  String get deleteMealTitle => '¿Eliminar Comida?';

  @override
  String get deleteActionCannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get mealDeleted => 'Comida eliminada';

  @override
  String get scanMealOption => 'Escanear Comida';

  @override
  String get useAiToAnalyze => 'Usa IA para analizar la foto de tu comida';

  @override
  String get manualEntry => 'Entrada Manual';

  @override
  String get typeInFoodAndPortion =>
      'Escribe el nombre del alimento y la porción';

  @override
  String today(String date) {
    return 'Hoy, $date';
  }

  @override
  String yesterday(String date) {
    return 'Ayer, $date';
  }

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del Sistema';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get enterNameAndPortionError => 'Ingrese nombre y porción primero';

  @override
  String get aiEstimationCompleted => '¡Estimación de IA completada!';

  @override
  String aiEstimationFailed(String error) {
    return 'Fallo en estimación de IA: $error';
  }

  @override
  String loggedFood(String name, int calories) {
    return 'Registrado $name con $calories kcal';
  }

  @override
  String get manualEntryTitle => 'ENTRADA MANUAL';

  @override
  String get requiredSection => 'REQUERIDO';

  @override
  String get tutorialDone => '¡Genial! Estás listo.';

  @override
  String get aiModel => 'Modelo de IA';

  @override
  String get aiModelDescription => 'Elige tu modelo de IA preferido';

  @override
  String get quotaErrorHint =>
      'Consejo: Cambia a Gemini 2.5 Flash en Configuración para más límites.';

  @override
  String get tutorialModelTitle => 'Cambiar Cerebro IA';

  @override
  String get tutorialModelDesc => 'Toca aquí para cambiar tu modelo de IA.';

  @override
  String get tutorialNameTitle => 'Nombra tu Alimento';

  @override
  String get tutorialNameDesc => 'Introduce el nombre de tu alimento.';

  @override
  String get foodNameLabel => 'Nombre';

  @override
  String get foodNameHint => 'ej. Tortillas';

  @override
  String get pleaseEnterName => 'Por favor ingresa un nombre';

  @override
  String get portionLabel => 'Porción';

  @override
  String get portionHint => 'ej. 2 piezas';

  @override
  String get pleaseEnterPortion => 'Por favor ingresa una porción';

  @override
  String get tutorialAiTitle => 'Asistente IA';

  @override
  String get tutorialAiDesc => 'Deja que Gemini estime las calorías.';

  @override
  String get estimating => 'ESTIMANDO...';

  @override
  String get estimateWithAiAction => 'ESTIMAR CON IA';

  @override
  String get nutritionOptionalSection => 'NUTRICIÓN (OPCIONAL)';

  @override
  String get tutorialFineTuneTitle => 'Ajustar Datos';

  @override
  String get tutorialFineTuneDesc =>
      'Ajusta manualmente la info nutricional si es necesario.';

  @override
  String get logMealAction => 'REGISTRAR COMIDA';

  @override
  String get caloriesLabel => 'Calorías';

  @override
  String get weeklyInsights => 'RESUMEN SEMANAL';

  @override
  String get tutorialTimeTravelTitle => 'Viaje en el Tiempo';

  @override
  String get tutorialTimeTravelDesc =>
      'Usa las flechas para ver semanas anteriores.';

  @override
  String get tutorialSelectDayTitle => 'Selecciona un Día';

  @override
  String get tutorialSelectDayDesc => 'Toca un día para ver su historial.';

  @override
  String get noFoodDetected =>
      'No se detectó comida en la imagen. Por favor, escanea una comida.';

  @override
  String get editFoodItem => 'Editar Alimento';

  @override
  String get foodName => 'Nombre del Alimento';

  @override
  String get save => 'Guardar';

  @override
  String foodsDetectedCount(int count) {
    return '$count Alimentos Detectados';
  }

  @override
  String get editDetails => 'Editar';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';

  @override
  String get gallery => 'Galería';

  @override
  String get saveWithoutReestimating => 'Guardar sin reestimar';
}
