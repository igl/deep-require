'use strict'

<-! suite 'deep-require'

deepRequire = require '../'

test 'curries' !->
    strictEqual do
        typeof (partial = deepRequire {})
        'function'
    strictEqual do
        typeof (partial '../test-fixtures')
        'object'

test 'finds dirs in NODE_PATH' !->
    deepEqual do
        deepRequire 'sub-dir'
        {
            deepFile: 'deep-file.ls'
            evenDeeper: 'even-deeper.js'
        }

suite 'options' !->
    test 'can be omitted' !->
        result = deepRequire '../test-fixtures'
        strictEqual 3, (Object.keys result .length)

    test 'can be empty' !->
        result = deepRequire {}, '../test-fixtures'
        strictEqual 3, (Object.keys result .length)

    test 'argument can be reversed' !->
        result = deepRequire '../test-fixtures', {}
        strictEqual 3, (Object.keys result .length)

    suite 'camelize' !->
        test 'camelizes by default' !->
            deepEqual do
                deepRequire '../test-fixtures'
                {
                    index: 'index.ls'
                    otherFile: 'other-file.ls'
                    someFile: 'some-file.js'
                }

        test 'can be turned off' !->
            deepEqual do
                deepRequire '../test-fixtures' { -camelize }
                {
                    'index': 'index.ls'
                    'other-file': 'other-file.ls'
                    'some-file': 'some-file.js'
                }

    suite 'recursive' !->
        test 'read from sub-directories' !->
            deepEqual do
                deepRequire '../test-fixtures' { +recursive }
                {
                    index: 'index.ls'
                    otherFile: 'other-file.ls'
                    someFile: 'some-file.js'
                    subDir: {
                        deepFile: 'deep-file.ls'
                        evenDeeper: 'even-deeper.js'
                    }
                }

        test 'flatten directories' !->
            deepEqual do
                deepRequire { recursive: 'flat' } '.'
                {
                    index: 'index.ls'
                    otherFile: 'other-file.ls'
                    someFile: 'some-file.js'
                    deepFile: 'deep-file.ls'
                    evenDeeper: 'even-deeper.js'
                }

        test 'ignore empty directories' !->
            deepEqual do
                deepRequire { +recursive } '.'
                {
                    index: 'index.ls'
                    otherFile: 'other-file.ls'
                    someFile: 'some-file.js'
                    subDir: {
                        deepFile: 'deep-file.ls'
                        evenDeeper: 'even-deeper.js'
                    }
                }

    suite 'extensions' !->
        test 'filter by file extensions' !->
            result = deepRequire '../test-fixtures' { extensions: [ 'ls' ] }
            strictEqual 2, (Object.keys result .length)

    suite 'filter' !->
        test 'filter filenames' !->
            deepEqual do
                deepRequire '../test-fixtures' { filter: /^index.?/i }
                { index: 'index.ls' }

            deepEqual do
                deepRequire '../test-fixtures' { filter: /file\.(js|ls)$/i }
                {
                    otherFile: 'other-file.ls'
                    someFile: 'some-file.js'
                }

        test 'filter filenames in sub-directories' !->
            deepEqual do
                deepRequire '../test-fixtures' { filter: /file\.(js|ls)$/i, +recursive }
                {
                    otherFile: 'other-file.ls'
                    someFile: 'some-file.js'
                    subDir: {
                        deepFile: 'deep-file.ls'
                    }
                }

    suite 'map' !->
        test 'map filenames' !->
            deepEqual do
                deepRequire '../test-fixtures' { map: -> "XY#it" }
                {
                    XYindex: 'index.ls'
                    XYotherFile: 'other-file.ls'
                    XYsomeFile: 'some-file.js'
                }

        test 'map filenames in sub-directories' !->
            deepEqual do
                deepRequire '../test-fixtures' { +recursive, map: -> "XY#it" }
                {
                    XYindex: 'index.ls'
                    XYotherFile: 'other-file.ls'
                    XYsomeFile: 'some-file.js'
                    subDir: {
                        XYdeepFile: 'deep-file.ls'
                        XYevenDeeper: 'even-deeper.js'
                    }
                }
