# Planning Notes

## Basic Game Rules and Mechanics

- 2 players where
  - one is word guesser
  - one is word maker
- zero sum game
  - either guesser or maker wins at end of game
  - no tie possible

## MVP Requirements

- human player is always the guesser
- computer player is always the word maker / selecter
- initial version
  - stock, no game saves / loads
- refactored version
  - allow game saving to and loading from local saves files in `saves` folder e.g. `/saves/save_1.yaml`
- game constraints
  - 6 maximum incorrect guess attempts for the guesser
  - selected word
    - is a single English word
    - of length in range \[5, 12]
    - has alphabetical characters a-z only
- console UI 'screens'
  - in-progress game turn screen
    - show current state of hangman stick figure
    - show revealed / displayed word so far
    - show alphabetical characters that are not part of the world
    - show count of how many incorrect guess attempts the guesser has
    - prompt for the user's input
      - a single character alphabetical character (case insensitive)
      - a word guess of length in range \[5, 12] of alphabetical characters (case insensitive)
      - the command `!save` that redirects to the save screen
  - home menu screen
    - only shows if there is at least 1 saved game on file
    - prompts user to start a new game or from an existing game
    - redirects to `in-progress game turn screen` OR
    - redirects to `load screen`
  - save screen
    - TODO
  - load screen
    - TODO

## Game Logic and Basic Pseudocode v1

- if there are any existing local game save files
  - prompt human player to either
    - start a new game OR
    - load from an existing game file
  - if human player requested to load a game file
    - prompt player for which game file to load
    - while entered game file id is invalid,
      - prompt again for a valid game to load
    - load the game file
- while game is not over
  - if word has not been set
    - prompt word setter player (computer) for word
    - computer should read from the text file and randomly select a single word that meets the specified params (word should be of size in range \[5, 12])
  - input = nil
  - while true
    - display
      - hangman ASCII art / string
      - partially revealed word
      - wrong char guesses (if any)
      - wrong guess attempts left
      - word guesser prompt message
    - prompt word guesser for input
    - a valid input is either
      - a single char guess that hasn't been guessed already OR
      - a whole word guess OR
      - a command starting with a `!`
        - for now just implement the `!save` command
    - if input is valid,
      - return a hashmap that contains the parsed input and the input type and assign it to input
        - e.g. `{ input: 'a', type: 'char_guess' }`
  - if the input is a command
    - if command is `!save`,
      - check if the game is is over
      - if game is still in progress
        - if there is less than 3 game saves (files),
          - save the game in the next save file
        - else
          - prompt the word guesser for a game save file to overwrite
          - while the input is not a valid game save file (id),
            - keep prompting
          - overwrite the existing save file with the current game
      - else return b/c we don't save completed games
  - if the input is a single char guess attempt
    - if the char is in the word
      - add it to the set of correct_char_guesses
    - else
      - add it to the set of wrong_char_guesses
      - increment the count of incorrect guess attempts
      - add the char to the set of incorrect chars
    - continue to next turn (next outer game loop)
  - if the input is a whole word guess attempt
    - append it to the string array word_guesses
    - continue to next turn (next outer game loop)
  - if the word guesser won
    - word guesser wins if:
      - if the size of correct_char_guesses equals the count of unique chars in the word OR
      - word_guesses has at least 1 string element and its last string matches the word exactly
    - game is over and word guesser won
    - display
      - hangman ASCII art / string
      - fully revealed word
      - incorrected char guesses (if any)
      - word guesser winner message
      - revealed word message
    - return out of outer game loop
  - if the word guesser lost
    - met if word guesser meets the max wrong guess limit
      - \# wrong char guesses + \# wrong word guesses == max wrong guess limit
    - game is over and word setter won
    - display
      - hangman ASCII art / string
      - partially revealed word
      - wrong char guesses (if any)
      - loser message (computer player won)
      - revealed word message
    - return to break out of outer game loop

## Game Logic and Basic Pseudocode v2

- if there are any existing local game save files
  - prompt human player to either
    - start a new game OR
    - load from an existing game file
  - if human player requested to load a game file
    - display a "table" of existing save files
    - prompt player for which game file to load
    - while entered game file id is invalid,
      - prompt again for a valid game to load
    - load the game file
  - else start a new game
