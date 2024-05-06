// verifies a matrix is valid and returns (height, width) 
#let matrix_dim(m) = {
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
  let numcols = m.at(0).len()
  // verify all rows are same length
  for row in m {
    if row.len() != numcols {
      panic("matrix is not valid: rows are different lengths")
    }
  }
  return (numrows, numcols)
}

// show a matrix in a math environment
#let show_matrix(m) = {
  // check input is valid
  let _ = matrix_dim(m)
  return math.mat(..m)
}

// multiply two matrices in the given order
#let multiply_matrix(m, n) = {
  // check input is valid and get dimensions
  let (firstrows, firstcols) = matrix_dim(m)
  let (secondrows, secondcols) = matrix_dim(n)
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
  if (resultrows, resultcols) != matrix_dim(result) {
    panic("error when multiplying matrices, result has wrong size")
  }
  return result
}

// get the identity matrix of a given size 
#let identity_matrix(n) = {
  if (int(n) != n) {
    panic("error when generating identity matrix, size must be an integer")
  }
  if (n < 1) {
    panic("error when generating identity matrix, size must be positive")
  }
  result = ()
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
  if (n,n) != matrix_dim(result) {
    panic("error when generating identity matrix, result has wrong size")
  }
  return result
}

// raise a matrix to a given power
#let power_matrix(m, k) = {
  if int(k) != k {
    panic("power must be integer")
  }
  if k < 0 {
    panic("power must be non-negative")
  }
  let (rows,cols) = matrix_dim(m)
  if rows != cols {
    panic("cannot raise matrix to power if it is not square")
  }
  let n = rows 
  if k == 0 {
    return identity_matrix(n)
  }
  if k == 1 {
    return m 
  }
  if int(k / 2) * 2 == k {
    let x = power_matrix(m, k/2)
    return multiply_matrix(x, x)
  } else {
    let x = power_matrix(m, k - 1)
    return multiply_matrix(x, m)
  }
}

// Get a column vector of length n with its ith component set to 1 and the rest 0
#let column_basis(n, i) = {
  if (int(n) != n) {
    panic("error when generating column basis, size is not an integer")
  }
  if (n < 1) {
    panic("error when generating column basis, size must be positive")
  }
  if (int(i) != i) {
    panic("error when generating column basis, index is not an integer")
  }
  if (i < 1 or i > n) {
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
  if (n,1) != matrix_dim(result) {
    panic("error when generating column basis, result has wrong size")
  }
  return result
}

// Get a row vector of length n with its ith component set to 1 and the rest 0
#let row_basis(n, i) = {
  if (int(n) != n) {
    panic("error when generating row basis, size is not an integer")
  }
  if (n < 1) {
    panic("error when generating row basis, size must be positive")
  }
  if (int(i) != i) {
    panic("error when generating row basis, index is not an integer")
  }
  if (i < 1 or i > n) {
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
  if (1,n) != matrix_dim(result) {
    panic("error when generating row basis, result has wrong size")
  }
  return result
}

// Tranpose a matrix 
#let transpose_matrix(m) = {
  let (in_rows, in_cols) = matrix_dim(m)
  let out_rows = in_cols 
  let out_cols = in_rows 
  let result = ()
  for i in range(out_rows) {
    result.push(())
    for j in range(out_cols) {
      result.at(-1).push(m.at(j).at(i))
    }
  }
  if (matrix_dim(result) != (out_rows, out_cols)) {
    panic("error when transposing matrix, result has wrong size")
  } 
  return result
}

// Get the minor of a matrix by deleting row i and column j 
#let minor(m, i, j) = {
  let (in_rows, in_cols) = matrix_dim(m) 
  if (int(i) != i) {
    panic("error when getting minor of matrix, row index must be an integer")
  }
  if (int(j) != j) {
    panic("error when getting minor of matrix, column index must be an integer")
  }
  if (i < 1 or i > in_rows) {
    panic("error when getting minor of matrix, row index must be between 1 and height of matrix")
  }
  if (j < 1 or j > in_cols) {
    panic("error when getting minor of matrix, column index must be between 1 and width of matrix")
  }
  if (in_rows == 1 or in_cols == 1) {
    panic("error when getting minor of matrix, matrix must be at least 2x2 to get non-empty minor")
  }
  let out_rows = in_rows - 1
  let out_cols = in_cols - 1
  let result = () 
  for k in range(in_rows) {
    if (k == i - 1) {
      continue
    }
    result.push(())
    for l in range(in_cols) {
      if (l == j - 1) {
        continue
      }
      result.at(-1).push(m.at(k).at(l))
    }
  }
  if (matrix_dim(result) != (out_rows, out_cols)) {
    panic("error when getting minor of matrix, result has wrong size")
  }
  return result
}

// Get the determinant of a matrix 
#let determinant(m) = {
  let (rows,cols) = matrix_dim(m)
  if (rows != cols) {
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
  let (rows, cols) = matrix_dim(m)
  if (rows != cols) {
    panic("error inverting matrix: matrix is not square")
  }
  let n = rows 
  let det = determinant(m)
  if det == 0 {
    panic("error inverting matrix: matrix with zero determinant has no inverse")
  }
  let mt = transpose_matrix(m)
  let result = ()
  for i in range(n) {
    result.push(())
    for j in range(n) {
      result.at(-1).push(calc.pow(-1, i+j) * determinant(minor(mt, i+1, j+1)) / det)
    }
  }
  if matrix_dim(result) != (n,n) {
    panic("error inverting matrix: result is wrong size")
  }
  return result
}