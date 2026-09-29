#import "../../practice-paper.typ": *

#paper(id: "G9 MATH · SETS · PAPER 01")[
  #sec("A — Multiple Choice · 1 mark each")
  #pairgrid(
    mc(1)[Which one of the following is a *well-defined* set?][collection of beautiful girls in your class][the set of vowel letters of the English alphabet][collection of hardworking teachers in a school][collection of good basketball players],
    mc(2)[Given $A = \{2, 4, 6, 8, 10\}$, which statement is true?][$2 in.not A$][$7 in A$][$4 in A$][$6 in.not A$],
    mc(3)[The set $A = \{1, 3, 5, 7, 9, dots\}$ in set-builder form is][${x | x in NN, "x is even"}$][${x | x in NN, "x is odd"}$][${x | x in NN, x > 9}$][${x | x in ZZ, x > 0}$],
    mc(4)[Which one of the following is an *empty set*?][$\{x | x in NN and 5 < x < 6\}$][$\{0\}$][$\{x | x in NN and x <= 1\}$][$\{2\}$],
    mc(5)[The set of all even natural numbers is a][finite set][empty set][infinite set][universal set],
    mc(6)[If $A = \{1, 2, 3\}$, the number of *proper subsets* of $A$ is][8][7][6][3],
    mc(7)[$A = \{0, 1, 3, 5, 7\}$ and $B = \{1, 2, 3, 4, 6, 7\}$. Then $A union B =$][$\{0, 1, 3, 5, 7\}$][$\{1, 3, 7\}$][$\{0, 1, 2, 3, 4, 5, 6, 7\}$][$\{2, 4, 6\}$],
    mc(8)[Using the sets in Q7, $A inter B =$][$\{0, 2, 4, 6\}$][$\{1, 3, 7\}$][$\{0, 1, 2, 3, 4, 5, 6, 7\}$][$emptyset$],
    mc(9)[Given $U = \{1, 2, 3, 4, 5\}$ and $A = \{2, 4\}$, then $A' =$][$\{1, 3, 5\}$][$\{2, 4\}$][$\{1, 2, 3, 4, 5\}$][$emptyset$],
    mc(10)[If $B = \{3, 4\}$ and $A = \{1, 2, 3, 4\}$, then][$B$ is a proper subset of $A$][$A subset B$][$B supset A$][$A = B$],
    mc(11)[Two sets $A$ and $B$ are *disjoint* if][$A = B$][$A subset B$][$A inter B = emptyset$][$A union B = emptyset$],
    mc(12)[Sets $A$ and $B$ are *equal* if][$n(A) = n(B)$][$A subset B$ only][every element of $A$ is in $B$ and every element of $B$ is in $A$][$A inter B = emptyset$],
    mc(13)[$A = \{1, 2, 3, 4\}$, $B = \{3, 4, 5, 6\}$. Then $A backslash B =$][$\{3, 4\}$][$\{1, 2\}$][$\{5, 6\}$][$\{1, 2, 3, 4, 5, 6\}$],
    mc(14)[If $A = \{1, 2, 3\}$ and $B = \{3, 4, 5\}$, then $A triangle.b B =$][$\{3\}$][$\{1, 2, 4, 5\}$][$\{1, 2\}$][$\{1, 2, 3, 4, 5\}$],
    mc(15)[$n(A) = 20$, $n(B) = 28$ and $n(A union B) = 36$. Then $n(A inter B) =$][48][12][8][20],
    mc(16)[The number of subsets of a set having 6 elements is][12][32][64][128],
    mc(17)[In a Venn diagram, the region representing $A union B$ is shaded by][shading both circles completely][shading only the overlapping region][shading only one circle][shading the region outside both circles],
    mc(18)[If $X = \{2, 4, 6, 8\}$ and $Y = \{1, 4, 9\}$, then $n(X) + n(Y) =$][7][8][9][16],
    mc(19)[If $n(A) = 5$, then the number of elements in the *power set* of $A$ is][10][25][32][16],
    mc(20)[For any set $A$, the complement of its complement, $(A')'$, is][$A$][$A'$][$emptyset$][$U$],
  )

  #v(2pt)
  #sec("B — Short Answer · 2 marks each")
  #pairgrid(
    sa(21, lines: 2)[List *all* subsets of the set $\{a, b, c\}$.],
    sa(22)[Write $\{x | x in NN and 4 < x < 9\}$ using the complete listing (roster) method.],
    sa(23)[Give the set-builder form of $D = \{4, 8, 12, 16, dots\}$.],
    sa(24)[$A = \{0, 2, 4, 6\}$ and $B = \{1, 2, 3, 5, 6\}$. Find (i) $A inter B$ and (ii) $A triangle.b B$.],
  )

  #v(2pt)
  #sec("C — Problems · 3 marks each · show working")
  #sa(25, lines: 2)[In a class of 60 students, 35 like football, 25 like basketball and 12 like both. (a) How many like exactly one sport? (b) How many like neither? (c) Sketch the Venn diagram.]
  #sa(26, lines: 2)[$A = \{2, 4, 6, 8, 10\}$, $B = \{1, 2, 3, 4, 5\}$. Find (a) $A union B$, (b) $A inter B$, (c) $A backslash B$, (d) $B backslash A$, (e) verify $n(A union B) = n(A) + n(B) - n(A inter B)$.]
  #sa(27, lines: 2)[Let $U = \{1, 2, 3, dots, 12\}$, $A = \{1, 3, 5, 7, 9\}$, $B = \{2, 3, 5, 7, 11\}$. Write down and shade: (a) $A'$, (b) $A inter B$, (c) $A union B$, (d) $(A union B)'$.]
]