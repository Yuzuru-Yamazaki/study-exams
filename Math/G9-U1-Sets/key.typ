#import "../../practice-paper.typ": *

#paper(id: "G9 MATH · SETS · PAPER 01 · ANSWER KEY")[
  #sec("A — Multiple Choice")
  #table(
    columns: 6,
    stroke: 0.35pt + luma(170),
    align: (right, center, center, center, center, center),
    inset: 2pt,
    table.header[*Q*][*Ans*][*Q*][*Ans*][*Q*][*Ans*],
    [1], [b], [2], [c], [3], [b],
    [4], [a], [5], [c], [6], [b],
    [7], [c], [8], [b], [9], [a],
    [10], [a], [11], [c], [12], [c],
    [13], [b], [14], [b], [15], [b],
    [16], [c], [17], [a], [18], [a],
    [19], [c], [20], [a],
  )

  #v(3pt)
  #sec("B — Short Answer")
  #pairgrid(
    block[
      *(21)* All subsets of $\{a, b, c\}$: $∅, \{a\}, \{b\}, \{c\}, \{a,b\}, \{a,c\}, \{b,c\}, \{a,b,c\}$ — 8 in total.
    ],
    block[
      *(22)* $\{5, 6, 7, 8\}$

      *(23)* $D = \{x : x = 4n, n in NN\}$
    ],
    block[
      *(24)* (i) $A inter B = \{2, 6\}$ \
      (ii) $A triangle.b B = (A union B) backslash (A inter B) = \{0,1,2,3,4,5,6\} backslash \{2,6\} = \{0,1,3,4,5\}$
    ],
    block[
      *(19)* Power set has $2^n = 2^5 = 32$ elements.

      *(20)* Complement of complement returns the set: $(A')' = A$
    ],
  )

  #v(2pt)
  #sec("C — Problems")
  #block[
    *(25)* $n(F union B) = 35 + 25 - 12 = 48$. (a) Exactly one = $35 + 25 - 24 = 36$. (b) Neither = $60 - 48 = 12$. (c) Venn: football-only 23, both 12, basketball-only 13, outside 12.
  ]
  #block[
    *(26)* (a) $A union B = \{1,2,3,4,5,6,8,10\}$ (b) $A inter B = \{2,4\}$ (c) $A backslash B = \{6,8,10\}$
    (d) $B backslash A = \{1,3,5\}$ (e) $n(A)=5, n(B)=5$, so $n(A union B)=5+5-2=8$ ✓.
  ]
  #block[
    *(27)* $U = \{1,...,12\}$, $A = \{1,3,5,7,9\}$, $B = \{2,3,5,7,11\}$. \
    (a) $A' = \{2,4,6,8,10,11,12\}$ \
    (b) $A inter B = \{3,5,7\}$ \
    (c) $A union B = \{1,2,3,5,7,9,11\}$ \
    (d) $(A union B)' = \{4,6,8,10,12\}$
  ]
]