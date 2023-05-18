require_relative 'spec_helper'
require_relative '../classes/Game'
require_relative '../classes/WordsList'

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
    it "returns false if called with 'was'" do
      game = Game.new(WordsList)
      expect(game.is_valid_word_guess?('was')).to eq(false)
    end

    it "returns false if called with 'supermegalongword'" do
      game = Game.new(WordsList)
      expect(game.is_valid_word_guess?('supermegalongword')).to eq(false)
    end

    it "returns false if called with 'badword!'" do
      game = Game.new(WordsList)
      expect(game.is_valid_word_guess?('badword!')).to eq(false)
    end

    it "returns true if called with 'excellent'" do
      game = Game.new(WordsList)
      expect(game.is_valid_word_guess?('excellent')).to eq(true)
    end
  end

  # TODO - various missing tests

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
