// verifies a matrix is valid and returns (height, width) 
#let dimension(m) = {
  // check input is valid types
  if type(m) != array {
    panic("matrix is not valid: not an array")
  }
  for row in m {
    if type(row) != array {
      panic("matrix is not valid: rows are not arrays")
      for val in row {
        if type(val) != integer and type(val) != float {
          panic("matrix is not valid: values are not numbers")
        }
      }
    }
  }
  // get input dimensions
  let numrows = m.len()
  if numrows == 0 {
    panic("matrix is not valid: must have at least one row")
  }
  let numcols = m.at(0).len()
  // verify all rows are same length
  for row in m {
    if row.len() != numcols {
      panic("matrix is not valid: rows are different lengths")
    }
  }
  if numcols == 0 {
    panic("matrix is not valid: must have at least one column")
  }
  return (numrows, numcols)
}

// show a matrix in a math environment
#let render(m) = {
  // check input is valid
  let _ = dimension(m)
  return math.mat(..m)
}

// multiply one or more matrices in the given order
#let multiply(..ms) = {
  if ms.named() != (:) {
    panic("multiply does not take named arguments")
  }
  let ms = ms.pos()
  if ms.len() < 1 {
    panic("cannot multiply zero matrices: unclear dimensions of result")
  }
  // Deal with more than two inputs by iteration
  if (ms.len() > 2) {
    let result = ms.at(0)
    for i in range(1, ms.len()) {
      result = multiply(result, ms.at(i))
    }
    return result
  }
  // Deal with exactly two inputs by direct computation
  let (m,n) = ms
  // check input is valid and get dimensions
  let (firstrows, firstcols) = dimension(m)
  let (secondrows, secondcols) = dimension(n)
  // check dimensions match
  if firstcols != secondrows {
    panic("cannot multiply matrices: mismatched dimensions")
  }
  // build result
  let resultrows = firstrows
  let resultcols = secondcols 
  let interdim = firstcols
  let result = ()
  for i in range(resultrows) {
    result.push(())
    for j in range(resultcols) {
      let sum = 0
      for k in range(interdim) {
        sum += m.at(i).at(k) * n.at(k).at(j)
      }
      result.at(-1).push(sum)
    }
  }
  if (resultrows, resultcols) != dimension(result) {
    panic("error when multiplying matrices, result has wrong size")
  }
  return result
}

// get the identity matrix of a given size 
#let identity(n) = {
  if int(n) != n {
    panic("error when generating identity matrix, size must be an integer")
  }
  if n < 1 {
    panic("error when generating identity matrix, size must be positive")
  }
  let result = ()
  for i in range(n) {
    result.push(())
    for j in range(n) {
      if i == j {
        result.at(-1).push(1)
      } else {
        result.at(-1).push(0)
      }
    }
  }
  if (n,n) != dimension(result) {
    panic("error when generating identity matrix, result has wrong size")
  }
  return result
}

// Get a column vector of length n with its ith component set to 1 and the rest 0
#let column_basis(n, i) = {
  if int(n) != n {
    panic("error when generating column basis, size is not an integer")
  }
  if n < 1 {
    panic("error when generating column basis, size must be positive")
  }
  if int(i) != i {
    panic("error when generating column basis, index is not an integer")
  }
  if i < 1 or i > n {
    panic("error when generating column basis, index must be between 1 and n")
  }
  let result = () 
  for j in range(1,n+1) {
    if i == j {
      result.push((1,))
    } else {
      result.push((0,))
    }
  }
  if (n,1) != dimension(result) {
    panic("error when generating column basis, result has wrong size")
  }
  return result
}

