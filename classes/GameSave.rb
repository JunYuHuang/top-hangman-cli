class GameSave
  def initialize(saves_path = "../saves")
    # TODO
    # sets the correct path to look for game saves in
  end

  def does_folder_exist?
    # TODO
    # returns true if the saves folder `../saves/` exists else false
  end

  def create_folder
    # TODO
    # creates the `saves` folder at @saves_path
  end

  def does_save_exist?(save_name)
    # TODO
    # returns true if a `save_name` exists as a save file in `../saves/` else false
  end

  def count_saves
    # TODO
    # counts the number of save files in `../saves/` that follow the naming scheme `save_{non-negative integer that uniquely identifies the file}.yaml`
    # ignores any files that don't follow the above naming scheme
  end

  def create_save(game_state)
    # TODO
    # if the saves folder does not exist, create it
    # find a unique name for the save file
    # - set `id` to 0
    # - while true
    #   - if the game save file `save_{id}` does not exist in the `saves` folder, return
    #   - `id`++
    # - `save_name` = `save_{id}`
    # iterates thru the `game_state` data structure and
    # saves the game as a .yaml save file
    # returns the name of the newly saved name or the serialized game state object?
  end

  def open_save(save_name)
    # TODO
    # opens the save file `save_name`.yaml from the `saves` folder
    # returns the save file as some deserialized, iterable data structure
  end

  def get_save_names_list(limit = 0)
    # TODO
    # returns a string array of the names of all save files that exist in `../saves/`
  end
end
