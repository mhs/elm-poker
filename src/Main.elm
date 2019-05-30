module Main exposing (main)

import Browser exposing (application)
import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Flags, Model)
import Route exposing (Route)
import Update exposing (init, update)
import View exposing (view)


subscriptions : Model -> Sub Msg
subscriptions model_ =
    Sub.none


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = Route.fromLocation >> SetRoute
        , onUrlRequest = LinkClicked
        }
