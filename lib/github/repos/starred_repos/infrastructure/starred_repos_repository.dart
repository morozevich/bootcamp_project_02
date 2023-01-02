import 'package:bootcamp_project_02/core/domain/fresh.dart';
import 'package:bootcamp_project_02/core/infraestructure/network_exceptions.dart';
import 'package:bootcamp_project_02/github/core/domain/github_failure.dart';
import 'package:bootcamp_project_02/github/core/domain/github_repo.dart';
import 'package:bootcamp_project_02/github/core/infrastructure/github_repo_dto.dart';
import 'package:bootcamp_project_02/github/repos/starred_repos/infrastructure/starred_repos_remote_service.dart';
import 'package:dartz/dartz.dart';

class StarredReposRepository {
  final StarredReposRemoteService _remoteService;
  // TODO: implementar local service.

  StarredReposRepository(this._remoteService);

  Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> getStarredReposPage(
    int page,
  ) async {
    try {
      final remotePages = await _remoteService.getRepoStarredPage(page);
      return right(
        remotePages.when(
          noConnection: (maxPage) => Fresh.no(
            // TODO: implementar local service.
            [],
            isNextPageAvailable: page < maxPage,
          ),
          noModified: (maxPage) => Fresh.yes(
            // TODO: implementar local service.
            [],
            isNextPageAvailable: page < maxPage,
          ),
          withNewData: (data, maxPage) =>
          // TODO: save data in local service.
              Fresh.yes(
            data.toDomain(),
            isNextPageAvailable: page < maxPage,
          ),
        ),
      );
    } on RestApiException catch (e) {
      return left(GithubFailure.api(errorCode: e.errorCode));
    }
  }
}

extension DTOListToDomain on List<GithubRepoDTO> {
  List<GithubRepo> toDomain() {
    return map((e) => e.toDomain()).toList();
  }
}
