require_relative 'spec_helper'
require_relative '../classes/GameSave'
require_relative '../classes/Game'
require_relative '../classes/WordsList'

def delete_saves_folder(folder_path)
  saves = Dir.glob("#{folder_path}/*")
  saves.each { |f| File.delete(f) } if saves.size > 0
  Dir.rmdir(folder_path) if Dir.exist?(folder_path)
end

def create_test_saves(folder_path, saves_count)
  Dir.mkdir(folder_path) unless Dir.exist?(folder_path)
  saves_count.times do |i|
    save = File.new("#{folder_path}/test_save_#{i}.yaml", "w+")
    save.puts("# test save file #{i}")
    save.close
  end
end

RSpec.describe "GameSave Class" do
  describe "initialize" do
    it "works" do
      game_save = GameSave.new("../test_saves")
      expect(game_save.saves_path).to eq("../test_saves")
    end
  end

  describe "does_save_exist?" do
    it "returns false if called and the `saves` folder is not present" do
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)
      expect(game_save.does_save_exist?('test_save_0')).to eq(false)
    end

    it "returns false if called and the `saves` folder is present and empty" do
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)
      Dir.mkdir(folder)
      expect(game_save.does_save_exist?('test_save_0')).to eq(false)
    end

    it "returns true if called with 'test_save_0' and the file '../saves/test_save_0.yaml' exists" do
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)
      create_test_saves(folder, 1)
      expect(game_save.does_save_exist?('test_save_0')).to eq(true)
    end
  end

  describe "count_saves" do
    it "returns 3 if called and the `saves` folder has 3 saves files" do
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)
      create_test_saves(folder, 3)
      expect(game_save.count_saves("test_save_")).to eq(3)
    end
  end

  describe "get_unique_id" do
    it "returns 3 if called and the `saves` folder has 3 saves files" do
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)
      create_test_saves(folder, 3)
      expect(game_save.get_unique_id("test_save_")).to eq(3)
    end
  end

  describe "create_save" do
    it "returns the correct hash if called with a new Game object" do
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)
      create_test_saves(folder, 2)

      game = Game.new(WordsList)
      res_name = game_save.create_save(game, "test_save_")
      expect(res_name).to eq("test_save_2")
    end
  end

  describe "open_save" do
    it "returns the correct hash if called with a new Game object" do
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)
      create_test_saves(folder, 1)

      game = Game.new(WordsList)
      save_name = game_save.create_save(game, "test_save_")
      res = game_save.open_save(save_name)
      expect(res.class).to eq(Hash)
      expect(res[:word]).to eq("")
    end
  end

  # TODO
  describe "load_save" do
    it "updates the game state if called with (game, 'save_0') and 'save_0' is a valid game save file" do
      # delete old test save files as needed
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)

      # emulate a game, save it, and reset the game
      game = Game.new(WordsList)
      game.use_game_save(game_save)
      # game.is_playing = true
      game.word = "example"
      game.correct_char_guesses.merge(['a', 'e'])
      save_name = game.game_saves.create_save(game)
      game.word = ""
      game.correct_char_guesses = Set.new

      # load the game and check if the game's state was updated correctly
      game.game_saves.load_save(game, save_name)
      expect(game.word).to eq("example")
      expect(game.correct_char_guesses.size).to eq(2)
      expect(game.correct_char_guesses.include?('a')).to eq(true)
      expect(game.correct_char_guesses.include?('e')).to eq(true)
    end
  end

  describe "get_save_names_list" do
    it "returns the correct array if called and the `saves` folder has 3 saves files" do
      game_save = GameSave.new("../test_saves")
      folder = game_save.saves_path
      delete_saves_folder(folder)
      create_test_saves(folder, 3)
      expected = [
        "test_save_0",
        "test_save_1",
        "test_save_2"
      ]
      expect(game_save.get_save_names_list("test_save_")).to eq(expected)
    end
  end
end
