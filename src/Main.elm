port module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, p, text)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)
import Task
import Time


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
    { receivedMessage : String
    , zone : Time.Zone
    , time : Time.Posix
    , receivedCount : Int
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { receivedMessage = "", receivedCount = 0, zone = Time.utc, time = Time.millisToPosix 0 }
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Send
    | Recv String
    | NewTime Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Send ->
            ( model, sendMessage "front-to-back" )

        Recv message ->
            ( { model | receivedMessage = message, receivedCount = model.receivedCount + 1 }
            , Task.perform NewTime Time.now
            )

        NewTime newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    div [ class "container" ]
        [ div [ class "row" ]
            [ div []
                [ button [ onClick Send ] [ text "front-to-back" ]
                ]
            ]
        , p [] [ text <| model.receivedMessage ++ "(" ++ String.fromInt model.receivedCount ++ ")" ]
        , p [] [ text <| hour ++ ":" ++ minute ++ ":" ++ second ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ messageReceiver Recv
        ]
