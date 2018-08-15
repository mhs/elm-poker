module Model.PokerRound exposing (PokerRound)

import PokerApi.Scalar exposing (Id)


type alias PokerRound =
    { id : PokerApi.Scalar.Id
    , status : String
    }
