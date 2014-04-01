This little game is a combination of Soduku and Minesweeper. You play it by
left-clicking on a blank cell. If there is only one possible number that can be
in that cell (as determined by the constraints imposed by the other numbers
shown), then it is filled in, and your score is increased. If there are several
possible values for the cell, a bomb is displayed instead.

The score you get for exposing a number is determined by the number of bombs
that you exposed first, as follows:

    - No bombs: 8 points
    - 1 bomb: 4 points
    - 2 bombs: 2 points
    - 3 bombs: 1 point
    - 4 or more bombs: 0 points

You can view the constraints imposed by the exposed numbers by either clicking
on an exposed cell, or by clicking on one of the numbers in the count grid.
Doing this will display a flag in all the positions that cannot possibly be the
number that you clicked.

This is a pre-alpha release. The final game will support:

    * Professional graphics.
    * High-score table (sorted by difficulty / score / time taken).
    * Automatic classification of puzzles as easy / medium / hard.
    
Written by JasonHutchens@gmail.com.

The game requires FXRuby 1.4.

051121
    * Displays score and elapsed time.
    * Displays count of exposed numbers.
    * Click on a number to flag the empty cells that are constrained by it.
    * Click on a flag to hide all flags.
    * Click on the exposed count to flag all matching cells.

051120
    * Now loads puzzles from a file (as plain text). You can add your own!
    * GUI support for selecting the level (i.e. the file) and the game to play.
