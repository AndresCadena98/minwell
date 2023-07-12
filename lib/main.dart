import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/presentation/presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 1));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WallpapersBlocBloc>(
          create: (context) => WallpapersBlocBloc(),
        ),
        BlocProvider<FavoritesBloc>(
          lazy: false,
          create: (context) => FavoritesBloc()..add(GetFavorites()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Righteous',
        ),
        routes: {
          '/home': (context) => const HomePage(),
          '/image_detail': (context) =>  ImageDetail(urlData: '',),
          '/favorite': (context) => const FavoritePageView(),
        },
        title: 'Material App',
        home: FlutterSplashScreen.gif(
          gifPath: 'assets/images/splash.gif',
          gifWidth: 269,
          gifHeight: 474,
          defaultNextScreen: const HomePage(),
          duration: const Duration(milliseconds: 3515),
          onInit: () async {
            await Future.delayed(const Duration(milliseconds: 2000));
          },
          onEnd: () async {},
        ),
      ),
    );
  }
}
