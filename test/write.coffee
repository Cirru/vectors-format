
{write} = require '../src/writer'

testWriter = ->
  data = [["a", "b", "c d"],["e", ["f", ["g"], "h"]], ["i"]]
  result = write data
  expected = '\n[\n["a" "b" "c d"]\n["e" ["f" ["g"] "h"]]\n["i"]\n]\n'
  console.log (result is expected)

do testWriter
