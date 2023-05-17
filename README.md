# Hangman Console Game

This is a console implementation of the classic pencil-and-paper game 'Hangman' that allows you to play as the guesser against the computer bot player that will pick a random English word for you to correctly guess.

Game Parameters and Features:
* The secret word
  * Is chosen from the text file in the [`google-10000-english` repository.](https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt)
  * Has a character length in the range \[5, 12] inclusive.
  * Is composed only of alphabetical characters (e.g., no special characters, no punctutation symbols, etc.)
  * Is a single word and NOT a phrase or sentence.
* Up to 6 maximum tries to correctly guess the word.
* Save in-progress games in 1 of 3 game save slots.
* Saving more than 3 games will overwrite an existing game save slot of the player's choice.

## Quick Start

### Requirements

- Ruby 3.1.4
- rspec (optional; only for running tests)
### How to run

```bash
ruby index.rb
```

### How to test

```bash
# if not installed already
gem install rspec

cd specs
rspec index.spec.rb
```

## Skills Demonstrated

- OOP Design
- Unit and Integration Testing
- Input Validation
- Handling Edge Cases
- File Input/Output
- Persistent Storage with Writing and Reading to Local Files