- while game is not over
  - if word has not been set
    - set it from a randomly selected word from dictionary text file
  - get input from human player (guesser)
    - do something based on what the input is
    - if the input is a valid guess (single letter or word)
      - update game state
    - else if the input is a valid command to save the current game i.e. `!save`
      - save the current game's state as a new save file under `/saves/save_{save_count}.yaml`
      - display something in the next turn screen that indicates that the game was saved successfully as `save_{save_count}`
  - if guesser won or lost
    - print game end summary screen
    - return and exit game

## Expanded Pseudocode / Partial Code

- `WordsList` module or module
  - `PATH_TO_FILE`: string that points to word list from `classes/index.rb` file
  - get_list(size_range, limit = none)
    - returns a string array that passes all the range specified in the `size_range` array
    - `size_range`: int array of size 2 where
      - `size_range[0]`: int > 0
      - `size_range[1]`: int >= `size_range[0]`
    - `limit`: non-zero positive int represents the max count of the elements from the list to return
    - returns unfiltered list if `size_range` or `limit` does not meet criteria above

- `Game` class
  - includes `WordsList` module or class
  - includes `GameSaves` moduel or class
  - constructor()
    - @`min_word_size`: int = 5
    - @`max_word_size`: int = 12
    - @`word`: string = empty string
      - is always lowercase
      - in range \[`min_word_size`, `max_word_size`]
    - @`masked_word`: string array
      - represents chars in the word that the guesser has correctly guessed
      - chars not in the word not yet guessed correctly are represented by an underscore `_`
      - initially set to a string array of all `_` chars
      - size == @`word`.size
    - @`max_wrong_guesses`: int = 6
    - @`wrong_char_guesses`: set of lowercase alpha chars inputted by the guesser
    - @`correct_char_guesses`: set of lowercase alpha chars inputted by the guesser
    - @`word_guesses`: string array of word guesses made by the guesser
      - initially an empty array
  - play()
    - TODO
  - is_word_set?()
    - TODO
  - get_random_word()
    - TODO
  - did_guesser_lose?()
    - TODO
  - is_valid_char_guess?()
    - TODO
  - is_valid_word_guess?()
    - TODO
  - get_guesser_input(input)
    - TODO
  - did_guesser_win?()
    - TODO
  - print_hangman()
    - TODO
  - print_masked_word()
    - TODO
  - print_wrong_char_guesses()
    - TODO
  - print_wrong_guess_tries_left()
    - TODO
  - print_guesser_prompt(is_valid, input)
    - TODO
  - print_game_end_result()
    - TODO

- `GameSave` class
  - constructor(saves_path)
    - TODO
  - does_exist?(save_name)
    - TODO
  - count
    - TODO
  - create(game_state)
    - TODO
  - open(save_name)
    - TODO
  - get_name_list(limit = 0)
    - TODO

### Serialized Game State Data Structure for Game Loading / Saving (YAML)

```yaml
meta:
  id: 1
  name: "save_1"
  timestamp: "2023-05-19"
game:
  min_word_size: 5
  max_word_size: 12
  word: "excellent"
  max_wrong_guesses: 10
  wrong_char_guesses: [ "a", "o", "u"]
  correct_char_guesses: [ "e" ]
  word_guesses: [ "eagarness", "wordiness" ]
```

## UI Design

### Turn Screen

```
   ____
  |    |
 _O_   |
/ | \  |
 / \   |
/   \  |
_______|_______

C _ C _ _ _ E

F, G, H, J, K

Wrong guess attempts left: 5
The word is 7 English alphabet characters long.

Enter your guess:
```

### Home Menu Screen (appears if have 1+ save files)

```
 _____________________
| Hangman Game Saves  |
|_____________________|
| save_1              |
| save_2              |
| save_3              |
| and 0 more saves... |
|_____________________|

You have 3 Hangman game save files.
Load a game from a save file or start a new game.

Enter '!new' to start a new game.
Enter '!load <save file name>' to resume playing from a game save.
'!loadz' is not a valid choice. Try again.
Enter your choice (without quotes):
```
