module Tests exposing (..)

import Test exposing (..)
import Expect
import Main exposing(parseJSON, JSON(..))


-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


all : Test
all =
    describe "A Test Suite"
        [
            describe "JSONのパースをしたい"
                [
                    test "空のJSONをパースする" <|
                        \_ ->
                            let
                                expected = Object []
                                actual = parseJSON "{}"
                            in

                            Expect.equal expected actual
                ]
        ]
