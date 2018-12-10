module Tests exposing (all)

import Expect
import Main exposing (..)
import Result exposing (Result(..))
import Test exposing (..)



-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


all : Test
all =
    describe "A Test Suite"
        [ describe "JSONのパースをしたい"
            [ test "空のJSONをパースする" <|
                \_ ->
                    Expect.equal "" ""
            ]
        ]
