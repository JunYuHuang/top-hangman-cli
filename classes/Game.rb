require 'set'

class Game
  @@wrong_guesses_to_hangman = {
    10 => [
      "   ____\n",
      "  |    |\n",
      " _O_   |\n",
      "/ | \\  |\n",
      " / \\   |\n",
      "/   \\  |\n",
      "_______|_______\n"
    ],
    9 => [
      "   ____\n",
      "  |    |\n",
      " _O_   |\n",
      "/ | \\  |\n",
      " / \\   |\n",
      "/      |\n",
      "_______|_______\n"
    ],
    8 => [
      "   ____\n",
      "  |    |\n",
      " _O_   |\n",
      "/ | \\  |\n",
      " /     |\n",
      "/      |\n",
      "_______|_______\n"
    ],
    7 => [
      "   ____\n",
      "  |    |\n",
      " _O_   |\n",
      "/ | \\  |\n",
      " /     |\n",
      "       |\n",
      "_______|_______\n"
    ],
    6 => [
      "   ____\n",
      "  |    |\n",
      " _O_   |\n",
      "/ | \\  |\n",
      "       |\n",
      "       |\n",
      "_______|_______\n"
    ],
    5 => [
      "   ____\n",
      "  |    |\n",
      " _O_   |\n",
      "  | \\  |\n",
      "       |\n",
      "       |\n",
      "_______|_______\n"
    ],
    4 => [
      "   ____\n",
      "  |    |\n",
      "  O_   |\n",
      "  | \\  |\n",
      "       |\n",
      "       |\n",
      "_______|_______\n"
    ],
    3 => [
      "   ____\n",
      "  |    |\n",
      "  O_   |\n",
      "  |    |\n",
      "       |\n",
      "       |\n",
      "_______|_______\n"
    ],
    2 => [
      "   ____\n",
      "  |    |\n",
      "  O    |\n",
      "  |    |\n",
      "       |\n",
      "       |\n",
      "_______|_______\n"
    ],
    1 => [
      "   ____\n",
      "  |    |\n",
      "  O    |\n",
      "       |\n",
      "       |\n",
      "       |\n",
      "_______|_______\n"
    ],
    0 => [
      "   ____\n",
      "  |    |\n",
      "       |\n",
      "       |\n",
      "       |\n",
      "       |\n",
      "_______|_______\n"
    ],
  }

  def initialize(words_list_class)
    @words_list = words_list_class
    @min_word_size = 5
    @max_word_size = 12
    @word = ""
    @max_wrong_guesses = 10
    @wrong_char_guesses = Set.new
    @correct_char_guesses = Set.new
    @word_guesses = []
    @game_saves = nil
    @commands = Set.new(["!new", "!save"])
  end

  attr_reader(:words_list)
  attr_reader(:min_word_size)
  attr_reader(:max_word_size)
  attr_accessor(:word)
  attr_accessor(:max_wrong_guesses)
  attr_accessor(:wrong_char_guesses)
  attr_accessor(:correct_char_guesses)
  attr_accessor(:word_guesses)
  attr_accessor(:game_saves)
  attr_reader(:commands)

  def play
    loop do
      unless is_word_set?
        @word = get_random_word
      end

      process_input(get_guesser_input)

      if did_guesser_win? || did_guesser_lose?
        print_game_over_screen
        return
      end
    end
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

  def count_wrong_guesses
    wrong_word_guesses = @word_guesses.select { |w| w != @word }
    guesses = @wrong_char_guesses.size + wrong_word_guesses.size
  end

  def did_guesser_lose?
    count_wrong_guesses >= @max_wrong_guesses
  end

  def did_guesser_win?
    return false if count_wrong_guesses >= @max_wrong_guesses
    return true if @correct_char_guesses.size == Set.new(@word.split('')).size
    @word_guesses.size > 0 && word_guesses[-1] == @word
  end

  def get_random_word
    file_path = "assets/" + @words_list.file_name
    words = @words_list.get_list(file_path, [@min_word_size, @max_word_size])
    random_pos = Random.new.rand(0..words.size - 1)
    words[random_pos]
  end

  def get_guesser_input
    is_valid_input = true
    last_input = nil
    loop do
      print_guesser_turn_screen(is_valid_input, last_input)
      guesser_input = gets.chomp.downcase

      if is_valid_char_guess?(guesser_input)
        return { data: guesser_input, type: :char_guess }
      elsif is_valid_word_guess?(guesser_input)
        return { data: guesser_input, type: :word_guess }
      end

      is_valid_input = false
      last_input = guesser_input
    end
  end

  def process_input(guesser_input)
    guesser_input => { data:, type: }

    case type
    when :char_guess
      word_set = Set.new(@word.split(''))

      if word_set.include?(data)
        @correct_char_guesses.add(data)
      else
        @wrong_char_guesses.add(data)
      end
    when :word_guess
      @word_guesses.push(data)
      @correct_char_guesses.merge(data.split('')) if data == @word
    end
  end

  def use_game_save(game_save_obj)
    @game_saves = game_save_obj
  end

  def is_valid_command?(input)
    return false if !@game_saves
    args = input.split(" ")
    return false if args.size > 2
    return @commands.include?(args[0].downcase) if args.size == 1
    load_command, save_name = args
    return false if load_command.downcase != "!load"
    @game_saves.does_save_exist?(save_name.downcase)
  end

  def clear_console
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      system('cls')
    else
      system('clear')
    end
  end

  def print_hangman
    count = count_wrong_guesses
    is_valid_guesses_left = count >= 0 && count <= @max_wrong_guesses
    wrong_guesses = is_valid_guesses_left ? count : 0
    puts("#{@@wrong_guesses_to_hangman[wrong_guesses].join}\n")
  end

  def print_masked_word
    word = get_masked_word.join(' ')
    puts("#{word}\n\n")
  end

  def print_wrong_char_guesses
    res = @wrong_char_guesses.to_a.sort.map { |char| char.upcase }
    puts("#{res.join(', ')}\n\n")
  end

  def print_wrong_guess_tries_left
    count = @max_wrong_guesses - count_wrong_guesses
    puts("Wrong guess attempts left: #{count}\n")
  end

  def print_guesser_prompt(is_valid, input)
    res = [
      "The word is #{@word.size} English alphabet characters long.\n",
      "#{is_valid ? '' : "'#{input}' is not a valid guess. Try again."}\n",
      "Enter your guess (letter or whole word):\n"
    ]
    puts(res.join)
  end

  def print_game_end_result
    player_result_msg = did_guesser_win?() ? "You guessed the word!" : "Better luck next time."
    res = [
      "Game ended: #{player_result_msg}\n",
      "The word was '#{@word.upcase}'.\n"
    ]
    puts(res.join)
  end

  def print_game_over_screen
    clear_console
    print_hangman
    print_masked_word
    print_wrong_char_guesses
    print_game_end_result
  end

  def print_guesser_turn_screen(is_valid, input)
    clear_console
    print_hangman
    print_masked_word
    print_wrong_char_guesses
    print_wrong_guess_tries_left
    print_guesser_prompt(is_valid, input)
  end
end
