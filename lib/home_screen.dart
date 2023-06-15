import 'package:flutter/material.dart';
import 'game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X', result = '';
  bool gameOver = false, isSwitched = false;
  int turn = 0;
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  ...startBlock(),
                  centerBlock(),
                  ...lastBlock(),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...startBlock(),
                        ...lastBlock(),
                      ],
                    ),
                  ),
                  centerBlock(),
                ],
              ),
      ),
    );
  }

  List<Widget> startBlock() {
    return [
      SizedBox(height: 17.0),
      SwitchListTile.adaptive(
        title: const Text(
          'Turn on/off two player',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
        },
      ),
      SizedBox(height: 17.0),
      Text(
        'it\'s $activePlayer turn'.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 50.0,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 17.0),
    ];
  }

  Widget centerBlock() {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(15.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
        crossAxisCount: 3,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: gameOver
                ? null
                : () {
                    if (!gameOver) {
                      if (!Player.playerX.contains(index) &&
                          !Player.playerO.contains(index)) {
                        game.playGame(index, activePlayer);
                        updateState();
                        if (!isSwitched && !gameOver && turn < 9) {
                          game.autoPlay(activePlayer);
                          updateState();
                        }
                      }
                    }
                  },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Theme.of(context).shadowColor,
              ),
              child: Center(
                child: Text(
                  Player.playerX.contains(index)
                      ? 'X'
                      : Player.playerO.contains(index)
                          ? 'O'
                          : '',
                  style: TextStyle(
                    color: Player.playerX.contains(index)
                        ? Colors.blue
                        : Colors.pink,
                    fontSize: 40.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> lastBlock() {
    return [
      MediaQuery.of(context).orientation == Orientation.portrait
          ? SizedBox(height: 17.0)
          : SizedBox(height: 0.0),
      Text(
        result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 17.0),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            result = '';
            isSwitched = false;
            gameOver = false;
            turn = 0;
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text('Repeat the game'),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      ),
      SizedBox(height: 17.0),
    ];
  }

  void updateState() {
    setState(() {
      turn++;
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = 'Player $winnerPlayer is the Winner';
      } else if (!gameOver && turn == 9) {
        gameOver = true;
        result = 'it\'s Draw!';
      }
    });
  }
}
