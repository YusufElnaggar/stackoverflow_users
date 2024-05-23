import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../configs/app_configs.dart';
import '../../utils/constants/constants.dart';
import '../../domain/models/failures.dart';
import 'network_service.dart';

class HttpNetworkService extends NetworkService {
  final http.Client httpClient;
  HttpNetworkService(this.httpClient);

  String get baseUrl => AppConfigs.baseUrl;
  String get baseUrlPath => AppConfigs.baseUrlPath;

  @override
  Future<Either<Failure, JsonMap>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    var uri = Uri.https(baseUrl, baseUrlPath + url, queryParameters);

    var response = await httpClient.get(
      uri,
      headers: _getHeaders(headers),
    );

    return await _handleResponse(
      response,
    );
  }

  Future<Either<Failure, JsonMap>> _handleResponse(
    http.Response response,
  ) async {
    try {
      if (response.statusCode == kSuccess ||
          response.statusCode == kSuccessCreated) {
        return right(jsonDecode(response.body) as JsonMap);
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['error_message'];
        return left(
          DataSourceFailure(
            message: errorMessage,
          ),
        );
      }
    } on FormatException {
      return left(
        WrongDataFailure(),
      );
    } on SocketException {
      return left(
        OfflineFailure(),
      );
    } on HttpException {
      return left(
        OfflineFailure(),
      );
    } catch (error) {
      debugPrint('Error: $error');
      return left(
        ServerFailure(),
      );
    }
  }

  Map<String, String> _getHeaders(Map<String, String>? extraHeaders) {
    Map<String, String> headers = {
      'Accept': 'application/json;charset=utf-t',
      'Accept-Language': 'en',
    };
    if (extraHeaders != null) headers.addAll(extraHeaders);
    return headers;
  }
}
