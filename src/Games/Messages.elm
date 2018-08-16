module Games.Messages exposing (..)

import Graphqelm.Http exposing (Error(..))
import Model.PokerPlayer exposing (PokerPlayer)
import Model.PokerRound exposing (PokerRound)
import RemoteData exposing (RemoteData)


type GameData
    = GameData (List PokerPlayer) (Maybe PokerRound)


type alias GameDataResponse =
    RemoteData (Graphqelm.Http.Error (Maybe GameData)) (Maybe GameData)



-- MESSAGES --


type Msg
    = DataFetched GameDataResponse
