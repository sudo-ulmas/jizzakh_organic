import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(const SlaughterhouseApp());
}

class SlaughterhouseApp extends StatelessWidget {
  const SlaughterhouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          final goRouter = context.read<AppRouter>().goRouter;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme().light,
            darkTheme: AppTheme().dark,
            themeMode: state,
            routeInformationParser: goRouter.routeInformationParser,
            routeInformationProvider: goRouter.routeInformationProvider,
            routerDelegate: goRouter.routerDelegate,
          );
        },
      ),
    );
  }
}

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit()),
          Provider(create: (context) => AppRouter()),
          Provider<AnimalRepository>(
            create: (context) => FakeAnimalRepository(),
          ),
        ],
        child: child,
      );
}
