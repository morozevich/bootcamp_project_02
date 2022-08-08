import 'package:auto_route/annotations.dart';
import 'package:bootcamp_project_02/auth/presentation/sign_in_page.dart';
import 'package:bootcamp_project_02/splash/presentation/splash_page.dart';
import 'package:bootcamp_project_02/starred_repos/presentation/starred_repos_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(
      page: SplashPage,
      initial: true,
    ),
    MaterialRoute(
      page: SignInPage,
    ),
    MaterialRoute(
      page: StarredRepoPage,
    ),
  ],
  replaceInRouteName: 'Page,Route',
)
class $AppRouter {}
