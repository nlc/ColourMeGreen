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
  * `{+COLORNAME}` adds a color to the stack; `{+ATTRIBUTENAME}` pushes an attribute to the stack
  * `{-}` pops a color/attribute from the stack; `{- 3}` pops 3; `{- %}` pops all
* *Maybe* the ability to define macros

{+MAGENTA|+BRIGHT}Vi4^o^let{- 2} _ flows _ from the wound2 in your2 \_2 chest2 $12

Your heart4 of2 _ {+YELLOW|+FAINT|+REVERSE}gold2{- %} _ was ripped _ in2 \_3 two2 $12
