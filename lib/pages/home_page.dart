import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokeapp/pages/pokemon_detail.dart';
import 'dart:convert';
import 'package:pokeapp/pokemon.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uri url = Uri.parse(
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json");

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  PokeHub? pokeHub;

  fetchData() async {
    dynamic response = await http.get(url);
    dynamic decodedJson = jsonDecode(response.body);

    setState(() {
      pokeHub = PokeHub.fromJson(decodedJson);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PokéApp"),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
        ],
      ),
      drawer: const Drawer(),
      body: pokeHub == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : GridView.count(
        crossAxisCount: 2,
        children: pokeHub!.pokemon.map((poke) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PokeDetail(pokemon: poke)
                  )
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Hero(
                tag: poke.id as Object,
                child: Card(
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(poke.img ?? '')),
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
      ),
    );
  }
}
