require './ColourMeGreen.rb'

cmg = ColourMeGreen.new

p cmg.KEY_TO_ATTRIBUTE

cmg.parse(File.read('test1.cmg'))
