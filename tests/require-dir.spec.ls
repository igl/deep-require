'use strict'

suite 'deep-require' !->
    deepRequire = require '../'

    test 'require a directory' !->
        result = deepRequire '../test-fixtures'
        expect( Object.keys result .length ).to.be 3

    test 'camelizes names' !->
        result = deepRequire '../test-fixtures'
        expect( result.index     ).to.be 'index'
        expect( result.otherFile ).to.be 'other-file'
        expect( result.someFile  ).to.be 'some-file'

    test 'require with sub-directories' !->
        result = deepRequire '../test-fixtures' { +recursive }

        expect( Object.keys result .length ).to.be 4
        expect( result.index     ).to.be 'index'
        expect( result.otherFile ).to.be 'other-file'
        expect( result.someFile  ).to.be 'some-file'
        expect( result.subDir    ).to.be.a Object
        expect( result.subDir.deepFile ).to.be 'deep-file'

    test 'don\'t camelize filenames' !->
        result = deepRequire '../test-fixtures' { -camelize }
        expect( result.index         ).to.be 'index'
        expect( result["other-file"] ).to.be 'other-file'
        expect( result["some-file"]  ).to.be 'some-file'

    test 'filters extensions' !->
        result = deepRequire '../test-fixtures' { extensions: [ 'ls' ] }
        expect( Object.keys result .length ).to.be 2

    test 'filters filenames' !->
        result = deepRequire '../test-fixtures' { filter: /^index.?/i }
        expect( Object.keys result .length ).to.be 1

    test 'map file and folder names' !->
        result = deepRequire '../test-fixtures' { +recursive, map: -> "FOO#it" }
        expect( result.FOOindex     ).to.be 'index'
        expect( result.FOOotherFile ).to.be 'other-file'
        expect( result.FOOsomeFile  ).to.be 'some-file'
        expect( result.FOOsubDir    ).to.be.a Object
        expect( result.FOOsubDir.FOOdeepFile ).to.be 'deep-file'
