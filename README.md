# ColourMeGreen
An experiment in creating a simple notation for making terminal animations.

Named after the early [banger](https://www.youtube.com/watch?v=lJne0uWgaK8) by a favorite band.

Still a WIP.

Some desired functionalities:
* Movement functions, inc.:
  * jumping back to beginning of the last word
  * the ability to chain movement instructions
  * absolute and relative location
* Full ANSI terminal color support
  * A stack of colors that can be pushed and popped
* The ability to sleep for periods of time
  * Maybe to set a BPM and sleep in terms of a number of beats
  * The ability to sleep for random periods of time
* A relatively simple notation (subject to change):
  * `plain words` are printed as-is
  * `{terms in braces are commands}`
  * `{in | braces and | between | delimiters`} are multiple commands
  * `{+COLORNAME}` adds a foreground color to the stack
  * `{+colorname}` adds a background color to the stack
  * `{+Attributename}` pushes an attribute to the stack
  * `{-}` pops a color/attribute from the stack; `{- 3}` pops 3; `{- %}` pops all
  * `{:R}` moves the cursor 1 space to the right; `U`, `D` and `L` behave as might be expected
  * `{:3R}` moves the cursor 3 spaces to the right, etc.
  * `{:3R6U}` moves the cursor 3 spaces to the right, then 6 up
  * `{:b9D}` moves the cursor to the beginning of the previous word, then 9 spaces down
  * `{@12,7}` moves the cursor to the point <12,7>.
  * A literal number appended to the end of a word means a pause of that many beats for the word
  * An empty space between words prints a literal space with no pause
  * An underscore `_` between words prints a literal space with a pause of one beat
  * A starting caret `^` is an anchor for pausing at the beginning of a line
  * A dollar sign `$` is an anchor for pausing at the end of a line
  * To pause printing without writing a space, use a caret `^` instead of a space
* *Maybe* the ability to define macros

A tentative example, using the lyrics from the aforementioned song:

    {+MAGENTA|+Bold}Vi4^o^let{- 2} _ flows _ from the wound2 in your2 _2 chest2 $12
    {+BLACK|+Reverse}Black4{- 2} is2 the hole3 in which _ you2 _3 rest2 $11
    Your heart4 of2 _ {+YELLOW|+Faint|+Reverse}gold2{- %} _ was ripped _ in2 _3 two2 $12
