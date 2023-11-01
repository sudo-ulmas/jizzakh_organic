import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/presentation/login/bloc/login_bloc.dart';
import 'package:uboyniy_cex/util/util.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.read<ThemeCubit>().state;
    return BlocProvider(
      create: (context) => LoginBloc(authRepository: context.read())
        ..add(const LoginEvent.tryLogin()),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginTryFail) {
              context.go(PagePath.loginRoute);
            } else if (state is LoginSuccess) {
              context.go(PagePath.animals);
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.img.logo.image(
                  color: themeMode == ThemeMode.dark
                      ? context.theme.colorScheme.primary
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
