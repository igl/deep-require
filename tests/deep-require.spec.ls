'use strict'

suite 'deep-require' !->
    deepRequire = require '../'

    test 'default options require without error' !->
        result = deepRequire '../test-fixtures'
        strictEqual 3, (Object.keys result .length)

    test 'camelizes' !->
        result = deepRequire '../test-fixtures'
        deepEqual result, {
            index: 'index'
            otherFile: 'other-file'
            someFile: 'some-file'
        }

    test 'do not camelize' !->
        result = deepRequire '../test-fixtures' { -camelize }
        deepEqual result, {
            'index': 'index'
            'other-file': 'other-file'
            'some-file': 'some-file'
        }

    test 'require with sub-directories' !->
        result = deepRequire '../test-fixtures' { +recursive }
        deepEqual result, {
            index: 'index'
            otherFile: 'other-file'
            someFile: 'some-file'
            subDir: {
                deepFile: 'deep-file'
            }
        }

    test 'filters extensions' !->
        result = deepRequire '../test-fixtures' { extensions: [ 'ls' ] }
        strictEqual 2, (Object.keys result .length)

    test 'filters filenames' !->
        result = deepRequire '../test-fixtures' { filter: /^index.?/i }
        strictEqual 1, (Object.keys result .length)

    test 'map files and folders' !->
        result = deepRequire '../test-fixtures' { map: -> "XY#it" }
        deepEqual result, {
            XYindex: 'index'
            XYotherFile: 'other-file'
            XYsomeFile: 'some-file'
        }

    test 'deep-map files and folders' !->
        result = deepRequire '../test-fixtures' { +recursive, map: -> "XY#it" }
        deepEqual result, {
            XYindex: 'index'
            XYotherFile: 'other-file'
            XYsomeFile: 'some-file'
            XYsubDir: {
                XYdeepFile: 'deep-file'
            }
        }

    test 'load files from NODE_PATH' !->
        result = deepRequire 'test-fixtures'
        deepEqual result, {
            XYindex: 'index'
            XYotherFile: 'other-file'
            XYsomeFile: 'some-file'
            XYsubDir: {
                XYdeepFile: 'deep-file'
            }
        }
