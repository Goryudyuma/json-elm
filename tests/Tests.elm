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
                                actual = parseJSON "{}"
                                expected = Object []
                            in

                            Expect.equal expected actual
                        ,
                    test """"a"をパースできる"""<|
                        \_ ->
                            let
                                actual = parseJSON """\"a\""""
                                expected = String "a"
                            in

                            Expect.equal expected actual

                ]
        ]
