port module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, p, text)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)


port sendMessage : String -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { inputStr : String
    , receivedMessage : String
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { inputStr = "", receivedMessage = "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateInputStr String
    | Send
    | Recv String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateInputStr str ->
            ( { model | inputStr = str }
            , Cmd.none
            )

        Send ->
            ( model, sendMessage model.inputStr )

        Recv message ->
            ( { model | receivedMessage = message }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div []
                [ input [ placeholder "Enter a name...", onInput UpdateInputStr ] []
                , button [ onClick Send ] [ text "Greet" ]
                ]
            ]
        , p [] [ text model.receivedMessage ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver Recv