// Get a row vector of length n with its ith component set to 1 and the rest 0
#let row_basis(n, i) = {
  if int(n) != n {
    panic("error when generating row basis, size is not an integer")
  }
  if n < 1 {
    panic("error when generating row basis, size must be positive")
  }
  if int(i) != i {
    panic("error when generating row basis, index is not an integer")
  }
  if i < 1 or i > n {
    panic("error when generating row basis, index must be between 1 and n")
  }
  let row = ()
  for j in range(1,n+1) {
    if i == j {
      row.push(1)
    } else {
      row.push(0)
    }
  }
  let result = (row,)
  if (1,n) != dimension(result) {
    panic("error when generating row basis, result has wrong size")
  }
  return result
}

// Tranpose a matrix 
#let transpose(m) = {
  let (in_rows, in_cols) = dimension(m)
  let out_rows = in_cols 
  let out_cols = in_rows 
  let result = ()
  for i in range(out_rows) {
    result.push(())
    for j in range(out_cols) {
      result.at(-1).push(m.at(j).at(i))
    }
  }
  if dimension(result) != (out_rows, out_cols) {
    panic("error when transposing matrix, result has wrong size")
  } 
  return result
}

// Get the minor of a matrix by deleting row i and column j 
#let minor(m, i, j) = {
  let (in_rows, in_cols) = dimension(m) 
  if int(i) != i {
    panic("error when getting minor of matrix, row index must be an integer")
  }
  if int(j) != j {
    panic("error when getting minor of matrix, column index must be an integer")
  }
  if i < 1 or i > in_rows {
    panic("error when getting minor of matrix, row index must be between 1 and height of matrix")
  }
  if j < 1 or j > in_cols {
    panic("error when getting minor of matrix, column index must be between 1 and width of matrix")
  }
  if in_rows == 1 or in_cols == 1 {
    panic("error when getting minor of matrix, matrix must be at least 2x2 to get non-empty minor")
  }
  let out_rows = in_rows - 1
  let out_cols = in_cols - 1
  let result = () 
  for k in range(in_rows) {
    if k == i - 1 { continue }
    result.push(())
    for l in range(in_cols) {
      if l == j - 1 { continue }
      result.at(-1).push(m.at(k).at(l))
    }
  }
  if dimension(result) != (out_rows, out_cols) {
    panic("error when getting minor of matrix, result has wrong size")
  }
  return result
}

// Get the determinant of a matrix 
#let determinant(m) = {
  let (rows,cols) = dimension(m)
  if rows != cols {
    panic("error when calculating determinant, matrix must be square")
  }
  let n = rows
  if n == 1 {
    return m.at(0).at(0)
  }
  let det = 0
  for i in range(n) {
    det += calc.pow(-1,i) * m.at(0).at(i) * determinant(minor(m, 1, i + 1))
  }
  return det
}

// Get the inverse of a matrix 
#let invert(m) = {
  let (rows, cols) = dimension(m)
  if rows != cols {
    panic("error inverting matrix: matrix is not square")
  }
  let n = rows 
  let det = determinant(m)
  if det == 0 {
    panic("error inverting matrix: matrix with zero determinant has no inverse")
  }
  let mt = transpose(m)
  let result = ()
  for i in range(1,n+1) {
    result.push(())
    for j in range(1,n+1) {
      result.at(-1).push(calc.pow(-1, i+j) * determinant(minor(mt, i, j)) / det)
    }
  }
  if dimension(result) != (n,n) {
    panic("error inverting matrix: result is wrong size")
  }
  return result
}

// raise a matrix to a given power
#let power(m, k) = {
  if int(k) != k {
    panic("power must be integer")
  }
  if k < 0 {
    return invert(power(m,-k))
  }
  let (rows,cols) = dimension(m)
  if rows != cols {
    panic("cannot raise matrix to power if it is not square")
  }
  let n = rows 
  if k == 0 {
    return identity(n)
  }
  if k == 1 {
    return m 
  }
  if int(k / 2) * 2 == k {
    let x = power(m, k/2)
    return multiply(x, x)
  } else {
    let x = power(m, k - 1)
    return multiply(x, m)
  }
}