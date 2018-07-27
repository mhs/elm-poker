module Main exposing (main)

import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Navigation exposing (Location)
import Route exposing (Route)
import Update exposing (init, update)
import View exposing (view)


subscriptions : Model -> Sub Msg
subscriptions model_ =
    Sub.none


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
