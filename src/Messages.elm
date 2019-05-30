module Messages exposing (Msg(..))

import Browser
import Games.Messages as GameMsg exposing (Msg(..))
import Model.Session exposing (GamesData)
import Route exposing (Route)
import Session.Messages as Session exposing (Msg(..))


type Msg
    = LinkClicked Browser.UrlRequest
    | SetRoute (Maybe Route)
    | LoginMsg Session.Msg
    | GotGames GamesData
    | GameMsg GameMsg.Msg
