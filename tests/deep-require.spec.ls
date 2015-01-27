'use strict'

<-! suite 'deep-require'

deepRequire = require '../'

test 'works without options' !->
    result = deepRequire '../test-fixtures'
    strictEqual 3, (Object.keys result .length)

test 'works with empty options' !->
    result = deepRequire {}, '../test-fixtures'
    strictEqual 3, (Object.keys result .length)

test 'works with arguments reversed' !->
    result = deepRequire '../test-fixtures', {}
    strictEqual 3, (Object.keys result .length)

test 'curries' !->
    strictEqual do
        typeof (partial = deepRequire {})
        'function'
    strictEqual do
        typeof (partial '../test-fixtures')
        'object'

test 'camelizes' !->
    deepEqual do
        deepRequire '../test-fixtures'
        {
            index: 'index.ls'
            otherFile: 'other-file.ls'
            someFile: 'some-file.js'
        }

test 'do not camelize' !->
    deepEqual do
        deepRequire '../test-fixtures' { -camelize }
        {
            'index': 'index.ls'
            'other-file': 'other-file.ls'
            'some-file': 'some-file.js'
        }

test 'require with sub-directories' !->
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

test 'filters extensions' !->
    result = deepRequire '../test-fixtures' { extensions: [ 'ls' ] }
    strictEqual 2, (Object.keys result .length)

test 'filters filenames' !->
    deepEqual do
        deepRequire '../test-fixtures' { filter: /^index.?/i }
        { index: 'index.ls' }

    deepEqual do
        deepRequire '../test-fixtures' { filter: /file\.(js|ls)$/i }
        {
            otherFile: 'other-file.ls'
            someFile: 'some-file.js'
        }

test 'map files' !->
    deepEqual do
        deepRequire '../test-fixtures' { map: -> "XY#it" }
        {
            XYindex: 'index.ls'
            XYotherFile: 'other-file.ls'
            XYsomeFile: 'some-file.js'
        }

test 'deep-map files' !->
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

test 'list files using NODE_PATH' !->
    deepEqual do
        deepRequire 'sub-dir'
        {
            deepFile: 'deep-file.ls'
            evenDeeper: 'even-deeper.js'
        }

test 'does not list empty directories' !->
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
