# Wordle_Game

## Tutorial
- You'll have 6 chances to guess the 5-letter word, so make every guess count! Try using a word that contains many different letters to narrow down your future guesses.

- After you make a guess, the tile colors will change:
> A green tile indicates that you've guessed the correct letter in the correct place in the word. </br>
> A yellow tile means you've guessed a letter that's in the word, but not in the right spot. </br>
> A gray tile means that letter is not in word. </br>

- Use the clues you got from your previous guess to try to find the correct word. Good Luck ^^

## Demo

https://user-images.githubusercontent.com/85553681/158769038-c321f3a0-8c41-4fae-87db-8aa6f5a526e3.mp4

## Time consuming
- February to March (2022)

## Note
- Stay tuned, this project is not perfect yet. I'll comeback and make this game great again, someday.


## X, File Structure
```
lib
|   di.dart
|   main.dart
|   structure.txt
|   zbug.txt
|   
\---src
    +---common
    |   +---class
    |   |       list_notifier.dart
    |   |       my_toast.dart
    |   |       state_notifier.dart
    |   |       
    |   +---interface
    |   |       ui_notifier.dart
    |   |       widget_lifecycle.dart
    |   |       
    |   +---provider
    |   |   |   text_styles.dart
    |   |   |   theme_provider.dart
    |   |   |   
    |   |   \---annotation
    |   |           description.dart
    |   |           
    |   \---widget
    |       |   svg_icon.dart
    |       |   
    |       \---ads
    |               banner_ads.dart
    |               
    +---data_source
    |   +---ads
    |   |   |   ads_repository.dart
    |   |   |   ads_repository_impl.dart
    |   |   |   README.md
    |   |   |   
    |   |   \---types
    |   |           banner_ads.dart
    |   |           full_screen_ads.dart
    |   |           native_ads.dart
    |   |           reward_ads.dart
    |   |           
    |   +---local_db
    |   |   +---key_value
    |   |   |   |   key_value_repository.dart
    |   |   |   |   key_value_repository_impl.dart
    |   |   |   |   
    |   |   |   +---get_data
    |   |   |   |       hive_key_value_impl.dart
    |   |   |   |       key_value_accessor.dart
    |   |   |   |       
    |   |   |   \---modal
    |   |   |           save_game_model.dart
    |   |   |           save_game_model.g.dart
    |   |   |           
    |   |   \---table
    |   |           table_db.dart
    |   |           
    |   +---remote_db
    |   |       README.md
    |   |       remote_db_repository.dart
    |   |       remote_db_repository_impl.dart
    |   |       
    |   +---song_list
    |   |       README.md
    |   |       song_list_db.dart
    |   |       song_list_db_impl.dart
    |   |       song_list_repository.dart
    |   |       song_list_repository_impl.dart
    |   |       
    |   \---word_list
    |           vocab.dart
    |           word_list_db.dart
    |           word_list_db_impl.dart
    |           word_list_repository.dart
    |           word_list_repository_impl.dart
    |           
    +---ui
    |   |   routes.dart
    |   |   
    |   +---end_game_screen
    |   |       end_game_screen.dart
    |   |       end_game_screen_controller.dart
    |   |       
    |   +---game_screen
    |   |   |   game_screen.dart
    |   |   |   
    |   |   +---controller
    |   |   |   |   game_screen_controller.dart
    |   |   |   |   observable_game_data.dart
    |   |   |   |   setup_keyboard.dart
    |   |   |   |   setup_save_game.dart
    |   |   |   |   setup_wordboard.dart
    |   |   |   |   
    |   |   |   \---states
    |   |   |           character_state.dart
    |   |   |           character_state.g.dart
    |   |   |           game_state.dart
    |   |   |           game_state.g.dart
    |   |   |           type_state.dart
    |   |   |           
    |   |   +---key_board
    |   |   |       key_board.dart
    |   |   |       key_board_button.dart
    |   |   |       
    |   |   +---top_bar
    |   |   |       top_bar.dart
    |   |   |       
    |   |   \---word_board
    |   |           char_box.dart
    |   |           word_board.dart
    |   |           
    |   +---guide_screen
    |   |       guide_screen.dart
    |   |       
    |   +---setting_screen
    |   |       setting_screen.dart
    |   |       
    |   \---splash_screen
    |           splash_screen.dart
    |           splash_screen_controller.dart
    |           
    \---utils
        |   constants.dart
        |   extension.dart
        |   get_width_height.dart
        |   logger.dart
        |   
        \---res
                dimens.dart
                tint.dart
                
```

