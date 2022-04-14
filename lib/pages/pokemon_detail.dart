import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokeapp/pokemon.dart';

class PokeDetail extends StatefulWidget {
  final List? args;

  const PokeDetail({Key? key, required this.args}) : super(key: key);

  @override
  State<PokeDetail> createState() => _PokeDetailState();
}

class _PokeDetailState extends State<PokeDetail> {
  Pokemon? pokemon;
  User? user;
  bool fromFavorites = false;
  PokeHub? pokehub;

  //flag to inform if this pokemon is in user favorite's list
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    //set attributes on initialization
    pokemon = widget.args![0];
    user = widget.args![1];
    pokehub = widget.args![2];
    fromFavorites = widget.args![3];
  }

  //select color according to pokemon's attribute
  selectColor(String type) {
    switch (type) {
      case 'Grass':
        return Colors.green;
      case 'Poison':
        return Colors.purple;
      case 'Fire':
        return Colors.red;
      case 'Flying':
        return Colors.teal.shade50;
      case 'Water':
        return Colors.blue;
      case 'Bug':
        return Colors.grey;
      case 'Normal':
        return Colors.white;
      case 'Electric':
        return Colors.yellow;
      case 'Ground':
        return Colors.brown;
      case 'Fighting':
        return Colors.deepPurpleAccent;
      case 'Psychic':
        return Colors.lightGreenAccent;
      case 'Rock':
        return Colors.black12;
      case 'Ice':
        return Colors.lightBlueAccent;
      case 'Ghost':
        return Colors.white70;
      case 'Dragon':
        return Colors.amber;
    }

    return Colors.transparent;
  }

  //finds the pokemon's evolution according to "num" attribute
  Pokemon? setNextEvolution(PokeHub? pokehub, String? numPoke){

    Pokemon? pokeEvolution;

    if(pokehub != null && numPoke != null) {

      //looping over the list of pokemons
      for (var element in pokehub.pokemon) {
        if (element.num == numPoke) {
          pokeEvolution = element;
        }
      }

    }

    return pokeEvolution;
  }

  //build body widget
  bodyWidget(context) {
    return Stack(
      children: [
        Positioned(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width - 20,
          left: 10,
          top: MediaQuery.of(context).size.height * 0.1,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Text(
                  pokemon!.name ?? '',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Height: ${pokemon!.height}'),
                Text('Weight: ${pokemon!.weight}'),
                const Text(
                  'Types',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pokemon!.type!
                      .map((t) => FilterChip(
                          backgroundColor: selectColor(t),
                          label: Text(t),
                          onSelected: (b) {}))
                      .toList(),
                ),
                const Text(
                  'Weaknesses',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pokemon!.weaknesses!
                      .map((t) => FilterChip(
                          backgroundColor: selectColor(t),
                          label: Text(t),
                          onSelected: (b) {}))
                      .toList(),
                ),
                pokemon!.nextEvolution != null
                    ? const Text(
                        'Next Evolution',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : const Text(''),
                pokemon!.nextEvolution != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: pokemon!.nextEvolution!
                            .map((t) => FilterChip(
                                backgroundColor: selectColor(pokemon!.type![0]),
                                label: Text(t.name ?? ''),
                                onSelected: (b) {
                                  //search for pokémon's evolution
                                  Pokemon? pokeEvolution = setNextEvolution(pokehub, t.num);

                                  //if finds it, go to pokemon's evolution page
                                  if(pokeEvolution != null){
                                    Modular.to.pushNamed('/pokedetail', arguments: [pokeEvolution, user, pokehub, false]);
                                  }
                                }))
                            .toList(),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Hero(
            tag: pokemon!.id as Object,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(pokemon!.img ?? ''),
              )),
            ),
          ),
        )
      ],
    );
  }

  //check if this pokemon is on user favorite's list
  Future<int> checkFavorite() async {
    //pokemon data to check in the firestore
    String pokemonData = pokemon!.id.toString();

    //reference to user's collection on firestore
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(user!.uid);

    //makes a query to the firestore
    var answer =
        await userCollection.where('pokemon_id', isEqualTo: pokemonData).get();

    //if this pokemon is on list, answer.size will be 1, otherwise, 0
    return answer.size;
  }

  //add pokemon in user favorite's list
  Future<void> setFavorite() async {
    //reference to user's collection on firestore
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(user!.uid);

    String pokemonData = pokemon!.id.toString();

    userCollection.add({'pokemon_id': pokemonData}).then((value) {
      setState(() {
        isFavorite = true; //favorite button will display true
      });
    }).catchError((e) {
      //snackbar to be displayed
      const snackBarError = SnackBar(
        content: Text('Error setting favorite, try again later!'),
        backgroundColor: Colors.cyan,
      );

      //display message
      ScaffoldMessenger.of(context).showSnackBar(snackBarError);
    });
  }

  //delete from pokemon from user favorite's list
  Future<void> deleteFavorite() async {
    //pokemon data to check in the firestore
    String pokemonData = pokemon!.id.toString();

    //reference to user's collection on firestore
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(user!.uid);

    //makes a query to the firestore
    var answer =
        await userCollection.where('pokemon_id', isEqualTo: pokemonData).get();

    //id of pokemon's doc
    String docId = answer.docs[0].id;

    //delete pokemon from favorite's list
    await userCollection.doc(docId).delete().then((value) {
      setState(() {
        isFavorite = false; //favorite button will display false
      });
    }).catchError((e) {
      //snackbar to be displayed
      const snackBarError = SnackBar(
        content: Text('Error deleting favorite, try again later!'),
        backgroundColor: Colors.cyan,
      );

      //display message
      ScaffoldMessenger.of(context).showSnackBar(snackBarError);
    });
  }

  //handles favorite's button action
  Future<void> handleFavorite() async {
    //if false, sets as favorite, otherwise, delete from favorite's list
    if (isFavorite == false) {
      setFavorite();
    } else {
      deleteFavorite();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.cyan,
        title: Text(pokemon!.name ?? ''),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: fromFavorites
              ? () =>
                  Modular.to.pushNamed('/favorites', arguments: [pokehub, user])
              : () => Modular.to.pop(),
        ),
        actions: [
          user != null
              ? FutureBuilder(
                  //build the favorite's button according to checkFavorite's function
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      //checks if the pokemon is on list
                      if (snapshot.data != null && snapshot.data! as int > 0) {
                        isFavorite = true;
                      }

                      return Container(
                          //final widget of favorite's button
                          margin: const EdgeInsets.only(right: 15),
                          child: FavoriteButton(
                            iconSize: 45,
                            isFavorite: isFavorite,
                            valueChanged: (_) async {
                              handleFavorite();
                            },
                          ));
                    }

                    return const Center(
                      //waiting state
                      child: CircularProgressIndicator(),
                    );
                  },
                  future:
                      checkFavorite(), //checks if pokemon is in the favorite's list
                )
              : Container() //user is not logged
        ],
      ),
      body: bodyWidget(context),
    );
  }
}
