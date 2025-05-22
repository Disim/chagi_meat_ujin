// ignore_for_file: constant_identifier_names

/// Абстрактный класс HttpHeaders содержит статические константы для заголовков
/// HTTP.
abstract class HttpHeaders {
  /// Заголовок для доступа токена.
  static const AccessToken = 'Authorization';

  /// Заголовок для токена обновления.
  static const RefreshToken = 'refresh';
}
