'use strict'

# delete require-cache so it can be required from multible locations
delete require.cache[__filename]

require! {
    path
    './deep-require'
}

deepRequire = deepRequire (path.dirname module.parent.filename)

module.exports = (x, y?) ->
    match (typeof! x), (typeof! y)
    | 'String', 'Object'    => deepRequire y, x
    | 'Object', 'String'    => deepRequire x, y
    | 'String', 'Undefined' => deepRequire {}, x
    | 'Object', 'Undefined' => deepRequire x
    | _                     => throw new Error 'Invalid arguments'
