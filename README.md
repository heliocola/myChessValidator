myChessValidator
================

Introdution
===========

To start with I would like to tell you I don't know how to play Chess.
The links in a section below is all I used to learn about the rules of the game
and what are the valid moves for ecah piece.

Possible moves
==============

- King: 
    one square in each direction, and diagonally
    can't move himself to check (where he can be captured)

- Queen:
    any one straight direction
    as far as possible as long as she doesn't move through other pieces

- Rook:
    as far as it wants but only forward, backward, and to the sides

- Bishop:
    as far as it wants but only diagonally
    each bishop starts in one color and have to stay in that color
    can't go over other pieces

- Knight:
    move in L: two squares in one direction than turn 90 degrees to move one more square

- Pawn:
    can move forward 2 squares if it is the first move
    otherwise move forward 1 if empty in front of it
    can move diagonally to capture

Usefull Links
=============

http://www.meetup.com/Arlington-Ruby/events/160526502/

http://www.puzzlenode.com/puzzles/13-chess-validator

http://en.wikipedia.org/wiki/Algebraic_notation_%28chess%29

http://www.chess.com/learn-how-to-play-chess


Usefull Command line
====================

ruby validator.rb files/simple_board.txt files/simple_moves.txt

ruby validator.rb files/complex_board.txt files/complex_moves.txt  | grep "NOT FULLY IMPLEMENTED" | sort | uniq -c
