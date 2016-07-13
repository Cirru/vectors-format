
# # demo of parse result
# contextSchema =
#   ok: yes
#   data: 'x'
#   rest: 'yz'

parseAnyChar = (text) ->
  if text.length > 0
  then ok: yes, data: text[0], rest: text[1..]
  else ok: no, data: 'char got EOF', rest: text

parseBackslash = (text) ->
  anyChar = parseAnyChar text
  if anyChar.ok
    if anyChar.data is '\\' then anyChar
    else ok: no, data: 'chat not \\', rest: text
  else anyChar

parseDoubleQuote = (text) ->
  anyChar = parseAnyChar text
  if anyChar.ok
    if anyChar.data is '"' then anyChar
    else ok: no, data: 'char not double quote', rest: text
  else anyChar

parseSpace = (text) ->
  anyChar = parseAnyChar text
  if anyChar.ok
    if anyChar.data is ' ' then anyChar
    else ok: no, data: 'char not double quote', rest: text
  else anyChar

parseNewline = (text) ->
  anyChar = parseAnyChar text
  if anyChar.ok
    if anyChar.data is '\n' then anyChar
    else ok: no, data: 'char not newline', rest: text
  else anyChar

parseSquareBrakcetLeft = (text) ->
  anyChar = parseAnyChar text
  if anyChar.ok
    if anyChar.data is '[' then anyChar
    else ok: no, data: 'char not [', rest: text
  else anyChar

parseSquareBrakcetRight = (text) ->
  anyChar = parseAnyChar text
  if anyChar.ok
    if anyChar.data is ']' then anyChar
    else ok: no, data: 'char not ]', rest: text
  else anyChar

parseCharInString = (text) ->
  anyChar = parseAnyChar text
  if anyChar.ok
    if anyChar.data in ['"', '\\']
    then ok: no, data: 'char is special', rest: text
    else anyChar
  else anyChar

parseEof = (text) ->
  if text = ''
    ok: yes, data: null, rest: ''
  else ok: no, data: 'not EOF', rest: text

parseEscape = (text) ->
  backslash = parseBackslash text
  if backslash.ok
    anyChar = parseAnyChar backslash.rest
    if anyChar.ok
      if anyChar.data is 'n'
        ok: yes, data: '\n', rest: anyChar.rest
      else if anyChar.data is 't'
        ok: yes, data: '\t', rest: anyChar.rest
      else if anyChar.data is '\\'
        ok: yes, data: '\\', rest: anyChar.rest
      else if anyChar.data is '"'
        ok: yes, data: '"', rest: anyChar.rest
      else ok: yes, data: anyChar.data, rest: anyChar.rest
    else ok:no, data: anyChar.data, rest: text
  else ok: no, data: backslash.data, rest: text

parseStringInside = (text) ->
  tryChar = parseCharInString text
  if tryChar.ok
    tryInside = parseStringInside tryChar.rest
    if tryInside.ok
      ok: yes, data: "#{tryChar.data}#{tryInside.data}", rest: tryInside.rest
    else ok: yes, data: tryChar.data, rest: tryChar.rest
  else
    tryEscape = parseEscape text
    if tryEscape.ok
      tryInside = parseStringInside tryChar.rest
      if tryInside.ok
        ok: yes, data: "#{tryEscape.data}#{tryInside.data}", rest: tryInside.rest
      else ok: yes, data: tryEscape.data, rest: tryEscape.rest
    else ok: yes, data: '', rest: text

parseString = (text) ->
  quote1 = parseDoubleQuote text
  if quote1.ok
    inside = parseStringInside quote1.rest
    if inside.ok
      quote2 = parseDoubleQuote inside.rest
      if quote2.ok
        ok: yes, data: inside.data, rest: quote2.rest
      else ok: no, data: 'no close quote', rest: text
    else ok: no, data: 'failed to parse string inside', rest: text
  else ok: no, data: 'no open quote', rest: text

parseVectorInside = (text) ->
  trySpace = parseSpace text
  if trySpace.ok
    parseVectorInside trySpace.rest
  else
    tryNewline = parseNewline text
    if tryNewline.ok
      parseVectorInside tryNewline.rest
    else
      tryString = parseString text
      if tryString.ok
        tryInside = parseVectorInside tryString.rest
        if tryInside.ok
          ok: yes, data: ([tryString.data].concat tryInside.data), rest: tryInside.rest
        else ok: yes, data: [tryString.data], rest: tryString.rest
      else
        tryVector = parseVector text
        if tryVector.ok
          tryInside = parseVectorInside tryVector.rest
          if tryInside.ok
            ok: yes, data: ([tryVector.data].concat tryInside.data), rest: tryInside.rest
          else ok: yes, data: [tryVector.data], rest: tryVector.rest
        else ok: yes, data: [], rest: text

parseVector = (text) ->
  bracketLeft = parseSquareBrakcetLeft text
  if bracketLeft.ok
    inside = parseVectorInside bracketLeft.rest
    if inside.ok
      bracketRight = parseSquareBrakcetRight inside.rest
      if bracketRight.ok
        ok: yes, data: inside.data, rest: bracketRight.rest
      else ok: no, data: 'no right bracket', rest: text
    else ok: no, data: 'failed to parse vector inside', rest: text
  else ok: no, data: 'no left bracket', rest: text

parseFileEnd = (text) ->
  if text is ''
    ok: yes, data: '', rest: ''
  else if text.match(/\s+/)?
    ok: yes, data: '', rest: ''
  else ok: no, data: 'there is something before file end', rest: text

parseProgram = (text) ->
  trySpace = parseSpace text
  if trySpace.ok
    parseProgram trySpace.rest
  else
    tryNewline = parseNewline text
    if tryNewline.ok
      parseProgram tryNewline.rest
    else
      tryVector = parseVector text
      if tryVector.ok
        tryEnd = parseFileEnd tryVector.rest
        if tryEnd.ok
        then tryVector
        else ok: no, data: 'file end not found', rest: tryVector.rest
      else ok: no, data: 'vector not found', rest: text
