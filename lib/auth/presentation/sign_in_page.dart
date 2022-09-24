import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bootcamp_project_02/auth/shared/providers.dart';
import 'package:bootcamp_project_02/core/presentation/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetReference reference) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                MdiIcons.github,
                size: 150,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read(authNotifierProvider.notifier).signIn(
                    (authorizationUrl) {
                      final completer = Completer<Uri>();
                      AutoRouter.of(context).push(
                        AuthorizationRoute(
                          authorizationUrl: authorizationUrl,
                          onAuthorizationCodeRedirectAttempt: (redirectedUrl) {
                            completer.complete(redirectedUrl);
                          },
                        ),
                      );
                      return completer.future;
                    },
                  );
                },
                child: Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
