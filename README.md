deep-require
------------

Small require helper for node.js.

Works with transpiler runners which use `require-extensions`. (add your favorite one to options.extensions)


Usage:

    var getModels = require('deep-require')({
        camelize:true,
        filter: /model\.js$/,
        map: function (name) { return name[0].toUpperCase() + name.slice(1); }
    });

    getModels('./models')


Default Options:

    {
        extensions: <[ js json ls coffee ]>     - Array
        recursive: false                        - Bool
        camelize: true                          - Bool
        filter: null                            - RegExp | Function
        map: null                               - Function
    }
