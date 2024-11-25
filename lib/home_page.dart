import 'package:flutter/material.dart';
import 'package:snake_game/game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/snake_game.jpg'),
          const SizedBox(height: 50.0),
          const Text('Welcome to Snake Game',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 50.0),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const GamePage()));
              },
              icon: const Icon(Icons.play_circle_filled,
                  color: Colors.black, size: 30.0),
              label: const Text("Start the Game",
                  style: TextStyle(color: Colors.black, fontSize: 20.0))),
        ],
      ),
    ));
  }
}
