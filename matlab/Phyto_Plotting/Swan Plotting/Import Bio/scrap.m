clear all; close all;

A = [1 3 5 5 7 6 4 4 3];
B = [2 4 6 8 10 12 14 16 18];

[C,ind] = unique(A,'sorted');
D = B(ind);