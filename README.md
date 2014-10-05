deep-require
------------

Small require helper for node.js.

Works with transpiler runners which use `require-extensions`. (add your favorite one to options.extensions)


Usage:

    var getModels = require('deep-require')({
        camelize:true,
        filter: function (name) { return /model\.js$/.test(name); }
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
