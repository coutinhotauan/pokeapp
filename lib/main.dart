import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokeapp/pages/home_page.dart';
import 'package:pokeapp/pages/pokemon_detail.dart';

void main() {
  /*
  runApp(const MaterialApp(
    title: 'Poke App',
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
   */

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
        )
      ];
}
