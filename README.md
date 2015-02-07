#deep-require

Require all files within a directory.

- Works with transpiler runners which use `require-extensions`. (add your favorite to options.extensions)
- Supports filter, map, parse and recursive with a flat option for sub directories.
- `NODE_PATH` Support.
- Partially applicable.

## Usage:

    var getModels = require('deep-require')({
        camelize:true,
        filter: /model\.js$/,
        map: function (name) { return name[0].toUpperCase() + name.slice(1); }
    });

    getModels('./models')


## Options:

    deepRequire {
        extensions  : [ "js", "json", "ls", "coffee" ],
        camelize    : true,
        recursive   : false,             // Set to 'flat' for a flattened results.
        excludeDirs : /^\.(git|svn)$/,   // Can also be a Function or String
        filter      : /model\.js$/,      // Can also be a Function or String
        map         : function (name, path) { return name[0].toUpperCase() + name.slice(1); },
        parse       : function (resolvedPath) { return new require(resolvePath); }
    }
