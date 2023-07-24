function cellCount (row) {
  return Array.prototype.slice.call(row.querySelectorAll('th, td')).
    reduce(function (cells, cell) {
      try {
        return cells + cell.attributes.colspan.value
      } finally {
        return cells + 1
      }
    }, 0)
}

Array.prototype.slice.call(document.querySelectorAll('.army_table:not(:has(.army_table))'))
  .forEach(function (armyTable) {
    var
      rows = Array.prototype.slice.call(armyTable.querySelectorAll('tbody > tr')),
      columns = rows
        .reduce(function (columns, row) {
          return Math.max(columns, cellCount(row))
        }, 0),
      stripe = false

    rows.forEach(function (row) {
      var
        cells = cellCount(row)
        classes = row.className.split(/\s+/)

      if (cells === columns) stripe = !stripe

      if (stripe) classes.push('_striped')

      row.className = classes.join(' ')
    })
  })
