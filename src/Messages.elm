module Messages exposing (Msg(..))

import Route exposing (Route)
import View.Session.Login as Login exposing (Msg(..))


type Msg
    = SetRoute (Maybe Route)
    | LoginMsg Login.Msg
