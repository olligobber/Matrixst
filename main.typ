#set page(width: auto, height:auto)
#set math.mat(delim:"[")

#import "matrix.typ": *

#let show_multiply(m, n) = $ #show_matrix(m) #show_matrix(n) = #show_matrix(multiply_matrix(m,n)) $

//demonstration of transpose 

#let a = (
  (1,2,3),
  (4,5,6)
)

$ #show_matrix(a)^top = #show_matrix(transpose_matrix(a)) $

#pagebreak()

// demonstration of minor

#let a = (
  (1,2,3),
  (4,5,6),
  (7,8,9)
)

If $a = #show_matrix(a)$ then the minor at $(3,1)$ is $#show_matrix(minor(a,3,1))$, the minor at $(2,2)$ is $#show_matrix(minor(a,2,2))$, and the minor at $(1,3)$ is $#show_matrix(minor(a,1,3))$.

#pagebreak()

// demonstration of determinant 

#let a = (
  (1,2,3),
  (0,2,-1),
  (-1,3,-1)
)

$ "det"(#show_matrix(a)) = #determinant(a) $

#pagebreak()

// demonstartion of inverses

#let a = (
  (1,2,0),
  (0,2,3),
  (1,3,1)
)
#let a-inverse = invert(a)

$ #show_matrix(a)^(-1) = #show_matrix(a-inverse) $

#show_multiply(a,a-inverse)
#show_multiply(a-inverse,a)

#pagebreak()

= This Matrix Has Interesting Powers

// demonstration showing a^3 = i, a^4 = a

#let a = (
  (1,0,0),
  (0,0,1),
  (0,-1,-1),
)

#{
  for i in range(2,5) {
    $ #show_matrix(a)^#i = #show_matrix(power_matrix(a,i)) $
  }
}

#pagebreak()

= Matrices Act On Column Vectors

// demonstration showing a e_i is the ith column of a

#let b = (
  (1,2,3),
  (4,5,6),
  (7,8,9),
)

#{
  for i in range(1,4) {
    show_multiply(b, column_basis(3,i))
  }
}

#pagebreak()

= Matrices Act On Row Vectors

// demonstration showing e_i^T a is the ith row of a 

#{
  for i in range(1,4) {
    show_multiply(row_basis(3,i), b)
  }
}

#pagebreak()

= Matrices Don't Commute

// demonstration of two matrices that don't commute

#let c = (
  (1,1),
  (0,0),
)
#let d = (
  (1,0),
  (1,0),
)

#show_multiply(c,d)
#show_multiply(d,c)

#pagebreak()

= Invertible Matrices Don't Commute

#let a = (
  (1,1),
  (1,0)
)

#let a-inverse = (
  (0,1),
  (1,-1)
)

#let b = (
  (0,1),
  (1,1)
)

#let b-inverse = (
  (-1,1),
  (1,0)
)

#show_multiply(a,a-inverse)
#show_multiply(b,b-inverse)
#show_multiply(a,b)
#show_multiply(b,a)

#pagebreak()

#let show_multiply_3(m,n,o) = $ #show_matrix(m) #show_matrix(n) #show_matrix(o) = #show_matrix(multiply_matrix(m,multiply_matrix(n,o))) $

#let e = (
  (3,0),
  (-1,5)
)

#let f = (
  (4,-2,1),
  (0,2,3)
)

#let g = (
  (1,2),
  (3,4),
  (5,6)
)

#show_multiply_3(e,f,g)

#pagebreak()

#let h = (
  (5, -3),
  (7,-4)
)

#let i = (
  (-4, 3),
  (-7, 5)
)

#show_multiply(h,i)

#show_multiply(i,h)