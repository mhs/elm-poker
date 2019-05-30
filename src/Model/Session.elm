module Model.Session exposing (GamesData, GamesDataItems, Session(..), UserToken)

import Graphql.Http exposing (Error(..))
import Model.PokerGame exposing (PokerGame)
import RemoteData exposing (RemoteData)


type alias UserToken =
    { token : String }


type alias GamesDataItems =
    List PokerGame


type alias GamesData =
    RemoteData (Graphql.Http.Error GamesDataItems) GamesDataItems


{-| A session represents all of a user's data. Currently it contains their user
token and the games they belong to.
-}
type Session
    = NotLoggedIn
    | LoggedIn UserToken GamesData
