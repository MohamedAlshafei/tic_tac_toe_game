
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tic_tac_toe/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String activePlayer='X';
  bool gameOver=false;
  int turn=0;
  String result='';
  bool isSwitched=false;
  Game game=Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:SafeArea(
        
        child:MediaQuery.of(context).orientation==Orientation.portrait? Column(
          children: [
              ...firstBlock(),
              const SizedBox(height: 20,),
              expanded(context),
              ...lastBlock()
            
          ],
        ): Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...firstBlock(),
                  ...lastBlock()
                ],
              ),
            ),
            expanded(context),
          ],
        ),
      ),
    );
  }

  Expanded expanded(BuildContext context) {
    return Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(15.0),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
                crossAxisCount: 3,
                children: List.generate(9, (index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: gameOver?null:()=>_onTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:  Center(
                        child: Text(
                          Player.playerX.contains(index)?
                          'X':
                          Player.playerO.contains(index)?
                          'O':'',
                          style: TextStyle(
                            color: Player.playerX.contains(index)?Colors.blue:Colors.pink,
                            fontSize: 30.0
                            ),

                          ),
                          ),
                    ),
                  );
                }),
                ),
            );
  }

  List<Widget> lastBlock(){
    return [
      Text(
                result,
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  
                ),
                textAlign: TextAlign.center,
              ),
            ElevatedButton.icon(
                onPressed: (){
                  setState(() {
                    Player.playerX=[];
                    Player.playerO=[];
                    activePlayer='X';
                    gameOver=false;
                    turn=0;
                    result='';
                  });
                }, 
                icon: const Icon(Icons.replay), 
                label: const Text('Repeat the game'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).splashColor),
                ),
                ),
    ];
  }

  List<Widget> firstBlock(){
    return [
      const SizedBox(height: 20,),
      SwitchListTile.adaptive(
              title: const Text(
                'Turn on/off two player',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  
                ),
                textAlign: TextAlign.center,
              ),
              value: isSwitched, 
              onChanged: (bool newValue){
                setState(() {
                  isSwitched=newValue;
                });
              }
              ),
            const SizedBox(height: 15.0,),
            Text(
                "It's $activePlayer turn".toUpperCase(),
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  
                ),
                textAlign: TextAlign.center,
              ),
    ];
  }

  _onTap(int index)async{
    

    if((Player.playerX.isEmpty || !Player.playerX.contains(index)) && 
    (Player.playerO.isEmpty || !Player.playerO.contains(index))){
      game.playGame(index, activePlayer);
      updateState();

      if(!isSwitched && !gameOver && turn != 9){
      await game.autoPlay(activePlayer);
      updateState();
    }
    }

  }

  void updateState(){
    setState(() {
      activePlayer=activePlayer=='X'?'O':'X';
      turn++;
      String winnerPlayer= game.checkWinner();
      if(winnerPlayer != ''){
        gameOver=true;
        result = '$winnerPlayer is the winner';
      }
      else if(!gameOver && turn==9){
        result='It\'s Drow';
      }
    });
  }
}