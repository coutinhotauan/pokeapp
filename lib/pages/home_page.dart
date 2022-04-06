import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  //instance of login with google account
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? currentUser;

  String profilePictureURL = '';

  @override
  void initState() {
    super.initState();

    //fetch for the api at the start of the page
    fetchData();

    //observe user's state (logged or not)
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        currentUser = user;
      });
    });
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

  //do user's login
  Future<User?> getUser() async{

    if(currentUser != null){
      return currentUser;
    }

    try{

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      return user;

    }catch(e){
      return null;
    }

  }

  //handles login result
  void login() async{

    //awaits for login result
    final User? user = await getUser();

    //error during login
    if(user == null){

      //snackbar to be displayed
      const snackBarError = SnackBar(
        content: Text('Error during login, try again later!'),
        backgroundColor: Colors.red,
      );

      //display snackbarError
      ScaffoldMessenger.of(context).showSnackBar(snackBarError);
    }else{
      profilePicture();
    }

  }

  //does logout
  void logout(){
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();

    //snackbar to be displayed
    const snackBarLogout = SnackBar(
      content: Text('Logout done with success!'),
      backgroundColor: Colors.cyan,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBarLogout);
  }

  //sets profile picture URL from the user who has logged
  void profilePicture(){

    String photoURL = '';
    String? user = FirebaseAuth.instance.currentUser?.photoURL;

    if(user != null){
      profilePictureURL = user;
    }else{
      profilePictureURL = photoURL;
    }

  }

  //if the user isn't logged, this drawer will be shown
  drawerNotLogged(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.cyan,
            ),
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/user-image.png')
                    )
                ),
              ),
            ),
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
            onTap: () => login() //user's login if button pressed,
          )
        ],
      ),
    );
  }

  //if the user is logged, this drawer will be shown
  drawerLogged(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.cyan,
            ),
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(profilePictureURL)
                    )
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ListTile(
                  title: Row(
                    children: const [
                      Icon(
                        Icons.favorite,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Favorites',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  onTap: () {},
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                onTap: () => logout(),
              ),
            ],
          )
        ],
      ),
    );
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
      drawer: currentUser == null ? drawerNotLogged() : drawerLogged(),
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
