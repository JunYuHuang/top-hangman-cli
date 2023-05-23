require_relative 'spec_helper'
require_relative '../classes/Game'
require_relative '../classes/WordsList'
require_relative '../classes/GameSave'

# helper functions for tests

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

RSpec.describe "Game" do
  describe "initialize" do
    it "works" do
      game = Game.new(WordsList)
      expect(game.word.class).to eq(String)
      expect(game.word.size).to eq(0)
    end
  end

  describe "is_word_set?" do
    it "returns false if called and there is no word selected" do
      game = Game.new(WordsList)
      expect(game.is_word_set?).to eq(false)
    end

    it "returns false if called and the word set does not meet the valid range size" do
      game = Game.new(WordsList)
      game.word = "abc"
      expect(game.is_word_set?).to eq(false)
    end

    it "returns true if called and the word set meets the valid range size" do
      game = Game.new(WordsList)
      game.word = "words"
      expect(game.is_word_set?).to eq(true)
    end
  end

  describe "get_masked_word" do
    it "returns an array whose size equals the size of the selected word" do
      game = Game.new(WordsList)
      game.word = "words"
      expect(game.get_masked_word.size).to eq(game.word.size)
    end

    it "returns an array of underscores if the guesser has not guessed any valid single chars yet" do
      game = Game.new(WordsList)
      game.word = "words"
      expected = ['_', '_', '_', '_', '_']
      expect(game.get_masked_word).to eq(expected)
    end

    it "returns an array with uppercase alphabet chars for revealed chars that a guesser has guessed correctly for" do
      game = Game.new(WordsList)
      game.word = "banana"
      game.correct_char_guesses = Set.new(['a'])
      expected = ['_', 'A', '_', 'A', '_', 'A']
      expect(game.get_masked_word).to eq(expected)
    end

    it "returns an array with only uppercase alphabet chars if the guesser has guessed correctly all of the word's chars" do
      game = Game.new(WordsList)
      game.word = "banana"
      game.correct_char_guesses = Set.new(['a', 'b', 'n'])
      expected = ['B', 'A', 'N', 'A', 'N', 'A']
      expect(game.get_masked_word).to eq(expected)
    end
  end

  describe "is_alpha_char?" do
    it "returns false if called with ''" do
      game = Game.new(WordsList)
      expect(game.is_alpha_char?('')).to eq(false)
    end

    it "returns false if called with '2'" do
      game = Game.new(WordsList)
      expect(game.is_alpha_char?('2')).to eq(false)
    end

    it "returns true if called with 'a'" do
      game = Game.new(WordsList)
      expect(game.is_alpha_char?('a')).to eq(true)
    end

    it "returns true if called with 'Z'" do
      game = Game.new(WordsList)
      expect(game.is_alpha_char?('Z')).to eq(true)
    end

    it "returns true if called with 'G'" do
      game = Game.new(WordsList)
      expect(game.is_alpha_char?('G')).to eq(true)
    end
  end

  describe "is_valid_char_guess?" do
    it "returns false if called with 'ads'" do
      game = Game.new(WordsList)
      expect(game.is_valid_char_guess?('ads')).to eq(false)
    end

    it "returns false if called with ''" do
      game = Game.new(WordsList)
      expect(game.is_valid_char_guess?('')).to eq(false)
    end

    it "returns true if called with 'H'" do
      game = Game.new(WordsList)
      expect(game.is_valid_char_guess?('H')).to eq(true)
    end
  end

  describe "is_valid_word_guess?" do
    it "returns false if called with a guess whose size is less than the word's size" do
      game = Game.new(WordsList)
      game.word = 'apple'
      expect(game.is_valid_word_guess?('was')).to eq(false)
    end

    it "returns false if called with a guess whose size is greater than the word's size" do
      game = Game.new(WordsList)
      game.word = 'apple'
      expect(game.is_valid_word_guess?('supermegalongword')).to eq(false)
    end

    it "returns false if called with a guess that contains non-alphabet chars but is the same length as the word" do
      game = Game.new(WordsList)
      game.word = 'buzzkill'
      expect(game.is_valid_word_guess?('badword!')).to eq(false)
    end

    it "returns true if called with a guess that contains only alphabet chars and is the same length as the word" do
      game = Game.new(WordsList)
      game.word = 'blackjack'
      expect(game.is_valid_word_guess?('excellent')).to eq(true)
    end
  end

  describe "count_wrong_guesses" do
    it "returns 3 if called and guesser made 3 wrong char guesses" do
      game = Game.new(WordsList)
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      expect(game.count_wrong_guesses).to eq(3)
    end

    it "returns 5 if called and guesser made 3 wrong char guesses and 2 wrong word guesses" do
      game = Game.new(WordsList)
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle']
      expect(game.count_wrong_guesses).to eq(5)
    end

    it "returns 5 if called and guesser made 3 wrong char guesses, 2 wrong word guesses, and 1 correct word guess" do
      game = Game.new(WordsList)
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle', 'apple']
      expect(game.count_wrong_guesses).to eq(5)
    end
  end

  describe "did_guesser_lose?" do
    it "returns false if called and guesser has made less than the max count of wrong guesses" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle']
      expect(game.did_guesser_lose?).to eq(false)
    end

    it "returns false if called and guesser has made 1 less than the max count of wrong guesses and made the correct word guess" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle', 'apple']
      expect(game.did_guesser_lose?).to eq(false)
    end

    it "returns true if called and guesser has made exactly the max count of wrong guesses" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle', 'cabin']
      expect(game.did_guesser_lose?).to eq(true)
    end

    it "returns true if called and guesser has exceeded the max count of wrong guesses" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z', 'b'])
      game.word_guesses = ['daddy', 'eagle', 'cabin']
      expect(game.did_guesser_lose?).to eq(true)
    end
  end

  describe "did_guesser_win?" do
    it "returns false if called and guesser has made less than the max count of wrong guesses" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle']
      expect(game.did_guesser_win?).to eq(false)
    end

    it "returns false if called and guesser has made exactly the max count of wrong guesses" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle', 'cabin']
      expect(game.did_guesser_win?).to eq(false)
    end

    it "returns false if called and guesser has made exactly the max count of wrong guesses but made the correct word guess" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle', 'early', 'apple']
      expect(game.did_guesser_win?).to eq(false)
    end

    it "returns true if called and guesser has made 1 less than the max count of wrong guesses and made the correct word guess" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['i', 'o', 'z'])
      game.word_guesses = ['daddy', 'eagle', 'apple']
      expect(game.did_guesser_win?).to eq(true)
    end

    it "returns true if called and guesser has guessed the correct word on the first try" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.word_guesses = ['apple']
      expect(game.did_guesser_win?).to eq(true)
    end

    it "returns true if called and guesser has guessed all the letters of the correct word" do
      game = Game.new(WordsList)
      game.max_wrong_guesses = 6
      game.word = 'apple'
      game.correct_char_guesses = Set.new(['a', 'p', 'l', 'e'])
      expect(game.did_guesser_win?).to eq(true)
    end
  end

  describe "process_input" do
    it "adds a correct letter if called with a hash containing a letter that is in the word" do
      game = Game.new(WordsList)
      game.word = 'apple'
      expect(game.correct_char_guesses.size).to eq(0)

      game.process_input({ data: 'p', type: :char_guess })
      has_char = game.correct_char_guesses.include?('p')
      expect(has_char).to eq(true)
      expect(game.correct_char_guesses.size).to eq(1)
    end

    it "adds a wrong letter if called with a hash containing a letter that is not in the word" do
      game = Game.new(WordsList)
      game.word = 'apple'
      expect(game.wrong_char_guesses.size).to eq(0)

      game.process_input({ data: 'z', type: :char_guess })
      has_char = game.wrong_char_guesses.include?('z')
      expect(has_char).to eq(true)
      expect(game.wrong_char_guesses.size).to eq(1)
    end

    it "does nothing if called with a hash containing a letter that has been correctly guessed already" do
      game = Game.new(WordsList)
      game.word = 'apple'
      game.correct_char_guesses = Set.new(['a'])
      expect(game.correct_char_guesses.size).to eq(1)
      has_char = game.correct_char_guesses.include?('a')

      game.process_input({ data: 'a', type: :char_guess })
      expect(game.correct_char_guesses.size).to eq(1)
    end

    it "does nothing if called with a hash containing a letter that has been wrongly guessed already" do
      game = Game.new(WordsList)
      game.word = 'apple'
      game.wrong_char_guesses = Set.new(['z'])
      expect(game.wrong_char_guesses.size).to eq(1)
      has_char = game.wrong_char_guesses.include?('z')

      game.process_input({ data: 'z', type: :char_guess })
      expect(game.wrong_char_guesses.size).to eq(1)
    end

    it "adds a word guess if called with a hash containing a word guess that is not the word" do
      game = Game.new(WordsList)
      game.word = 'apple'
      expect(game.word_guesses.size).to eq(0)

      game.process_input({ data: 'eagle', type: :word_guess })
      has_word = game.word_guesses.include?('eagle')
      expect(has_word).to eq(true)
      expect(game.word_guesses.size).to eq(1)
    end
  end

  describe "use_game_save" do
    it "works if called" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      expect(game.game_saves).not_to eq(nil)
    end
  end

  describe "is_valid_command?" do
    it "returns false if called with any string and Game class object is missing the GameSave class object dependency injection" do
      game = Game.new(WordsList)
      expect(game.is_valid_command?("!new")).to eq(false)
    end

    it "returns false if called with an invalid command string" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      expect(game.is_valid_command?("new")).to eq(false)
    end

    it "returns false if called with an command string is separated by more than 2 whitespace chars" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      expect(game.is_valid_command?("n e w")).to eq(false)
    end

    it "returns false if called with an invalid 1-word command string" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      expect(game.is_valid_command?("!newz")).to eq(false)
    end

    it "returns false if called with an 2-word command string whose 1st word is not '!load'" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      expect(game.is_valid_command?("!laad 1")).to eq(false)
    end

    it "returns false if called with '!load asdf' and the save file 'asdf' does not exist and game has not started" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      expect(game.is_valid_command?("!load asdf")).to eq(false)
    end

    it "returns false if called with '!new' and game has started" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      game.is_playing = true
      expect(game.is_valid_command?("!new")).to eq(false)
    end

    it "returns false if called with '!load save_1' and game has started" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      game.is_playing = true
      expect(game.is_valid_command?("!load save_1")).to eq(false)
    end

    it "returns true if called with '!sAvE' and game has started" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      game.is_playing = true
      expect(game.is_valid_command?("!sAvE")).to eq(true)
    end

    it "returns true if called with '!NEW' and game has not started" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      expect(game.is_valid_command?("!NEW")).to eq(true)
    end

    it "returns true if called with '!load test_save_0' and game has not started and and the save file 'test_save_0' exists" do
      game = Game.new(WordsList)
      game.use_game_save(GameSave.new)
      folder = game.game_saves.get_saves_path
      delete_saves_folder(folder)
      create_test_saves(folder, 1)
      expect(game.is_valid_command?("!load test_save_0")).to eq(true)
    end
  end

  describe "get_random_word" do
    it "returns a random English word with only alphabet chars and of a valid size" do
      game = Game.new(WordsList)
      res = game.get_random_word
      expect(res.size).to be_between(game.min_word_size, game.max_word_size)
      res.each_char do |char|
        expect(char).to be_between('a', 'z')
      end
    end
  end
end
