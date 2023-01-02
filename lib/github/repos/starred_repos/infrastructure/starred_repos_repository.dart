import 'package:bootcamp_project_02/github/core/domain/github_failure.dart';
import 'package:bootcamp_project_02/github/core/domain/github_repo.dart';
import 'package:bootcamp_project_02/github/repos/starred_repos/infrastructure/starred_repos_remote_service.dart';
import 'package:dartz/dartz.dart';

class StarredReposRepository {
  final StarredReposRemoteService _remoteService;
// TODO: implementar local service.

  StarredReposRepository(this._remoteService);

  Future<Either<GithubFailure, List<GithubRepo>>> getStarredReposPage(
    int page,
  ) async {}
}
