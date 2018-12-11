module Main exposing (Model, Msg(..), ValueType(..), init, main, update, view)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, br, div, h1, img, input, pre, text, textarea)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onInput)
import Json.Decode as D
import Json.Encode as E



---- MODEL ----


type alias Model =
    { text : String }


init : ( Model, Cmd Msg )
init =
    ( { text = "" }, Cmd.none )



---- PARSER ----


type ValueType
    = String String
    | Int Int
    | Float Float
    | Bool Bool
    | Null (Maybe Bool)
    | Object (List ( String, ValueType ))
    | List (List ValueType)


valueTypeDecoder : D.Decoder ValueType
valueTypeDecoder =
    D.oneOf
        [ D.string
            |> D.andThen (\str -> D.succeed (String str))
        , D.int
            |> D.andThen (\num -> D.succeed (Int num))
        , D.float
            |> D.andThen (\num -> D.succeed (Float num))
        , D.bool
            |> D.andThen (\bool -> D.succeed (Bool bool))
        , D.lazy
            (\_ ->
                D.list valueTypeDecoder
            )
            |> D.andThen (\list -> D.succeed (List list))
        , D.lazy
            (\_ ->
                D.keyValuePairs valueTypeDecoder
            )
            |> D.andThen (\object -> D.succeed (Object object))
        , D.nullable D.bool
            |> D.andThen (\_ -> D.succeed (Null Nothing))
        ]


valueTypeEncode : ValueType -> E.Value
valueTypeEncode vt =
    case vt of
        String str ->
            E.string str

        Int num ->
            E.int num

        Float num ->
            E.float num

        Bool bool ->
            E.bool bool

        Object object ->
            E.dict identity valueTypeEncode (Dict.fromList object)

        Null null ->
            E.null

        List list ->
            E.list valueTypeEncode list



---- UPDATE ----


type Msg
    = Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change str ->
            ( { model | text = str }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        decoded =
            case D.decodeString valueTypeDecoder model.text of
                Ok a ->
                    { val = Just a, err = "" }

                Err err ->
                    { val = Nothing, err = D.errorToString err }

        encoded =
            case decoded.val of
                Nothing ->
                    ""

                Just all ->
                    E.encode 4 (valueTypeEncode all)
    in
    div []
        [ textarea [ onInput Change ] []
        , br [] []
        , pre [ style "background-color" "#d44" ] [ text decoded.err ]
        , pre [] [ text encoded ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
