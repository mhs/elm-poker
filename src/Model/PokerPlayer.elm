module Model.PokerPlayer exposing (PokerPlayer)

import PokerApi.Scalar exposing (Id)


type alias PokerPlayer =
    { id : PokerApi.Scalar.Id
    , email : String
    }
