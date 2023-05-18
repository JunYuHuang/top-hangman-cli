require_relative 'spec_helper'
require_relative '../classes/Game'
require_relative '../classes/WordsList'

RSpec.describe "Game Class" do
  describe "initialize" do
    it "works" do
      game = Game.new(WordsList)
      expect(game.word.class).to eq(String)
      expect(game.word.size).to eq(0)
    end
  end
end
