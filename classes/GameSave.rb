require 'yaml'

class GameSave
  def initialize(saves_path = "../saves")
    @saves_path = saves_path
  end

  attr_accessor(:saves_path)

  def does_folder_exist?
    Dir.exist?(@saves_path)
  end

  def create_folder
    Dir.mkdir(@saves_path)
  end

  def does_save_exist?(save_name)
    return false unless does_folder_exist?
    File.exist?("#{@saves_path}/#{save_name}.yaml")
  end

  def count_saves(saves_name_prefix = "save_")
    return 0 unless does_folder_exist?
    Dir.glob("#{saves_path}/#{saves_name_prefix}*.{yaml,yml}").length
  end

  def get_unique_id(saves_name_prefix = "save_")
    id = 0
    loop do
      break unless does_save_exist?("#{saves_name_prefix}#{id}")
      id += 1
    end
    id
  end

  def encode(game_obj)
    res = YAML.dump({
      min_word_size: game_obj.min_word_size,
      max_word_size: game_obj.max_word_size,
      word: game_obj.word,
      max_wrong_guesses: game_obj.max_wrong_guesses,
      wrong_char_guesses: game_obj.wrong_char_guesses.to_a,
      correct_char_guesses: game_obj.correct_char_guesses.to_a,
      word_guesses: game_obj.word_guesses
    })
    res
  end

  def decode(string)
    YAML.load(string)
  end

  def create_save(game_obj, saves_name_prefix = "save_")
    create_folder unless does_folder_exist?
    save_name = "#{saves_name_prefix}#{get_unique_id(saves_name_prefix)}"
    save = File.new("#{saves_path}/#{save_name}.yaml", "w+")
    save.puts(encode(game_obj))
    save.close
    save_name
  end

  def open_save(save_name)
    file = File.open("#{@saves_path}/#{save_name}.yaml", "r")
    res = decode(file)
    file.close
    res
  end

  def get_save_names_list(saves_name_prefix = "save_", limit = 0)
    return [] unless does_folder_exist?
    res = Dir.glob("#{@saves_path}/#{saves_name_prefix}*.{yaml,yml}")
    res = res.map do |save_path|
      save_path.delete_prefix("#{saves_path}/").delete_suffix(".yaml")
    end
    limit > 0 ? res.take(limit) : res
  end

  def delete_saves_folder
    saves = Dir.glob("#{@saves_path}/*")
    saves.each { |f| File.delete(f) } if saves.size > 0
    Dir.rmdir(@saves_path) if Dir.exist?(@saves_path)
  end
end
