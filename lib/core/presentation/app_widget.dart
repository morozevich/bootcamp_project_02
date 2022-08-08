import 'package:bootcamp_project_02/core/presentation/routes/app_router.gr.dart';
import 'package:bootcamp_project_02/splash/presentation/splash_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Repo Viewer',
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
