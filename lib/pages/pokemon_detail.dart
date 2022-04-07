import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


  @override
  void initState() {
    super.initState();

    pokemon = widget.args![0];
    user = widget.args![1];
  }

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
                                onSelected: (b) {}))
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
          onPressed: () => Modular.to.pop(),
        ),
        actions: [
          user != null ? Container(
            margin: const EdgeInsets.only(right: 15),
            child: FavoriteButton(
              iconSize: 45,
              isFavorite: false,
              valueChanged: () {},
            ),
          ) : Container()
        ],
      ),
      body: bodyWidget(context),
    );
  }
}
