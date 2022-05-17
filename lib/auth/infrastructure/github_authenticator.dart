import 'dart:io';

import 'package:bootcamp_project_02/auth/domain/auth_failure.dart';
import 'package:bootcamp_project_02/auth/infrastructure/credentials_storage/credentials_storage.dart';
import 'package:bootcamp_project_02/core/infraestructure/dio_extensions.dart';
import 'package:bootcamp_project_02/core/shared/encoder.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';

class GitubOAutHttClient extends http.BaseClient {
  final httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return httpClient.send(request);
  }
}

class GithubAuthenticator {
  final CredentialsStorage _credentialsStorage;
  final Dio _dio;

  GithubAuthenticator(this._credentialsStorage, this._dio);

  static const clientId = '1e5ffe4f0037fa5a7ad7';
  static const clientSecret = 'bf30151eee9f00b91c0627a8e9fe3360bb4d73c5';
  static final authorizationEndPoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static final tokenEndPoint =
      Uri.parse('https://github.com/login/oauth/acess_token');
  static final redirectUrl = Uri.parse('http://localhost:3000/callback');
  static final scopes = ['read:user', 'repo'];
  static final revocationEndPoint =
      Uri.parse('https://api.github.com/applications/$clientId/token');

  Future<Credentials?> getSignedInCredentials() async {
    try {
      final storedCredentials = await _credentialsStorage.read();
      if (storedCredentials != null) {
        if (storedCredentials.canRefresh && storedCredentials.isExpired) {
          final failureOrCredentials = await refresh(storedCredentials);
          return failureOrCredentials.fold((l) => null, (r) => r);
        }
      }
      return storedCredentials;
    } on PlatformException {
      return null;
    }
  }

  Future<void> isSignedIn() =>
      getSignedInCredentials().then((credentials) => credentials != null);

  AuthorizationCodeGrant createGrant() {
    return AuthorizationCodeGrant(
      clientId,
      authorizationEndPoint,
      tokenEndPoint,
      secret: clientSecret,
    );
  }

  Uri getAuthorizationUrl(AuthorizationCodeGrant grant) {
    return grant.getAuthorizationUrl(
      redirectUrl,
      scopes: scopes,
    );
  }

  Future<Either<AuthFailure, Unit>> handleAuthorizationResponse(
    AuthorizationCodeGrant grant,
    Map<String, String> queryParams,
  ) async {
    try {
      final httpClient = await grant.handleAuthorizationResponse(queryParams);
      await _credentialsStorage.save(httpClient.credentials);
      return right(unit);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (error) {
      return left(AuthFailure.server('${error.error} ${error.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> signOut() async {
    final accessToken = await _credentialsStorage
        .read()
        .then((credentials) => credentials?.accessToken);
    final usernameAnPass = stringToBase64.encode('$clientId:$clientSecret');
    try {
      try {
        await _dio.deleteUri(
          revocationEndPoint,
          data: {
            'access_token': accessToken,
          },
          options: Options(
            headers: {
              'Authorization': 'basic $usernameAnPass',
            },
          ),
        );
      } on DioError catch (e) {
        if (e.isNoConnectionError) {
          print('Token revoke');
        } else {
          rethrow;
        }
      }
      await _credentialsStorage.clear();
      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Credentials>> refresh(
    Credentials credentials,
  ) async {
    try {
      final refreshedCredentials = await credentials.refresh(
            identifier: clientId,
            secret: clientSecret,
            httpClient: GitubOAutHttClient(),
          );
      await _credentialsStorage.save(refreshedCredentials);
      return right(refreshedCredentials);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error}: ${e.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }
}
