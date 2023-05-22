class WordsList
  @@file_name = "google-10000-english-no-swears.txt"
  FALLBACK_WORDS = ["worthless"]

  def self.file_name
    @@file_name
  end

  def self.get_list(file_path = @@file_name, size_range = [], limit = 0)
    return FALLBACK_WORDS unless File.exist?(file_path)

    min_size, max_size = size_range
    is_valid_size_range = true
    if (size_range.class != Array or
        size_range.size != 2 or
        min_size.class != Integer or
        max_size.class != Integer or
        min_size < 1 or
        max_size < min_size)
      is_valid_size_range = false
    end

    is_valid_limit = limit.class == Integer && limit > 0

    res = []
    word_list = File.open(file_path, "r")

    until word_list.eof?
      word = word_list.readline.chomp
      if (is_valid_size_range &&
        (word.size > max_size ||
        word.size < min_size))
        next
      end
      res.push(word)
    end

    word_list.close

    res = res.take(limit) if is_valid_limit

    res.size == 0 ? ["example"] : res
  end
end
