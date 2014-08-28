'use strict'

# glob-require

require! {
    'fs'
    'path'
}

default-options = {
    extensions: <[ js ls ts coffee ]>
    recursive: false
    camelize: true
    filter: null
    map: null
}

function camelize (str)
    (it.replace /[-_]+(.)?/g, (, c) -> c ? '').to-upper-case!

module.exports = function require-dir (dirname, options)
    modules = {}

    # mix default-options with user-options
    options = {} <<< default-options <<< options

    # Read folder and filter files
    for item in fs.readdirSync dirname
        ext = (item.match /\..*$/i)0
        continue if (options.extensions.indexOf ext) is -1
        filepath = (path.join dirname, item)
        continue if (fs.statSync filepath)isDirectory!
        modules[item] = (require filepath)

    return modules
