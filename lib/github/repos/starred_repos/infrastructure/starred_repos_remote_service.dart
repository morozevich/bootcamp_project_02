import 'package:bootcamp_project_02/core/infraestructure/remote_response.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/github_repo_dto.dart';
import 'package:dio/dio.dart';

class StarredReposRemoteService {
  final Dio _dio;

  StarredReposRemoteService(this._dio);

  Future<RemoteResponse<List<GithubRepoDTO>>> getRepoStarrePage(
    int page,
  ) async {}
}
