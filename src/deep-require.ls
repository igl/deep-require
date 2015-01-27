'use strict'

require! {
    fs
    path
}

# const
NODE_PATH = process.env.NODE_PATH

# default options
defaults = {
    extensions: <[ js json ls coffee ]>
    recursive: false
    camelize: true
    filter: null
    map: null
}

# mixin :: object -> object -> object
mixin = (dest, ...sources) ->
    for src in sources
        for key, value of src
            dest[key] = value
    dest

# camelize :: string -> string
camelize = (str) ->
    str.replace /[-_]+(.)?/g, (, c) -> (c ? '').to-upper-case!

# filter :: a -> string -> bool
filter = (method, name) ->
    switch (Object.prototype.toString.call method .slice 8, -1)
    | 'Function' then method name
    | 'RegExp'   then method.test name
    | 'String'   then //#method//.test name
    | _          then true

# deepRequire :: object -> string -> object
deepRequire = module.exports = (cwd, opts, str) -->

    # match NODE_PATH
    if (not /^[\.]{1,2}\//.test str) and (fs.existsSync NODE_PATH)
        cwd := NODE_PATH

    # mix defaults with user-options
    options = mixin {}, defaults, opts

    # parse input and return modules
    # parseDir :: string -> object
    str |> function parseDir (dir)
        modules = {}

        absDir = path.join cwd, dir

        fs.readdirSync absDir .forEach (file) ->
            ext     = file.match /\.(.*)$/i or []
            relPath = path.join dir, file
            absPath = path.join cwd, relPath
            stat    = fs.statSync absPath
            name    = file.replace ext.0, ''

            name   := (camelize name) if options.camelize

            if stat.isDirectory!
            and options.recursive
                sub-dir = parseDir relPath
                # only add sub directory if it is not empty
                unless Object.keys sub-dir .length is 0
                    modules[name] = sub-dir

            else if stat.isFile!
            and (options.extensions.indexOf ext.1) isnt -1
                return unless filter options.filter, file
                name := (options.map name) if options.map
                modules[name] = require absPath
        modules
