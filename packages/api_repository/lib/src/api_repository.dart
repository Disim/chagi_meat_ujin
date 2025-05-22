import 'dart:io';

import 'package:dio/dio.dart';
import 'package:log_service/log_service.dart';
import 'package:maestro_api/maestro_api.dart';
import 'models/models.dart';
import 'providers/providers.dart';

/// Репозиторий для работы с API Maestro
class ApiRepository {
  /// Фабричный конструктор для создания экземпляра MaestroApiRepository
  ///
  /// [basePath] - базовый URL для API.
  /// [configName] - имя конфигурации, используемое для логирования.
  factory ApiRepository(
    String basePath,
    String configName,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: basePath,
        contentType: 'application/json; charset=UTF-8',
        validateStatus: (_) => true,
      ),
    );

    final logService = LogService();

    final generatedApi = MaestroApi(dio: dio);
    final authApi = generatedApi.getAuthApi();
    final clientApi = generatedApi.getClientApi();

    final authRestProvider = AuthRestProvider(
      authApi,
      logService,
      configName,
    );

    final userRestProvider = UserRestProvider(authApi);
    final zsRestProvider = ZsRestProvider(clientApi, logService);
    final authWsProvider = AuthWsProvider(clientApi);

    var refreshing = false;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          if (authRestProvider.accessToken != null &&
              !options.headers.keys.contains(HttpHeaders.RefreshToken)) {
            final h = options.headers;
            h[HttpHeaders.AccessToken] =
                'Bearer ${authRestProvider.accessToken}';
            final newOpt = options.copyWith(headers: h);
            handler.next(newOpt);
          } else {
            handler.next(options);
          }
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == HttpStatus.unauthorized) {
            if (e.requestOptions.extra['isRetry'] == null) {
              if (refreshing) {
                await Future<void>.delayed(const Duration(seconds: 1));
                final response = await dio
                    .fetch<Response<Map<String, dynamic>>>(e.requestOptions);
                return handler.resolve(response);
              }
              refreshing = true;
              final isUpdated = await authRestProvider.refreshTokens();
              refreshing = false;
              if (isUpdated) {
                await logService.log('SUCCESSFUL REFRESH');
                final newRequest =
                    await dio.fetch<Response<Map<String, dynamic>>>(
                  e.requestOptions.copyWith(
                    extra: {'isRetry': true},
                  ),
                );
                return handler.resolve(newRequest);
              }
            }
            await authRestProvider.clearTokens();
          }
          if (e.response != null) {
            return handler.resolve(e.response!);
          } else {
            return handler.reject(e);
          }
        },
      ),
    );

    return ApiRepository._internal(
      authRestProvider,
      userRestProvider,
      zsRestProvider,
      authWsProvider,
    );
  }

  /// Приватный конструктор для внутреннего использования
  ApiRepository._internal(
    this.authRestProvider,
    this.userRestProvider,
    this.zsRestProvider,
    this.authWsProvider,
  );

  /// Провайдер для работы с аутентификацией
  final AuthRestProvider authRestProvider;

  /// Провайдер для работы с данными пользователя
  final UserRestProvider userRestProvider;

  /// Провайдер для работы с зарядными станциями
  final ZsRestProvider zsRestProvider;

  /// Провайдер для работы с аутентификацией WebSocket
  final AuthWsProvider authWsProvider;
}
