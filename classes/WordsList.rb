class WordsList
  PATH_TO_LIST = "assets/google-10000-english-no-swears.txt"

  def self.get_list(size_range, limit = 0)
    # temp commented out below guard clause until can figure out how to read and parse the string input from the text file in `PATH_TO_LIST`
    # return [] unless File.exists?(PATH_TO_LIST)

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

    # TODO - open file and add every word as an element to an array
    # File.open(PATH_TO_LIST, "r")

    res = ["crack", "submarine", "balloon", "triangle", "computer"]

    if is_valid_size_range
      min_size, max_size = size_range
      res = res.select { |word|
        word.size >= min_size && word.size <= max_size
      }
    end

    if is_valid_limit
      res = res.take(limit)
    end

    res
  end
end
