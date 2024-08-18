This is my first public project as an iOS developer.
I've decided to keep that project for the record.

# simplePong
Simple implementation of Pong Game written on Objective-C

There are some bugs:
1) AIPlayer act only for defense. AIPlayer's behavior should to be rewritten.
2) AIPlayer moves over the screen, when ball goes to the wall. It causes by interception algorythm, AIPlayer moves
across the trajectory of the ball.
3) Player pad doesn't react with ball sometimes (rarely, depends on movement speed). Collision condition should be rewritten.
4) Collision handling with player works only when ball goes down. New interaction case should be added.

But it works on all emulators.
