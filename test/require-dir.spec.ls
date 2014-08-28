'use strict'

suite 'require-dir' !->
    require-dir = require '../../build/require-dir'

    test 'require a directory and camelizes names' !->
        result = require-dir '../fixtures'

        expect( Object.keys result .length ).to.be( 3 )
        expect( result.index    ).to.be( 'index'     )
        expect( result.laLeLu   ).to.be( 'la-le-lu'  )
        expect( result.someFile ).to.be( 'some-file' )

    test 'require a directory with sub-directories and camelizes names' !->
        result = require-dir '../fixtures' { +recursive }

        expect( Object.keys result .length ).to.be( 4 )
        expect( result.index    ).to.be( 'index'     )
        expect( result.laLeLu   ).to.be( 'la-le-lu'  )
        expect( result.someFile ).to.be( 'some-file' )
        expect( result.subDir ).to.be.a( Object )
        expect( result.subDir.deepFile ).to.be( 'deep-file' )

    test 'camelize filenames' !->
        result = require-dir '../fixtures'

    test 'don\'t camelize filenames options' !->
        result2 = require-dir '../fixtures' { +camelize }

    test 'filters extensions' !->
        result = require-dir '../fixtures' { extensions: [ 'ls' ] }

    test 'filters filenames' !->
        result = require-dir '../fixtures' { filter: /^(?!index).*/i }

    test 're-map filenames' !->
        result = require-dir '../fixtures' { map: -> "foo#it" }
