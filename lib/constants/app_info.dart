/// Константы с информацией о приложении и разработчике
/// Измените эти значения по необходимости
class AppInfo {
  AppInfo._();

  /// Название приложения
  static const String appName = 'Shuffle Match';

  /// Версия приложения (формат: major.minor.patch+build)
  static const String appVersion = '1.0.0';

  /// Номер сборки
  static const String buildNumber = '1';

  /// Имя разработчика или компании
  static const String developerName = 'Arvo Lepp';

  /// Email разработчика
  static const String developerEmail = 'Pak.nain55@gmail.com';

  /// Веб-сайт разработчика (опционально)
  static const String? developerWebsite = null;

  /// Год создания приложения
  static const String copyrightYear = '2025';

  /// Описание приложения
  static const String appDescription =
      'A collection of randomizers and decision-making tools.';

  static String privacyPolicyUrl =
      'https://sites.google.com/view/shuffle-n-match-privacy-policy/';

  /// Полная версия приложения (версия + номер сборки)
  static String get fullVersion => '$appVersion+$buildNumber';
}
