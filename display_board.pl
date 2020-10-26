% play().
% initial(-GameState).
% valid_moves(+GameState, +Player, -ListOfMoves).
% move(+GameState, +Move, -NewGameState).
% game_over(+GameState, -Winner).
% value(+GameState, +Player, -Value).
% choose_move(+GameState, +Player, +Level, -Move).

:- use_module(library(random)).

% Initial Configuration of Board
:- dynamic(board/1).

piece([w], 9651). % △
piece([g], 9709). % ◭
piece([b], 9650). % ▲
piece([], 32).

board([
    [[w], [w], [], [], [], []],
    [[], [b], [], [], [b], []],
    [[], [], [], [b], [], []],
    [[b], [w], [], [b], [], []],
    [[], [w], [], [], [], []],
    [[], [], [], [g], [], []]
]).

% Display game board

display_piece(H) :-
    piece(H, CharCode),
    CharCode == 32,
    put_code(CharCode),
    put_code(CharCode),
    put_code(CharCode),
    put_code(CharCode).

display_piece(H) :-
    piece(H, CharCode),
    put_code(32),
    put_code(CharCode),
    put_code(53),
    put_code(32).

display_collumn_id([], _ID).

display_collumn_id([_H|T], ID) :-
    put_code(32),
    put_code(32),
    put_code(ID),
    put_code(32),
    put_code(32),
    ID1 is ID + 1,
    display_collumn_id(T, ID1).

display_top_middle([_H|[]]).

display_top_middle([_H|T]) :-
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9516), % ┬
    display_top_middle(T).

display_top([H|T]) :-
    put_code(32),
    put_code(32),
    put_code(9484), % ┌
    display_top_middle([H|T]),
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9488). % ┐

display_row_id(ID) :-
    put_code(ID),
    put_code(32).

display_row_middle([]).

display_row_middle([H|T]) :-
    display_piece(H),
    put_code(9474), % │
    display_row_middle(T).

display_row([H|T], ID) :-
    display_row_id(ID),
    put_code(9474), % │
    display_row_middle([H|T]).

display_line_middle([_H|[]]).

display_line_middle([_H|T]) :-
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9532), % ┼
    display_line_middle(T).

display_line([H|T]) :-
    put_code(32),
    put_code(32),
    put_code(9474), % │
    display_line_middle([H|T]),
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9474). % │

display_bottom_middle([_H|[]]).

display_bottom_middle([_H|T]) :-
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9524), % ┴
    display_bottom_middle(T).

display_bottom([H|T]) :-
    put_code(32),
    put_code(32),
    put_code(9492), % └
    display_bottom_middle([H|T]),
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9472), % ─
    put_code(9496). % ┘

display_board_middle([H|[]], _ID) :-
    display_row(H, _ID), nl.

display_board_middle([H|T], ID) :-
    display_row(H, ID), nl,
    display_line(H), nl,
    ID1 is ID + 1,
    display_board_middle(T, ID1).

display_board([H|T]) :-
    put_code(32),
    put_code(32),
    display_collumn_id(H, 65), nl,
    display_top(H), nl,
    display_board_middle([H|T], 49),
    display_bottom(H).

display_board :-
    board(X),
    display_board(X).

