:- use_module(library(clpfd)).
/*
Add constraints and find answers
 */

puzzle_solution(Puzzle):-
    constrainTheDiagonal(Puzzle),
    constrainEachRow(Puzzle),
    constrainEachColumn(Puzzle),
    flatten(Puzzle,[_|Vars]),
    label(Vars).

/* 
for 2×2  3×3  4×4  puzzles,
all squares on the diagonal line from upper 
left to lower right contain the same value
 */
constrainTheDiagonal(Puzzle):-
    (
        Puzzle = [
            [_,_,_],
            [_,A,_],
            [_,_,A]
        ]
    ;    Puzzle = [
            [_,_,_,_],
            [_,A,_,_],
            [_,_,A,_],
            [_,_,_,A]
        ]
    ;    Puzzle = [
            [_,_,_,_,_],
            [_,A,_,_,_],
            [_,_,A,_,_],
            [_,_,_,A,_],
            [_,_,_,_,A]
        ]
    ).

/* 
Add constraints to each row
 */
constrainEachRow(Puzzle):-
    Puzzle = [_|Rows],
    maplist(constrain, Rows).

/* 
Add constraints to each column
 */
constrainEachColumn(Puzzle):-   
    transpose(Puzzle, Transposed),
    constrainEachRow(Transposed).

/*
Constraints on each column or row
1. each to be filled in with a single digit 1–9
2. each row and each column contains no repeated digits;
3. the heading of reach row and column (leftmost square in a row and topmost square in a column) holds either the 
sum or the product of all the digits in that row or column 
 */
constrain([H|T]):-
    ins(T, ..(1,9)),
    all_distinct(T),
    (
        foldl(buildAddExpr, T, 0, AddExpr), #=(AddExpr, H)
    ;   foldl(buildMulExpr, T, 1, MulExpr), #=(MulExpr, H)
    ).

/* 
Combine two variables into an add expression
 */
buildAddExpr(A,B, A+B).
/* 
Combine two variables into an mul expression
 */
buildMulExpr(A,B, A*B).
