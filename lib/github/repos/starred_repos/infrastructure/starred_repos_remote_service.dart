import 'package:bootcamp_project_02/core/infraestructure/remote_response.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/github_headers.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/github_repo_dto.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/githuh_headers_cache.dart';
import 'package:dio/dio.dart';

class StarredReposRemoteService {
  final Dio _dio;
  final GithuhHeadersCache _githuhHeadersCache;

  StarredReposRemoteService(this._dio, this._githuhHeadersCache);

  Future<RemoteResponse<List<GithubRepoDTO>>?> getRepoStarrePage(
    int page,
  ) async {
    return null;
  }
}
