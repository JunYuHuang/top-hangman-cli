require_relative 'classes/Game'
require_relative 'classes/WordsList'
require_relative 'classes/GameSave'

game = Game.new(WordsList)
game.use_game_save(GameSave.new("saves"))
game.play
