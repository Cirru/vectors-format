
writeVector = (x) ->
  if (typeof x) is 'string'
    JSON.stringify x
  else
    items = x.map writeVector
    "[#{items.join(' ')}]"

exports.write = (vector) ->
  lines = vector.map writeVector
  "\n[\n#{lines.join('\n')}\n]\n"
