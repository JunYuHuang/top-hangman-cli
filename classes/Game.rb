class Game
  @@guesses_left_to_hangman = {
    0 => [
      "  ____\n",
      " |    |\n",
      "_O_   |\n",
      " |    |\n",
      "/ \\   |\n",
      "  ____|____\n"
    ],
    1 => [
      "  ____\n",
      " |    |\n",
      "_O_   |\n",
      " |    |\n",
      "/     |\n",
      "  ____|____\n"
    ],
    2 => [
      "  ____\n",
      " |    |\n",
      "_O_   |\n",
      " |    |\n",
      "      |\n",
      "  ____|____\n"
    ],
    3 => [
      "  ____\n",
      " |    |\n",
      "_O    |\n",
      " |    |\n",
      "      |\n",
      "  ____|____\n"
    ],
    4 => [
      "  ____\n",
      " |    |\n",
      " O    |\n",
      " |    |\n",
      "      |\n",
      "  ____|____\n"
    ],
    5 => [
      "  ____\n",
      " |    |\n",
      " O    |\n",
      "      |\n",
      "      |\n",
      "  ____|____\n"
    ],
    6 => [
      "  ____\n",
      " |    |\n",
      "      |\n",
      "      |\n",
      "      |\n",
      "  ____|____\n"
    ]
  }

  def initialize(words_list_class)
    @words_list = words_list_class
    @min_word_size = 5
    @max_word_size = 12
    @word = ""
    @max_wrong_guesses = 6
    @wrong_guesses = 0
    @wrong_char_guesses = Set.new
    @correct_char_guesses = Set.new
    @word_guesses = []
  end

  attr_reader(:words_list)
  attr_reader(:min_word_size)
  attr_reader(:max_word_size)
  attr_accessor(:word)
  attr_reader(:max_wrong_guesses)
  attr_accessor(:wrong_guesses)
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
    res = []
    @word.each_char do |char|
      is_guessed = @correct_char_guesses.include?(char)
      res.push(is_guessed ? char.upcase : "_")
    end
    res
  end

  def is_alpha_char?(char)
    char.downcase >= 'a' && char.downcase <= 'z'
  end

  def is_valid_char_guess?(char)
    char.class == String && char.size == 1 && is_alpha_char?(char)
  end

  def is_valid_word_guess?(word)
    return false if word.class != String
    return false if word.size != @word.size
    word.each_char do |char|
      return false unless is_alpha_char?(char)
    end
    true
  end

  # TODO - write tests for
  def did_guesser_lose?
    # wrong_word_guesses = @word_guesses.select { |w| w != @word }
    # guesses = @wrong_char_guesses.size + wrong_word_guesses.size
    # guesses >= @max_wrong_guesses
    @wrong_guesses >= @max_wrong_guesses
  end

  # TODO - write tests for
  def did_guesser_win?
    return true if @correct_char_guesses.size == Set.new(@word.split(''))
    @word_guesses.size > 0 && word_guesses[-1] == @word
  end

  def get_random_word
    words = @words_list.get_list([@min_word_size, @max_word_size])
    random_pos = Random.new.rand(0..words.size - 1)
    words[random_pos]
  end

  def get_guesser_input
    # TODO - to test manually
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
