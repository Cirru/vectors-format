
parser = require '../src/parser'

testParseStringSimple = ->
  data = '"a"'
  result = parser.parseString data
  expected = ok: yes, data: 'a', rest: ''
  console.log 'result:  ', result
  console.log 'expected:', expected

testParseVectorSimple = ->
  data = '["a" "b"]'
  result = parser.parseVector data
  expected = ok: yes, data: ['a', 'b'], rest: ''
  console.log 'result:  ', result
  console.log 'expected:', expected

testParseVectorNested = ->
  data = '["a" ["b"]]'
  result = parser.parseVector data
  expected = ok: yes, data: ['a', ['b']], rest: ''
  console.log 'result:  ', result
  console.log 'expected:', expected

testParseFileEmpty = ->
  file = '\n[]\n'
  result = parser.parseProgram file
  expected = ok: yes, data: [], rest: ''
  console.log 'result:  ', result
  console.log 'expected:', expected

testParseFileNested = ->
  file = '\n[["a" ["b"]] ["c"] ["d"]]\n'
  result = parser.parseProgram file
  expected = ok: yes, data: [['a', ['b']], ['c'], ['d']], rest: ''
  console.log 'result:  ', JSON.stringify(result)
  console.log 'expected:', JSON.stringify(expected)

do testParseStringSimple
do testParseVectorSimple
do testParseVectorNested
do testParseFileEmpty
do testParseFileNested
