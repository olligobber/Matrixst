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

#let show_matrix(m) = {
  // check input is valid
  let _ = matrix_dim(m)
  return math.mat(..m)
}

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

#let identity_matrix(n) = {
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

#let column_basis(n, i) = {
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

#let row_basis(n, i) = {
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