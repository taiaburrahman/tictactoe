// ignore_for_file: constant_identifier_names

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String PLAYER_X = "X";
  static const String PLAYER_Y = "O";

  

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
  

    initializeGame();
    super.initState();
  }

 

  void initializeGame() {
    currentPlayer = PLAYER_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; //9 empty places
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 12, 44),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tic Tac Toe",
                  style: GoogleFonts.permanentMarker(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                
                const SizedBox(height: 5),
                _headerText(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                _gameContainer(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                _restartButton(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        Text(
          "$currentPlayer Turn",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        //on click of box
        if (gameEnd || occupied[index].isNotEmpty) {
          //Return if game already ended or box already clicked
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: occupied[index].isEmpty
                ? const Color.fromARGB(143, 40, 27, 73)
                : occupied[index] == PLAYER_X
                    ? Colors.indigo
                    : Colors.orange,
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(1),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  _restartButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text("Restart Game"));
  }

  changeTurn() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_Y;
    } else {
      currentPlayer = PLAYER_X;
    }
  }

  checkForWinner() {
    //Define winning positions
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          //all equal means player won
          showGameOverMessage("Player $playerPosition0 is Win");
          gameEnd = true;
          return;
        }
      }
    }
  }

  checkForDraw() {
    if (gameEnd) {
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        //at least one is empty not all are filled
        draw = false;
      }
    }

    if (draw) {
      showGameOverMessage("Draw");
      gameEnd = true;
    }
  }

  showGameOverMessage(String message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Game over'),
            content: Text(
              "$message",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent),
                  onPressed: () {
                    Navigator.of(context).pop();
                    
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }
}
