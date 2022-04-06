import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Modular.to.pushNamed('/'),
        ),
        title: const Text('Favorite page'),
      ),
    );
  }
}
