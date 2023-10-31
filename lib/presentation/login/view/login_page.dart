import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uboyniy_cex/presentation/login/bloc/login_bloc.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeMode = context.read<ThemeCubit>().state;
    return BlocProvider(
      create: (context) => LoginBloc(authRepository: context.read()),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    );
                  },
                ),
                Assets.img.logo.image(
                  scale: 1.5,
                  color: themeMode == ThemeMode.dark
                      ? context.theme.colorScheme.primary
                      : null,
                ),
                Text(
                  'Убойный Цех',
                  style: context.theme.textTheme.headlineLarge?.copyWith(
                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                    color: themeMode == ThemeMode.dark
                        ? context.theme.colorScheme.primary
                        : AppColors.seedLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Авторизуйтесь',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    _usernameController.text = state.username;
                    return InputField(
                      title: 'Имя пользователя',
                      controller: _usernameController,
                    );
                  },
                ),
                const SizedBox(height: 12),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) => InputField(
                    title: 'Пароль',
                    controller: _passwordController,
                    isPassoword: true,
                    textInputAction: TextInputAction.done,
                    onInputSubmitted: (p0) => context.read<LoginBloc>().add(
                          LoginEvent.login(
                            username: _usernameController.text,
                            password: _passwordController.text,
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        context.go(PagePath.animals);
                      } else if (state is LoginError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.exception.message()),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return FilledButton(
                        onPressed: () => context.read<LoginBloc>().add(
                              LoginEvent.login(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              ),
                            ),
                        child: switch (state) {
                          LoginInProgress() => const CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          _ => Text(
                              'Войти',
                              style:
                                  context.theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
