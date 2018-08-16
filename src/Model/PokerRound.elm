module Model.PokerRound exposing (PokerRound)

import PokerApi.Scalar exposing (Id)


type alias PokerRound =
    { id : Maybe PokerApi.Scalar.Id
    , status : String
    }
