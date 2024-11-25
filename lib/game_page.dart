import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/game_over.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> with TickerProviderStateMixin {
  int _playerScore = 0;
  bool _hasStarted = false;
  Animation<double>? _snakeAnimation;
  AnimationController? _snakeController;
  final List _snake = [404, 405, 406, 407];
  final int _noOfSquares = 500;
  final Duration _duration = const Duration(milliseconds: 250);
  final int _squareSize = 20;
  String? _currentSnakeDirection;
  int? _snakeFoodPosition;
  final Random _random = Random();
  final Random _foodRandom = Random();
  int? _foodRandomIndex;
  final List<String> _foodImages = [
    'assets/apple.jpg',
    'assets/banana.jpg',
    'assets/orange.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _setUpGame();
  }

  void _setUpGame() {
    _playerScore = 0;
    _currentSnakeDirection = 'RIGHT';
    _hasStarted = true;
    do {
      _foodRandomIndex = _foodRandom.nextInt(_foodImages.length);
      _snakeFoodPosition = _random.nextInt(_noOfSquares);
    } while (_snake.contains(_snakeFoodPosition));
    _snakeController = AnimationController(vsync: this, duration: _duration);
    _snakeAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _snakeController!);
  }

  void _gameStart() {
    Timer.periodic(const Duration(milliseconds: 250), (Timer timer) {
      _updateSnake();
      if (_hasStarted) timer.cancel();
    });
  }

  bool _gameOver() {
    for (int i = 0; i < _snake.length - 1; i++)
      if (_snake.last == _snake[i]) return true;
    return false;
  }

  void _updateSnake() {
    if (!_hasStarted) {
      setState(() {
        _playerScore = (_snake.length - 4) * 100;
        switch (_currentSnakeDirection) {
          case 'DOWN':
            if (_snake.last > _noOfSquares)
              _snake.add(
                  _snake.last + _squareSize - (_noOfSquares + _squareSize));
            else
              _snake.add(_snake.last + _squareSize);
            break;
          case 'UP':
            if (_snake.last < _squareSize)
              _snake.add(
                  _snake.last - _squareSize + (_noOfSquares + _squareSize));
            else
              _snake.add(_snake.last - _squareSize);
            break;
          case 'RIGHT':
            if ((_snake.last + 1) % _squareSize == 0)
              _snake.add(_snake.last + 1 - _squareSize);
            else
              _snake.add(_snake.last + 1);
            break;
          case 'LEFT':
            if ((_snake.last) % _squareSize == 0)
              _snake.add(_snake.last - 1 + _squareSize);
            else
              _snake.add(_snake.last - 1);
        }

        if (_snake.last != _snakeFoodPosition)
          _snake.removeAt(0);
        else {
          do {
            _snakeFoodPosition = _random.nextInt(_noOfSquares);
          } while (_snake.contains(_snakeFoodPosition));
        }

        if (_gameOver()) {
          setState(() {
            _hasStarted = !_hasStarted;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => GameOver(score: _playerScore)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game',
            style: TextStyle(color: Colors.black, fontSize: 20.0)),
        centerTitle: false,
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Score: $_playerScore',
                style: const TextStyle(fontSize: 16.0, color: Colors.black)),
          ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.greenAccent,
          elevation: 20,
          label: Text(
            _hasStarted ? 'Start' : 'Pause',
            style: const TextStyle(color: Colors.black),
          ),
          onPressed: () {
            setState(() {
              if (_hasStarted)
                _snakeController?.forward();
              else
                _snakeController?.reverse();
              _hasStarted = !_hasStarted;
              _gameStart();
            });
          },
          icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause, progress: _snakeAnimation!)),
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (drag) {
            if (drag.delta.dy > 0 && _currentSnakeDirection != 'UP')
              _currentSnakeDirection = 'DOWN';
            else if (drag.delta.dy < 0 && _currentSnakeDirection != 'DOWN')
              _currentSnakeDirection = 'UP';
          },
          onHorizontalDragUpdate: (drag) {
            if (drag.delta.dx > 0 && _currentSnakeDirection != 'LEFT')
              _currentSnakeDirection = 'RIGHT';
            else if (drag.delta.dx < 0 && _currentSnakeDirection != 'RIGHT')
              _currentSnakeDirection = 'LEFT';
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              itemCount: _squareSize + _noOfSquares,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _squareSize),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Container(
                    color: Colors.white,
                    padding: _snake.contains(index)
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius:
                          index == _snakeFoodPosition || index == _snake.last
                              ? BorderRadius.circular(5)
                              : _snake.contains(index)
                                  ? BorderRadius.circular(2)
                                  : BorderRadius.circular(2),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _snake.contains(index)
                                ? Colors.white
                                : index == _snakeFoodPosition
                                    ? Colors.green
                                    : Colors.blue,
                          ),
                          color: _snake.contains(index)
                              ? Colors.black
                              : index == _snakeFoodPosition
                                  ? Colors.green
                                  : Colors.blue,
                          image: _snake.contains(index)
                              ? null
                              : index == _snakeFoodPosition
                                  ? DecorationImage(
                                      image: AssetImage(
                                          _foodImages[_foodRandomIndex!]),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
