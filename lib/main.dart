import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokeapp/pages/favorites.dart';
import 'package:pokeapp/pages/home_page.dart';
import 'package:pokeapp/pages/pokemon_detail.dart';
import 'package:pokeapp/pages/search_page.dart';
import 'package:pokeapp/services/firebase_messaging_service.dart';

FirebaseMessagingService pushNotification = FirebaseMessagingService();

void main() async {
  //firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //push notification
  WidgetsFlutterBinding.ensureInitialized();
  pushNotification.setFirebaseForegroundNotifications();
  pushNotification.getToken();
  pushNotification.onMessage();
  pushNotification.onMessageOpenedApp();
  onBackgroundMessage();

  return runApp(
    ModularApp(
      module: AppModule(),
      child: MaterialApp.router(
        title: 'PokeApp',
        debugShowCheckedModeBanner: false,
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
      ),
    ),
  );
}

//Modular setup
class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const HomePage(),
        ),
        ChildRoute(
          '/pokedetail',
          child: (context, args) => PokeDetail(args: args.data),
        ),
        ChildRoute(
          '/searchpage',
          child: (context, args) => SearchPage(args: args.data),
        ),
        ChildRoute(
          '/favorites',
          child: (context, args) => Favorites(args: args.data),
        )
      ];
}
