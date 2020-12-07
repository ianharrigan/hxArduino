package foo;

class SampleFromSite {
    public static function StaticMethod() {
      var playerA = { name: "Simon", move: Paper }
      var playerB = { name: "Nicolas", move: Rock }
          
      var result = switch [playerA.move, playerB.move] {
        case [Rock, Scissors] | 
             [Paper, Rock] |
             [Scissors, Paper]: Winner(playerA);
              
        case [Rock, Paper] |
             [Paper, Scissors] |
             [Scissors, Rock]: Winner(playerB);
              
        case _: Draw;
      }
      trace('result: $result');
    }
  }
              
  typedef Player = { name: String, move: Move }
  
  enum Move { Rock; Paper; Scissors; }
  
  enum Result { 
    Winner(player:Player); 
    Draw; 
}