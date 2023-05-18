class Game
  def initialize(words_list_class)
    @words_list_class = words_list_class
    @min_word_size = 5
    @max_word_size = 12
    @word = ""
    @max_wrong_guesses = 6
    @wrong_char_guesses = Set.new
    @correct_char_guesses = Set.new
    @word_guesses = []
  end

  attr_reader(:words_list_class)
  attr_reader(:min_word_size)
  attr_reader(:max_word_size)
  attr_accessor(:word)
  attr_reader(:max_wrong_guesses)
  attr_accessor(:wrong_char_guesses)
  attr_accessor(:correct_char_guesses)
  attr_accessor(:word_guesses)

  def play
    # TODO
  end

  def is_word_set?
    @word.size >= min_word_size && @word.size <= max_word_size
  end

  def get_masked_word
    # TODO
  end

  def get_random_word
    # TODO
  end

  def did_guesser_lose?
    # TODO
  end

  def is_valid_char_guess?
    # TODO
  end

  def is_valid_word_guess?
    # TODO
  end

  def get_guesser_input
    # TODO
  end

  def did_guesser_win?
    # TODO
  end

  def print_hangman
    # TODO
  end

  def print_masked_word
    # TODO
  end

  def print_wrong_char_guesses
    # TODO
  end

  def print_wrong_guess_tries_left
    # TODO
  end

  def print_guesser_prompt(is_valid, input)
    # TODO
  end

  def print_game_end_result
    # TODO
  end
end
