# TODOs

1. [x] Make `WordsList` class fetch from the local text file.
## Implement game saving and loading to local save files.
  - Move `Game#load` method into `GameSave` class and make `GameSave` constructor take an instance of the `Game` class?
  - [x] Implement `!new` command to start a blank new game
  - [x] Implement `!save` command to save an in-progress game
  - [ ] Implement `!load <save_name>` command to load a game from a save file
