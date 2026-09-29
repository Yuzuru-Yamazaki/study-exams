#import "../../../practice-mc.typ": *

#paper(id: "G11 MATH · RELATIONS & FUNCTIONS · SET 01")[
  #sec("1.1 Relations")
  #pairgrid(
    mcq(1)[A *relation* from set $A$ to set $B$ is defined as][only a subset of $A$][a subset of $A times B$ (the Cartesian product)][the union of $A$ and $B$][any set containing both $A$ and $B$],
    mcq(2)[If $A = \{2, 4, 6\}$, which ordered pair belongs to the relation $"≤" subset A times A$?][$(6, 4)$][$(4, 6)$][$(6, 2)$][$(4, 2)$],
    mcq(3)[The *domain* of a relation $R$ from $A$ to $B$ is the set of][first elements of the ordered pairs of $R$][second elements of the ordered pairs of $R$][elements in $B$ never used by $R$][all elements of $A times B$],
    mcq(4)[For $R = \{(1, a), (2, b), (3, c)\}$, the range of $R$ is][$\{1, 2, 3\}$][$\{a, b, c\}$][$\{1, a\}$][$\{a, b\}$],
    mcq(5)[$R = \{(x, y) : y = x + 1, x in {1, 2, 3}\}$. The range of $R$ is][$\{2, 3, 4\}$][$\{1, 2, 3\}$][$\{0, 1, 2\}$][$\{1, 2, 3, 4\}$],
    mcq(6)[A relation $R$ is *reflexive* on $A$ if for all $x in A$][$(x, y) in R$ implies $(y, x) in R$][$(x, x) in R$][$(x, x) in.not R$][$(x, y)$ and $(y, z)$ in $R$ imply $(x, z) in R$],
    mcq(7)[A relation $R$ is *symmetric* if][$(x, x) in R$ for all $x$][$(x, y) in R$ implies $(y, x) in R$][$(x, y), (y, z) in R$ imply $(x, z) in R$][$R = emptyset$],
    mcq(8)[An *equivalence relation* is one that is][reflexive and symmetric only][reflexive, symmetric and transitive][reflexive and transitive only][symmetric and transitive only],
  )

  #sec("1.2 & 1.3 Functions, Domain and Range")
  #pairgrid(
    mcq(9)[A *function* $f : A arrow B$ is a relation in which][every element of $A$ has one image in $B$][some elements of $A$ have two images][every element of $B$ is an image][$A = B$],
    mcq(10)[Which of the following relations $R$ from $A$ to $B$ is a function?][$\{(1,a),(1,b),(2,c)\}$][$\{(1,a),(2,b),(3,c)\}$][$\{(1,a),(2,a),(2,b)\}$][$\{(1,a),(1,b),(1,c)\}$],
    mcq(11)[The domain of $f(x) = sqrt(x-2)$ is][$\{x : x >= 2\}$][$\{x : x > 2\}$][$RR$][$\{x : x <= 2\}$],
    mcq(12)[The range of $f(x) = x^2$ is][$RR$][$\{y : y >= 0\}$][$\{y : y > 0\}$][$\{y : y <= 0\}$],
    mcq(13)[The domain of $f(x) = 1/(x-3)$ is][$RR$][$\{x : x != 3\}$][$\{x : x > 3\}$][$\{x : x < 3\}$],
    mcq(14)[If $f(x) = 3x - 2$, then $f(4) =$][12][10][14][6],
    mcq(15)[If $f(x) = x^2 + 1$, then $f(-3) =$][$-8$][$-10$][$10$][$7$],
    mcq(16)[The range of $f(x) = 2x + 1$ over domain ${1, 2, 3}$ is][$\{3, 5, 7\}$][$\{1, 2, 3\}$][$\{0, 2, 4\}$][$\{2, 4, 6\}$],
    mcq(17)[If $f(x) = 4x - 3$ and $g(x) = 2x + 5$, then $(f + g)(x) =$][$6x + 2$][$6x - 2$][$2x - 8$][$6x + 8$],
    mcq(18)[With $f(x) = 4x - 3$ and $g(x) = 2x + 5$, $(f - g)(x) =$][$2x - 8$][$6x + 2$][$2x + 8$][$8x + 2$],
    mcq(19)[With $f$ and $g$ as above, $(f g)(x) =$][$8x^2 + 14x - 15$][$8x^2 - 14x + 15$][$8x^2 + 26x - 15$][$6x^2 + 2x$],
    mcq(20)[$(f ∘ g)(x)$ means][$g(f(x))$][$f(g(x))$][$f(x) dot g(x)$][$f(x) + g(x)$],
    mcq(21)[If $f(x) = 2x$ and $g(x) = x + 3$, then $(f ∘ g)(x) =$][$2x + 6$][$2x + 3$][$(x + 3)(2x)$][$2(x^2) + 3$],
    mcq(22)[If $f(x) = 2x$ and $g(x) = x + 3$, then $(g ∘ f)(x) =$][$2x + 6$][$2x + 3$][$2x^2 + 6$][$2 + 3x$],
  )


  #sec("1.4 Types of Functions")
  #pairgrid(
    mcq(23)[A function $f : A arrow B$ is *one-to-one* (injective) if][$f(a_1) = f(a_2)$ implies $a_1 = a_2$][every element of $B$ is an image][$f$ is constant][both $A$ and $B$ are finite],
    mcq(24)[A function $f : A arrow B$ is *onto* (surjective) if][$f$ is one-to-one][every element of $B$ is the image of some element of $A$][no two elements share an image][$f$ is injective and injective only],
    mcq(25)[A function that is both one-to-one and onto is called][a constant function][an identity function][a bijection][a partial function],
    mcq(26)[Which of the following is a constant function?][$f(x) = x$][$f(x) = 5$][$f(x) = 2x + 1$][$f(x) = x^2$],
    mcq(27)[$f(x) = x^2$ over $RR$ is an example of a function that is][one-to-one and onto][one-to-one only][onto only][neither one-to-one nor onto],
    mcq(28)[$f(x) = 2x + 3$ over $RR$ is a function that is][one-to-one and onto][one-to-one but not onto][onto but not one-to-one][neither],
    mcq(29)[An *identity function* is defined by][$f(x) = 0$][$f(x) = x$][$f(x) = 1$][$f(x) = x^2$],
  )

  #sec("1.5 Inverse of a Function")
  #pairgrid(
    mcq(30)[The inverse of $f(x) = 2x + 6$ is][$f^(-1)(x) = (x - 6)/2$][$f^(-1)(x) = (x + 6)/2$][$f^(-1)(x) = 2x - 6$][$f^(-1)(x) = -2x - 6$],
    mcq(31)[The inverse of $f(x) = x/3 - 4$ is][$f^(-1)(x) = 3x + 12$][$f^(-1)(x) = 3x - 12$][$f^(-1)(x) = (x + 4)/3$][$f^(-1)(x) = x/3 + 4$],
    mcq(32)[A function $f$ has an inverse if and only if $f$ is][onto][one-to-one (bijective for $f: A arrow A$ of finite sets)][constant][even],
    mcq(33)[If $f(3) = 7$, then $f^(-1)(7) =$][$7$][$3$][$-3$][$21$],
    mcq(34)[The graphs of $y = f(x)$ and $y = f^(-1)(x)$ are symmetric about the line][$y = 0$][$x = 0$][$y = x$][$y = -x$],
    mcq(35)[If $f(x) = 3x - 9$ and $f^(-1)(x) = (x + 9)/3$, then $(f ∘ f^(-1))(5) =$][$0$][$5$][$15$][$24$],
    mcq(36)[The inverse of $f(x) = x^3$ is][$f^(-1)(x) = root(3, x)$][$f^(-1)(x) = x^(1/2)$][$f^(-1)(x) = 1/x^3$][$f^(-1)(x) = x^2$],
  )

  #sec("1.6 Absolute Value, Signum and Piecewise Functions")
  #pairgrid(
    mcq(37)[The signum function $"sgn"(x) = x/abs(x)$ for $x != 0$. Then $"sgn"(-7) =$][$0$][$1$][$-1$][$7$],
    mcq(38)[If $f(x) = abs(x)$, then $f(-4) =$][$4$][$-4$][$16$][$0$],
    mcq(39)[Let $f(x) = cases(x + 1 "if" x < 2, 3 "if" x >= 2)$. Then $f(1) =$][$3$][$1$][$4$][$2$],
    mcq(40)[For the same piecewise function $f$ as above, $f(5) =$][$3$][$6$][$5$][$2$],
    mcq(41)[The signum function $"sgn"(x)$ takes the value $0$ exactly when][$x > 0$][$x < 0$][$x = 0$][$x$ is any real number],
  )

  #sec("1.7 Even and Odd Functions")
  #pairgrid(
    mcq(42)[Which of the following is an *even* function over $RR$?][$f(x) = x^3$][$f(x) = x^4$][$f(x) = 2x$][$f(x) = x + 1$],
    mcq(43)[Which of the following is an *odd* function over $RR$?][$f(x) = x^2 - 1$][$f(x) = abs(x)$][$f(x) = x^3$][$f(x) = x^2$],
  )

  #sec("1.8 Composition of Functions")
  #pairgrid(
    mcq(44)[If $f(x) = x + 1$ and $g(x) = 2x$, then $(f ∘ g)(3) =$][$6$][$7$][$8$][$9$],
    mcq(45)[If $f(x) = x^2$ and $g(x) = x - 1$, then $(g ∘ f)(2) =$][$3$][$5$][$9$][$-3$],
    mcq(46)[If $f$ and $g$ are inverse functions, then $(f ∘ g)(x) =$][$0$][$x$][$f(x)$][$1$],
    mcq(47)[If $f(x) = 3x$ and $g(x) = x/3$, then $(g ∘ f)(x) =$][$x/9$][$9x$][$x$][$x^2$],
  )

  #sec("1.9 Domain, Range and the Line Tests")
  #pairgrid(
    mcq(48)[The domain of $f(x) = sqrt(x^2 - 9)$ is][$\{x : -3 <= x <= 3\}$][$\{x : x <= -3 "or" x >= 3\}$][$\{x : x >= 3\}$][$\{x : x <= -3\}$],
    mcq(49)[The range of $f(x) = 1/x$ for $x != 0$ is][$\{y : y != 0\}$][$\{y : y > 0\}$][$\{y : y >= 0\}$][$\{y : y < 0\}$],
    mcq(50)[The vertical line test is used to decide whether a relation is][one-to-one][onto][a function][invertible],
    mcq(51)[A graph that meets every horizontal line in at most one point is the graph of a function that is][one-to-one][onto][constant][even],
  )

  #sec("1.10 More on Inverse Functions")
  #pairgrid(
    mcq(52)[The inverse of $f(x) = 5 - 3x$ is][$f^(-1)(x) = (5 + x)/3$][$f^(-1)(x) = (5 - x)/3$][$f^(-1)(x) = (x - 5)/3$][$f^(-1)(x) = 3x - 5$],
    mcq(53)[The inverse of $f(x) = 1/x$ for $x != 0$ is][$x$][$-1/x$][$x^2$][$1/x$ (that is, $f$ is its own inverse)],
    mcq(54)[For $f(x) = x^2$ with domain $\{x : x >= 0\}$, the inverse is][$f^(-1)(x) = sqrt(x)$][$f^(-1)(x) = -sqrt(x)$][$f^(-1)(x) = x^2$][$f^(-1)(x) = 1/x$],
    mcq(55)[If $f(x) = 2x + 5$, then $f^(-1)(5) =$][$5$][$2$][$0$][$15$],
    mcq(56)[The graphs of $y = f(x)$ and $y = f^(-1)(x)$ are reflections of each other across the line][$y = x$][the $x$-axis][the $y$-axis][the origin],
    mcq(57)[If $f$ has an inverse, then $(f ∘ f^(-1))(4) =$][$2$][$4$][$16$][$0$],
    mcq(58)[Which function has the same graph as its own inverse?][$f(x) = 2x$][$f(x) = 1/x$][$f(x) = x^2$][$f(x) = x + 1$],
    mcq(59)[If $f(x) = x^2 - 4$, then $f(3) =$][$5$][$9$][$13$][$12$],
    mcq(60)[An equivalence relation is reflexive, symmetric and][antisymmetric][transitive][surjective][complete],
  )
]