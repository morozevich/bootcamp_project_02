import 'package:bootcamp_project_02/core/infraestructure/dio_extensions.dart';
import 'package:bootcamp_project_02/core/infraestructure/network_exceptions.dart';
import 'package:bootcamp_project_02/core/infraestructure/remote_response.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/github_headers.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/github_repo_dto.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/githuh_headers_cache.dart';
import 'package:dio/dio.dart';

class StarredReposRemoteService {
  final Dio _dio;
  final GithuhHeadersCache _githuhHeadersCache;

  StarredReposRemoteService(this._dio, this._githuhHeadersCache);

  Future<RemoteResponse<List<GithubRepoDTO>>> getRepoStarredPage(
    int page,
  ) async {
    final token = 'test';
    final accept = 'application/vdn.github.v3.html+json';
    final requestUri = Uri.https(
      'api.github.com',
      '/user/starred',
      {
        'page': '$page',
      },
    );
    final previousHeaders = await _githuhHeadersCache.getHeaders(requestUri);
    try {
      final response = await _dio.getUri(
        requestUri,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
            'Accept': accept,
            'If-None-Match': previousHeaders?.etag ?? '',
          },
        ),
      );
      if (response.statusCode == 304) {
        return RemoteResponse.noModified(
          maxPage: previousHeaders?.link?.maxPage ?? 0,
        );
      } else if (response.statusCode == 200) {
        final gitHubHeaders = GithubHeaders.parse(response);
        await _githuhHeadersCache.saveHeaders(requestUri, gitHubHeaders);
        final converterData = (response.data as List<dynamic>)
            .map((e) => GithubRepoDTO.fromJson(e as Map<String, dynamic>))
            .toList();
        return RemoteResponse.withNewData(
          converterData,
          maxPage: gitHubHeaders.link?.maxPage ?? 1,
        );
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        return RemoteResponse.noConnection(
          maxPage: previousHeaders?.link?.maxPage ?? 0,
        );
      } else if (e.response != null) {
        throw RestApiException(e.response!.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
