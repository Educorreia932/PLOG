read_input(Input) :-
    get_code(Character),
    read_input_all(Character, Characters),       
    name(Input, Characters), !.

read_input_all(10, []) :- !.
read_input_all(13, []) :- !.

read_input_all(Character, [Character|T]) :-
    get_code(C),
    read_input_all(C, T), !.

% Start Game

play :-
    now(T),                         % Seed for RNG
    setrand(T),                     % For randomness 
    repeat,                         % Repeat while Exit fails
        print_start_menu,           % Prints Start Menu
        read_input(Input),          % Receives user option
        option_start_menu(Input),   % Process option
        Input =:= 3.                % Exit Game

% Start Menu

option_start_menu(1) :-                  % Start Game
    print_board_menu,                    % Shows board menu
    read_input(Input),
    option_board_menu(Input),
    Input =:= 4, !.                     % Back

option_start_menu(2) :-                 % Instructions
    print_instructions, !. 
    
option_start_menu(3) :- !.              % Exit                       

print_start_menu:-
    nl,
    print('================================================'), nl,
    print('|                   GREENER                    |'), nl,
    print('================================================'), nl,
    print('                                                '), nl,
    print('                  1 - Start                     '), nl,
    print('                  2 - How to play               '), nl,
    print('                  3 - Exit                      '), nl,
    print('                                                '), nl,
    print('================================================'), nl.

% Board Menu

option_board_menu(1) :-                    % 6x6
    generate_board(6, 6, GameState),       % Generates a board 6x6
    choose_game(GameState), !.             % Unifies GameState
    
option_board_menu(2) :- 
    generate_board(6, 9, GameState),       % Generates a board
    choose_game(GameState), !.

option_board_menu(3) :- 
    generate_board(9, 9, GameState),       % Generates a board
    choose_game(GameState), !.                 
    
    option_board_menu(4) :- !.

print_board_menu:-
    nl,
    print('================================================'), nl,
    print('|                    BOARD                     |'), nl,
    print('================================================'), nl,
    print('                                                '), nl,
    print('                   1 - 6x6                      '), nl,
    print('                   2 - 6x9                      '), nl,
    print('                   3 - 9x9                      '), nl,
    print('                   4 - Back                     '), nl,
    print('                                                '), nl,
    print('================================================'), nl.

% Game Menu

choose_game(GameState) :-
    game_menu,
    read_input(Input),
    process_game_menu_input(Input, GameState).

game_menu:-
    nl,
    print('================================================'), nl,
    print('|                    GAME                      |'), nl,
    print('================================================'), nl,
    print('                                                '), nl,
    print('                1 - Player vs Player            '), nl,
    print('                2 - Player vs AI                '), nl,
    print('                3 - AI vs AI                    '), nl,
    print('                4 - Back                        '), nl,
    print('                                                '), nl,
    print('================================================'), nl.

process_game_menu_input(1, GameState) :- 
    game_loop(b, GameState, 1, 0, 0, [1]), !.

process_game_menu_input(3, GameState) :- 
    choose_strategy(GameState, 3).

% Choose AI Strategy

strategy_menu :-
    nl,
    print('================================================'), nl,
    print('|                  AI STRATEGY                 |'), nl,
    print('================================================'), nl,
    print('                                                '), nl,
    print('                  1 - Random                    '), nl,
    print('                  2 - Smart                     '), nl,
    print('                                                '), nl,
    print('================================================'), nl.

choose_strategy(GameState, GameMode) :-
    strategy_menu,
    read_input(Strategy),
    process_strategy_input(GameState, GameMode, Strategy).

process_strategy_input(GameState, GameMode, Strategy) :-
    game_loop(b, GameState, 0, 0, [GameMode, Strategy]), !.

wait_enter :-
	write('Press <Any Key> to continue.\n'),
	get_char(_), !.

% Ask play to choose a cell

choose_cell_input(Row, Column) :-
    read_input(J),
    read_input(I),
    column_index(J, Column),
    Row is I - 1.

% Ask player for its turn's move

choose_move_input(Player, GameState, NewGameState) :-
    nl,
    print('What\'s your move?'), nl,    
    choose_cell_input(I0, J0),
    choose_cell_input(I1, J1),
    process_choose_move_input(Player, GameState, [I0, J0, I1, J1], NewGameState),
    nl.

process_choose_move_input(Player, GameState, [I0, J0, I1, J1], NewGameState) :- 
    move(GameState, [I0, J0, I1, J1], NewGameState),
    valid_move(Player, GameState, NewGameState).

% Prints instructions of game

print_instructions :-
    nl,
    print('================================================================'), nl,
    print('|                           HOW TO PLAY                        |'), nl,
    print('================================================================'), nl,
    print('                                                                '), nl,
    print('   Players take turns (starting by Black) capturing pyramids or '), nl, 
    print('  stacks of any colour on the same row or column and with no    '), nl,
    print('  stacks between them.                                          '), nl,
    print('                                                                '), nl,
    print('   On your turn you must make one capture if possible, otherwise'), nl,
    print('   you pass the turn.                                           '), nl,
    print('                                                                '), nl,
    print('   The game ends when all players pass in succession.           '), nl,
    print('                                                                '), nl,
    print('   The player with the most green pyramids captured (being      '), nl,
    print('  part of stacks they control) wins the game.                   '), nl,
    print('   In case of a tie, the player with the highest stack wins.    '), nl,
    print('   If the tie persists, play again.                             '), nl,
    print('                                                                '), nl,
    print('   Good luck and have fun!                                      '), nl,
    print('                                                                '), nl,
    print('================================================================'), nl.

