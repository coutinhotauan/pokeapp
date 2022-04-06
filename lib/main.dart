import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokeapp/pages/favorites.dart';
import 'package:pokeapp/pages/home_page.dart';
import 'package:pokeapp/pages/pokemon_detail.dart';
import 'package:pokeapp/pages/search_page.dart';

void main() async{

  /* //before using Modular
  runApp(const MaterialApp(
    title: 'Poke App',
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
   */

  //firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
          child: (context, args) => PokeDetail(pokemon: args.data),
        ),
        ChildRoute(
          '/searchpage',
          child: (context, args) => SearchPage(pokehub: args.data),
        ),
        ChildRoute(
          '/favorites',
          child: (context, args) => Favorites(user: args.data),
        )
      ];
}
