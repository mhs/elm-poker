module Model.Session exposing (GamesData, GamesDataItems, Session(..), UserToken)

import Graphqelm.Http exposing (Error(..))
import Model.PokerGame exposing (PokerGame)
import RemoteData exposing (RemoteData)


type alias UserToken =
    { token : String }


type alias GamesDataItems =
    List (Maybe PokerGame)


type alias GamesData =
    RemoteData (Graphqelm.Http.Error GamesDataItems) GamesDataItems


{-| A session represents all of a user's data. Currently it contains their user
token and the games they belong to.
-}
type Session
    = NotLoggedIn
    | LoggedIn (Maybe UserToken) GamesData
