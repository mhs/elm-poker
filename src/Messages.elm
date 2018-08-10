module Messages exposing (Msg(..))

import Model.Session exposing (GamesData)
import Route exposing (Route)
import Session.Login as Login exposing (Msg(..))


type Msg
    = SetRoute (Maybe Route)
    | LoginMsg Login.Msg
    | GotGames GamesData
    | GotGame
