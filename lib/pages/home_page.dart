import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokeapp/pokemon.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //api address to pokemon data
  Uri url = Uri.parse(
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json");

  @override
  void initState() {
    super.initState();

    //fetch for the api at the start of the page
    fetchData();
  }

  //stores pokemon data from the api
  PokeHub? pokeHub;

  //function to fetch date from the api
  fetchData() async {
    dynamic response = await http.get(url);
    dynamic decodedJson = jsonDecode(response.body);

    setState(() {
      pokeHub = PokeHub.fromJson(decodedJson); //stores data retrieved
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PokéApp"),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            onPressed: () => {
              if (pokeHub != null)
                {Modular.to.pushNamed('/searchpage', arguments: pokeHub)}
              //go to search page
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Text('Header'),
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(
                    Icons.login,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              onTap: () {},
            )
          ],
        ),
      ),
      body: pokeHub == null //conditional rendering
          ? const Center(
              child: CircularProgressIndicator(), //is loading
            )
          : GridView.count(
              //showing data from the api
              crossAxisCount: 2,
              children: pokeHub!.pokemon.map((poke) {
                return InkWell(
                  onTap: () {
                    /* FORMER IDEA (using Navigator)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PokeDetail(pokemon: poke)
                          )
                      );
                    */

                    //using Modular to navigate between pages
                    Modular.to.pushNamed('/pokedetail', arguments: poke);
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
            ),
    );
  }
}
