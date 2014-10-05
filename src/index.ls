'use strict'

# delete require-cache so it can be required from multible locations
delete require.cache[__filename];

require! {
    path
    './deep-require'
}

deepRequire = deepRequire (path.dirname module.parent.filename)

module.exports = (x, y) ->
    # switch args to support currying and single arg calls
    if (typeof x is 'string') and (typeof y is 'object')
        deepRequire y, x

    else if (typeof x is 'object') and (typeof y is 'string')
        deepRequire x, y

    else if (typeof x is 'string')
        deepRequire {}, x

    else if (typeof x is 'object')
        deepRequire x

