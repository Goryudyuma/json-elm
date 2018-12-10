module Main exposing (Model, Msg(..), ValueType(..), init, main, update, view)

import Browser
import Html exposing (Html, br, div, h1, img, input, text, textarea)
import Html.Attributes exposing (src)
import Html.Events exposing (onInput)
import Json.Decode as D



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
    | Object (List ( String, Maybe ValueType ))
    | List (List (Maybe ValueType))




valueTypeDecoder : D.Decoder (Maybe ValueType)
valueTypeDecoder =
    D.nullable <|
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
            ]



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
    div []
        [ textarea [ onInput Change ] []
        , br [] []
        , text (Debug.toString (D.decodeString valueTypeDecoder model.text))
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
