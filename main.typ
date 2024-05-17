#set page(width: auto, height:auto)

#import "matrix.typ": *

//demonstration of transpose 

= Matrix Transpose

#let a = (
  (1,2,3),
  (4,5,6)
)

$ #render(a)^top = #render(transpose(a)) $

#pagebreak()

// demonstration of minor

= Matrix Minors

#let a = (
  (1,2,3),
  (4,5,6),
  (7,8,9)
)

If $ a = #render(a) $ then the minor at $(3,1)$ is $ #render(minor(a,3,1)), $ the minor at $(2,2)$ is $ #render(minor(a,2,2)), $ and the minor at $(1,3)$ is $ #render(minor(a,1,3)). $

#pagebreak()

// demonstration of determinant 

= Matrix Determinant

#let a = (
  (1,2,3),
  (0,2,-1),
  (-1,3,-1)
)

$ "det"#render(a) = #determinant(a) $

#pagebreak()

// demonstartion of inverses

= Matrix Inverse

#let a = (
  (1,2,0),
  (0,2,3),
  (1,3,1)
)
#let a-inverse = invert(a)

#show_power(a,-1)
#show_multiply(a,a-inverse)
#show_multiply(a-inverse,a)

#pagebreak()

= This Matrix Has Interesting Powers

// demonstration showing powers of a when a^3 is the identity

#let a = (
  (1,0,0),
  (0,0,1),
  (0,-1,-1),
)

#{
  for i in range(-3,5) {
    show_power(a,i)
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

// demonstration showing matrix multiplication isn't commutative even when the matrices are invertible

#let a = (
  (1,1),
  (1,0)
)

#let b = (
  (0,1),
  (1,1)
)

#show_multiply(a,invert(a))
#show_multiply(b,invert(b))
#show_multiply(a,b)
#show_multiply(b,a)

#pagebreak()

// demonstration showing multiplying more than two matrices of different dimensions

= #[Multiplying Multiple Matrices \
with Many Measurements]

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

#show_multiply(e,f,g)

#pagebreak()

= Building a Matrix out of Column Vectors

#let v1 = column_vector(1,2,3,4)
#let v2 = column_vector(1,-1,2,1)
#let v3 = column_vector(0,0,1,0)
#let v4 = column_vector(-1,0,1,-1)
#let vs = (v1,v2,v3,v4)

#v(1em)

#align(center, 
  range(4)
    .map(i => $bold(v)_#{i+1} = #render(vs.at(i))$)
    .join([,] + h(1em))
)

#let bars = ($|$,) * 4
#let names = range(1,5).map(x => $bold(v)_#x$)

$ #math.mat(..(bars,names,bars)) = #render(horizontal_cat(..vs)) $

#pagebreak()

= Building a Matrix out of Row Vectors

#let v1 = row_vector(1,5,2,-1)
#let v2 = row_vector(1,-1,0,0.5)
#let v3 = row_vector(0,2,1,1)
#let v4 = row_vector(6,0,1,-1)
#let vs = (v1,v2,v3,v4)

#{
  for i in range(4) {
    $ bold(v)_#{i+1} = #render(vs.at(i)) $
  }
}

#let namerows = range(1,5).map(x => ($-$,$bold(v)_#x$,$-$))

$ #math.mat(..namerows) = #render(vertical_cat(..vs)) $