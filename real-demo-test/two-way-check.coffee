
fs = require 'fs'
vf = require '../src/index'

sourceCode = fs.readFileSync './source.json', 'utf8'
jsonData = JSON.parse(sourceCode)
formatted = vf.write jsonData
fs.writeFile './formatted.edn', formatted

generated = JSON.stringify vf.parse(formatted).data
console.log 'equals?', (generated is sourceCode)
# console.log 'source:', sourceCode
# console.log 'result:', generated
