import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokeapp/models/pokemon.dart';

class SearchPage extends StatefulWidget {
  final List args;

  const SearchPage({Key? key, required this.args}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //pokemon data from home page
  PokeHub? pokehub;

  //pokemon data from home page
  User? user;

  @override
  void initState() {
    super.initState();

    pokehub = widget.args[0];
    user = widget.args[1];
  }

  //controller for search bar
  TextEditingController searchController = TextEditingController();

  //list of pokemons filter by search
  List<Pokemon> pokemons = [];

  //flag to show if a search was done
  bool isInitial = true;

  searchPokemons(String keyword) {
    List<Pokemon> allPokemons = [];
    List<Pokemon> result = [];

    //verify that pokemon data received exists
    if (pokehub != null && pokehub?.pokemon != null) {
      allPokemons = pokehub!.pokemon;

      //doesn't have null safety (or ... ??)
      //result = allPokemons.where((pokemon) => pokemon.name!.contains(keyword)).toList();

      //looping over pokemon's list
      for (Pokemon pokemon in allPokemons) {
        //check if property 'name' isn't null
        if (pokemon.name != null) {
          //adds if pokemon's name contains the search's keyword
          if (pokemon.name!.toLowerCase().contains(keyword)) {
            result.add(pokemon);
          }
        }
      }
    }

    //updating state
    setState(() {
      //pokemon's list is updated
      pokemons = result;

      //sets search state to false (a search was done)
      isInitial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Modular.to.pop(), //go to previous page
          ),
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear(); //clear text field
                          setState(() {
                            isInitial = true; //initiating a search
                          });
                        }),
                    hintText: 'search',
                    border: InputBorder.none),
                onSubmitted: (String keyword) {
                  searchPokemons(keyword); //searching based on keyword informed
                },
              ),
            ),
          ),
        ),
        body: isInitial == true //conditional rendering
            ? Container()
            : (pokemons.isEmpty
                ? const Center(
                    //if the search returns no results
                    child: Text(
                      'No pokemons found :/',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                : GridView.count(
                    //results of the search
                    crossAxisCount: 2,
                    children: pokemons.map((poke) {
                      return InkWell(
                        onTap: () => Modular.to.pushNamed('/pokedetail',
                            arguments: [poke, user, pokehub, false]),
                        //go to pokemon's detail page
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Hero(
                            tag: poke.id as Object,
                            child: Card(
                              elevation: 3,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(poke.img ?? ''))),
                                  ),
                                  Text(
                                    poke.name ?? '',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )));
  }
}
