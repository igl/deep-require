'use strict'

require! {
    fs
    path
}

# default options
defaults = {
    extensions: <[ js json ls coffee ]>
    recursive: false
    camelize: true
    filter: null
    map: null
}

# camelize :: string -> string
camelize = (str) ->
    str.replace /[-_]+(.)?/g, (, c) -> (c ? '').to-upper-case!

filter = (method, name) ->
    switch (Object.prototype.toString.call method .slice 8, -1)
    | 'Function' then method name
    | 'RegExp'   then method.test name
    | _          then true

# deepRequire :: object -> string -> object
deepRequire = module.exports = (cwd, opts, root) -->
    # mix defaults with user-options
    options = {}
    for k, v of defaults => options[k] = v
    for k, v of opts     => options[k] = v

    # parseDir :: string -> object
    parseDir = (dir) ->
        modules = {}

        absDir = path.join cwd, dir

        fs.readdirSync absDir .forEach (name) ->
            ext     = (name.match /\.(.*)$/i or [])
            relPath = path.join dir, name
            absPath = path.join cwd, relPath
            stat    = fs.statSync absPath

            name := name.replace ext.0, ''
            name := (camelize name) if options.camelize
            name := (options.map name) if options.map

            if stat.isDirectory!
            and options.recursive
                modules[name] = (parseDir relPath)

            else if stat.isFile!
            and (options.extensions.indexOf ext.1) isnt -1
                return unless (filter options.filter, name)
                modules[name] = require absPath
        modules

    parseDir root
