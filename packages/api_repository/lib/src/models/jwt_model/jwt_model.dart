// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'jwt_model.freezed.dart';
part 'jwt_model.g.dart';

/// Класс JwtModel представляет модель JWT с токенами доступа и обновления.
@freezed
class JwtModel with _$JwtModel {
  /// Фабричный конструктор JwtModel.
  factory JwtModel({
    /// Токен обновления.
    @JsonKey(name: 'refresh') required String refresh,

    /// Токен доступа.
    @JsonKey(name: 'access') String? access,
  }) = _JwtModel;

  /// Создает JwtModel из JSON карты.
  factory JwtModel.fromJson(Map<String, dynamic> json) =>
      _$JwtModelFromJson(json);
}
