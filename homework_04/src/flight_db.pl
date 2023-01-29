% facts, knowledge base for connections, (source, destination, cost)
:- style_check(-singleton).

schedule(canakkale, erzincan, 6).

schedule(erzincan, canakkale, 6).
schedule(erzincan, antalya, 3).

schedule(antalya, erzincan, 3).
schedule(antalya, izmir, 2).
schedule(antalya, diyarbakir, 4).

schedule(diyarbakir, antalya, 4).
schedule(diyarbakir, ankara, 8).

schedule(ankara, diyarbakir, 8).
schedule(ankara, izmir, 6).
schedule(ankara, istanbul, 1).
schedule(ankara, rize, 5).
schedule(ankara, van, 4).

schedule(izmir, antalya, 2).
schedule(izmir, istanbul, 2).
schedule(izmir, ankara, 6).

schedule(istanbul, izmir, 2).
schedule(istanbul, ankara, 1).
schedule(istanbul, rize, 4).
schedule(istanbul, kocaeli, 2).

schedule(kocaeli, istanbul, 2).
schedule(kocaeli, rize, 6).

schedule(rize, istanbul, 4).
schedule(rize, ankara, 5).
schedule(rize, kocaeli, 6).
schedule(rize, sinop, 2).

schedule(sinop, rize, 2).
schedule(sinop, van, 5).

schedule(van, ankara, 4).
schedule(van, gaziantep, 3).
schedule(van, sinop, 5).

schedule(gaziantep, van, 3).

% rules for flight connections

% if X and Y has a direct connection, then C is the cost of the connection
% else indirect connection is searched
connection(X, Y, C) :- indirect_connection(X, Y, C, [X]).

% if direct connection is found
indirect_connection(X, Y, C, Visited) :- 
                                            schedule(X, Y, C),
                                            not(member(Y, Visited)),
                                            reverse(Visited, P),
                                            append(P, [Y], Path),
                                            format('~nPath: ~w~n', [Path]).

% rule for indirect connections, not to visit the same city twice, and city is not the same as the destination
% recursively searches for indirect connections, at each step, the cost of the connection is added to the total cost
% visited cities are held to prevent visiting the same city twice 
indirect_connection(X, Y, C, Visited) :-    
                                            schedule(X, T, C1),
                                            not(X = T), not(member(T, Visited)),
                                            indirect_connection(T, Y, C2, [T|Visited]),
                                            not(X = Y), not(Y = T),
                                            C is C1 + C2.