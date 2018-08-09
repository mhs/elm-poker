module Model.PokerGame exposing (PokerGame)

import PokerApi.Scalar exposing (Id)


type alias PokerGame =
    { id : PokerApi.Scalar.Id
    , name : String
    , status : String
    }
