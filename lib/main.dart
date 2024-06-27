import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding/core/utils/app_router.dart';
import 'package:wedding/core/utils/assets.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:wedding/features/home/manager/DataFetchCubit.dart';
import 'package:wedding/features/home/manager/PhotographersFetchCubit.dart';
import 'package:wedding/features/home/manager/image_fetch_cubit.dart';

import 'bloc_observer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  await FirebaseAppCheck.instance.activate();
  FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity);
  runApp(const WeddingApp());
}

class WeddingApp extends StatelessWidget {
  const WeddingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (context) => ImageVideoCubit(),
        ),
        BlocProvider(
          create: (context) => DataFetchingCubit(),
        ),
        BlocProvider(
          create: (context) => DataFetchingPhotographersCubit(),
        )
      ],
      child: DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(AssetsData.backgroundImage),
          fit: BoxFit.cover,
        )),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: ThemeData(scaffoldBackgroundColor: Colors.transparent),
        ),
      ),
    );
  }
}
