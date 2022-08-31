import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../models/pokemon.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key, required this.args}) : super(key: key);

  final List args;

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  PokeHub? pokehub;
  User? user;

  @override
  void initState() {
    super.initState();

    pokehub = widget.args[0];
    user = widget.args[1];
  }

  Future<List> allFavorites() async {
    //reference to user's collection on firestore
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(user!.uid);

    var answer = await userCollection.get();

    return answer.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Modular.to.pushNamed('/', arguments: [pokehub, user]),
        ),
        title: const Text('Favorites'),
      ),
      body: FutureBuilder(
        future: allFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List favorites = snapshot.data as List;

            if (favorites.isEmpty) {
              return const Center(
                child: Text('There is no favorite Pokémons'),
              );
            }

            return GridView.count(
              crossAxisCount: 2,
              children: favorites.map((pokeId) {
                Pokemon? poke;

                for (Pokemon ePokemon in pokehub!.pokemon) {
                  if (ePokemon.id.toString() == pokeId['pokemon_id']) {
                    poke = ePokemon;
                  }
                }

                return InkWell(
                  onTap: () => Modular.to.pushNamed('/pokedetail',
                      arguments: [poke, user, pokehub, true]),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Hero(
                      tag: poke!.id as Object,
                      child: Card(
                        elevation: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(poke.img ?? ''),
                                ),
                              ),
                            ),
                            Text(
                              poke.name ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
