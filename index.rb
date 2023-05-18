require_relative 'classes/Game'
require_relative 'classes/WordsList'

game = Game.new(WordsList)
game.play
