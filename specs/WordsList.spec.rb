require_relative 'spec_helper'
require_relative '../classes/WordsList'

RSpec.describe "WordsList Class" do
  describe "get_list" do
    it "returns a filtered list when called with ([5, 12], 10)" do
      res = WordsList.get_list([5, 12], 10)
      expect(res.size).to be_between(0, 10)
      res.each do |word|
        expect(word.size).to be_between(5, 12)
      end
    end
  end
end
