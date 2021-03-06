print_square([], ColumnNumbers, []) :-
    print_columns_numbers(ColumnNumbers).          

print_square([RowNumber|T1], ColumnNumbers, [Line|T2]) :-    
    print_row(Line, RowNumber),            % Print row
    print_square(T1, ColumnNumbers, T2).   % Print rest of square

print_row([], RowNumber) :-
    format(' ~w\n', RowNumber).

print_row([0|T], RowNumber) :-         % Blank cell
    put_code(9633), 
    print(' '),        
    print_row(T, RowNumber).           

print_row([1|T], RowNumber) :-         % Filled cell
    put_code(9632),
    print(' '),
    print_row(T, RowNumber).


print_columns_numbers([]).

print_columns_numbers([ColumnNumber|T]) :-
    print(ColumnNumber), print(' '),
    print_columns_numbers(T).


print_solution(StartsX, StartsY, SquareSizes) :-
    nl,
    print('Row   : '),
    print_list(StartsX), 
    print('Column: '),
    print_list(StartsY), 
    print('Sizes : '),
    print_list(SquareSizes), 
    nl.

print_list([]) :- nl.
print_list([H|T]) :-
    print(H), print('   '),
    print_list(T).
