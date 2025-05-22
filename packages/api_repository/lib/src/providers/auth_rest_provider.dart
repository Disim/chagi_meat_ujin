import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:log_service/log_service.dart';
import 'package:maestro_api/maestro_api.dart';
import '../models/jwt_model/jwt_model.dart';

/// Провайдер, работающий с методами аутентификации пользователя
class AuthRestProvider {
  /// Конструктор
  AuthRestProvider(
    this._authApi,
    this._logService,
    this._configName,
  );

  /// Хранилище с refresh токенами
  final _storage = const FlutterSecureStorage();

  final AuthApi _authApi;
  final LogService _logService;
  final String _configName;

  late JwtModel _tokens;

  /// Токен доступа текущего пользователя. Если пользователь не
  /// авторизован - null
  String? get accessToken => _tokens.access;

  /// Проверка на наличие refresh токена
  bool get hasRefreshToken => _tokens.refresh.isNotEmpty;

  /// Метод инициализации с обновлением пользовательских данных для
  /// аутентификации
  Future<void> init() async {
    final refresh = await _storage.read(key: _configName);
    _tokens = JwtModel(refresh: refresh ?? '');
  }

  /// Запрос на отправку СМС. Возвращает uuid
  Future<String?> requestCode(String phone, String deviceId) async {
    final deviceData = DeviceData(
      (data) => data
        ..phone = phone
        ..deviceId = deviceId,
    );
    final request =
        await _authApi.loginClientAuthLoginClientPost(deviceData: deviceData);
    return request.data?.uuid;
  }

  /// Метод проверки кода для авторизации. Если пользователь вводит верный код -
  /// метод вернет токены [JwtModel]. Если не верный - null
  Future<JwtModel?> checkCode(
    String phone,
    String uuid,
    String code,
    String deviceId,
  ) async {
    final response = await _authApi.authCheckCodeAuthCheckCodePost(
      bodyAuthCheckCodeAuthCheckCodePost: BodyAuthCheckCodeAuthCheckCodePost(
        (data) => data
          ..smsData = SmsData(
            (data) => data
              ..phone = phone
              ..code = code
              ..uuid = uuid,
          ).toBuilder()
          ..deviceData = DeviceData(
            (data) => data
              ..deviceId = deviceId
              ..phone = phone,
          ).toBuilder(),
      ),
    );

    final jwtModel = JwtModel(
      refresh: response.data!.refreshToken,
      access: response.data!.accessToken,
    );

    await _updateTokens(jwtModel);

    return jwtModel;
  }

  Future<Response<AuthTockensResponse>> _refreshToken(
    String refreshToken,
  ) =>
      _authApi.refreshTokenAuthRefreshTokenPost(
        refreshToken: RefreshToken((data) => data..value = refreshToken),
      );

  /// Внутренний метод, не для внешнего использования. Обновляет токены в
  /// хранилище [_storage] и в локальной переменной [_tokens].
  Future<void> _updateTokens(JwtModel tokens) async {
    _tokens = tokens;
    await _storage.write(key: _configName, value: tokens.refresh);
  }

  /// Запрос на удаление пользователя. Не помню что возвращает, требуется
  /// протестировать.
  Future<bool> removeUser(
    String phone,
    String deviceId,
  ) async {
    final request = await _authApi.removeUserAuthRemoveUserPost(
      deviceData: DeviceData(
        (data) => data
          ..deviceId = deviceId
          ..phone = phone,
      ),
    );
    if (request.statusCode != 200) {
      throw Exception();
    }
    return true;
  }

  /// Внутренний метод, не для внешнего использования. Необходим для работы
  /// Dio клиента. Автоматически обновляет токены по необходимости. Если нет
  /// refresh токена - вернет ошибку "No token".
  Future<bool> refreshTokens() async {
    final refresh = await _storage.read(key: _configName);
    try {
      if (refresh?.isEmpty ?? true) {
        await _logService.log('No token. $_configName');
        return false;
      }

      final result = await _refreshToken(refresh!);
      if (result.statusCode == 200) {
        final newTokens = JwtModel(
          refresh: result.data!.refreshToken,
          access: result.data!.accessToken,
        );
        await _updateTokens(newTokens);
        return true;
      }
    } on DioException catch (e) {
      await _logService.logError('Refresh tokens error:\n$e');
    } catch (e) {
      await _logService.logError(e.toString());
    }

    return false;
  }

  /// Метод для чистки токенов из хранилища. Отмечает пользователя
  /// неавторизованным.
  Future<void> clearTokens() async {
    await _logService.log('Удаление токена из памяти');
    await _storage.delete(key: _configName);
  }
}
