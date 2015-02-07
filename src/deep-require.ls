'use strict'

require! {
    'fs'
    'path'
}

const NODE_PATH = process.env.NODE_PATH

const DEFAULTS = {
    extensions: <[ js json ls coffee ]>
    recursive: false
    camelize: true
    excludeDirs: /^\.(git|svn)$/
    filter: null
    map: null
    parse: null
}

isFunction = -> typeof it is 'function'

# mixin :: object -> object -> object
mixin = (dest, ...sources) ->
    for src in sources => for key, value of src
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
module.exports = :deepRequire (cwd, opts, str) -->

    # match NODE_PATH
    if (not /^[\.]{1,2}\//.test str) and (fs.existsSync NODE_PATH)
        cwd := NODE_PATH

    # mix user-options on top of defaults
    options = mixin {}, DEFAULTS, opts

    # parse input and return modules
    # parseDir :: string -> object
    str |> function walk directory
        result = {}

        fs.readdirSync (path.join cwd, directory) .forEach (itemName) !->
            fileExt     = itemName.match /\.(.*)$/i or []
            filePath    = path.join directory, itemName
            fileAbsPath = path.join cwd, filePath
            fileParent  = path.basename directory
            fileStats   = fs.statSync fileAbsPath
            exportName  = itemName.replace fileExt.0, ''

            # parse export-name of files and directories
            if options.camelize
                exportName := (camelize exportName)

            # handle directories
            if fileStats.isDirectory!
            and options.recursive

                # filter sub-directories
                if filter options.excludeDirs, itemName
                    return

                # recursive call on sub-directory
                subDir = walk filePath

                # only add sub-directory if it is not empty
                if Object.keys subDir .length > 0

                    # flatten results?
                    if options.recursive is 'flat'
                        mixin result, subDir
                    else
                        result[exportName] = subDir

            # handle files
            else if fileStats.isFile!
            and (options.extensions.indexOf fileExt.1) isnt -1

                # filter files
                unless filter options.filter, itemName
                    return

                # map files
                if typeof options.map is 'function'
                    exportName := (options.map exportName, directory)

                # parse files
                if typeof options.parse is 'function'
                    result[exportName] = options.parse fileAbsPath
                else
                    result[exportName] = require fileAbsPath
        result
