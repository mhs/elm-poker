module Messages exposing (Msg(..))

import Games.Game as Game exposing (Msg(..))
import Model.Session exposing (GamesData)
import Route exposing (Route)
import Session.Messages as Session exposing (Msg(..))


type Msg
    = SetRoute (Maybe Route)
    | LoginMsg Session.Msg
    | GotGames GamesData
    | GameMsg Game.Msg
