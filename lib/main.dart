import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uboyniy_cex/bloc/queue_bloc.dart';
import 'package:uboyniy_cex/presentation/add_nomenclature/view/bloc/nomenclatures_cubit.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorageRepository = await HiveLocalStorageRepository.init();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(
    SlaughterhouseApp(
      localStorageRepository: localStorageRepository,
    ),
  );
}

class SlaughterhouseApp extends StatelessWidget {
  const SlaughterhouseApp({required this.localStorageRepository, super.key});

  final LocalStorageRepository localStorageRepository;

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      localStorageRepository: localStorageRepository,
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          final goRouter = context.read<AppRouter>().goRouter;
          return BlocBuilder<QueueBloc, QueueState>(
            builder: (context, queueState) {
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
          );
        },
      ),
    );
  }
}

class AppProvider extends StatefulWidget {
  const AppProvider({
    required this.child,
    required this.localStorageRepository,
    super.key,
  });
  final LocalStorageRepository localStorageRepository;

  final Widget child;

  @override
  State<AppProvider> createState() => _AppProviderState();
}

class _AppProviderState extends State<AppProvider> {
  late DioClient _client;

  @override
  void initState() {
    _client = DioClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: _client),
          BlocProvider(create: (context) => ThemeCubit()),
          Provider<AuthRepository>(
            create: (context) => AuthRepositoryImpl(dioClient: context.read()),
          ),
          Provider(create: (context) => AppRouter()),
          Provider<LocalStorageRepository>.value(
            value: widget.localStorageRepository,
          ),
          Provider<AnimalRepository>(
            create: (context) => AnimalRepositoryDecorator(
              animalRepositoryImpl:
                  AnimalRepositoryImpl(dioClient: context.read()),
              fakeAnimalRepository: FakeAnimalRepository(),
            ),
          ),
          Provider<OrderRepository>(
            create: (context) => OrderRepositoryDecorator(
              orderRepositoryImpl:
                  OrderRepositoryImpl(dioClient: context.read()),
              fakeOrderRepository: FakeOrderRepository(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                NomenclatureCubit(authRepository: context.read()),
          ),
          BlocProvider(
            create: (context) => QueueBloc(
              orderRepository: context.read(),
              animalRepository: context.read(),
              localStorageRepository: context.read(),
            )..add(const QueueEvent.appStarted()),
          ),
        ],
        child: widget.child,
      );
}
