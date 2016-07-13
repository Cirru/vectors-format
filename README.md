
Cirru Vectors Format
----

> A subset of [EDN](https://github.com/edn-format/edn) to store Cirru source code.


```edn
[
["a" "b" "c d"]
["e" ["f" ["g"] "h"]]
["i"]
]
```

### Usage

```bash
npm i --save cirru-vectors-format
```

```coffee
{write, parse} = require('cirru-vectors-format')
```

```coffee
file = '\n[["a" ["b"]] ["c"] ["d"]]\n'
result = parser.parseProgram file
expected = ok: yes, data: [['a', ['b']], ['c'], ['d']], rest: ''
```

```coffee
data = [["a", "b", "c d"],["e", ["f", ["g"], "h"]], ["i"]]
result = write data
expected = '\n[\n["a" "b" "c d"]\n["e" ["f" ["g"] "h"]]\n["i"]\n]\n'
```

### Test

```bash
cd test/
coffee write.coffee
coffee parse.coffee
```

```bash
cd real-demo-test
coffee two-way-check.coffee
```
### License

MIT
