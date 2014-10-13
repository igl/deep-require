'use strict'

suite 'deep-require' !->
    deepRequire = require '../'

    test 'default options require without error' !->
        result = deepRequire '../test-fixtures'
        strictEqual 3, (Object.keys result .length)

    test 'camelizes' !->
        result = deepRequire '../test-fixtures'
        deepEqual result, {
            index: 'index.ls'
            otherFile: 'other-file.ls'
            someFile: 'some-file.js'
        }

    test 'do not camelize' !->
        result = deepRequire '../test-fixtures' { -camelize }
        deepEqual result, {
            'index': 'index.ls'
            'other-file': 'other-file.ls'
            'some-file': 'some-file.js'
        }

    test 'require with sub-directories' !->
        result = deepRequire '../test-fixtures' { +recursive }
        deepEqual result, {
            index: 'index.ls'
            otherFile: 'other-file.ls'
            someFile: 'some-file.js'
            subDir: {
                deepFile: 'deep-file.ls'
                evenDeeper: 'even-deeper.js'
            }
        }

    test 'filters extensions' !->
        result = deepRequire '../test-fixtures' { extensions: [ 'ls' ] }
        strictEqual 2, (Object.keys result .length)

    test 'filters filenames' !->
        result = deepRequire '../test-fixtures' { filter: /^index.?/i }
        strictEqual 1, (Object.keys result .length)

    test 'map files' !->
        result = deepRequire '../test-fixtures' { map: -> "XY#it" }
        deepEqual result, {
            XYindex: 'index.ls'
            XYotherFile: 'other-file.ls'
            XYsomeFile: 'some-file.js'
        }

    test 'deep-map files' !->
        result = deepRequire '../test-fixtures' { +recursive, map: -> "XY#it" }
        deepEqual result, {
            XYindex: 'index.ls'
            XYotherFile: 'other-file.ls'
            XYsomeFile: 'some-file.js'
            subDir: {
                XYdeepFile: 'deep-file.ls'
                XYevenDeeper: 'even-deeper.js'
            }
        }

    test 'load files from NODE_PATH' !->
        result = deepRequire 'sub-dir'
        deepEqual result, {
            deepFile: 'deep-file.ls'
            evenDeeper: 'even-deeper.js'
        }
