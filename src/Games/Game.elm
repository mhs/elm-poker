module Games.Game exposing (Model, Msg(..), getGame, init, view)

import Graphqelm.Http exposing (Error(..))
import Html exposing (..)
import Model.PokerGame exposing (PokerGame)
import Model.PokerPlayer exposing (PokerPlayer)
import Model.PokerRound exposing (PokerRound)
import Model.Session exposing (UserToken)
import PokerApi.Scalar exposing (Id(..))
import RemoteData exposing (RemoteData)
import Util exposing ((=>))


-- MODEL --


type alias PlayersData =
    RemoteData (Graphqelm.Http.Error (List (Maybe PokerPlayer))) (List (Maybe PokerPlayer))


type alias RoundData =
    RemoteData (Graphqelm.Http.Error (Maybe PokerRound)) (Maybe PokerRound)


type GameData
    = GameData PlayersData RoundData


type alias Model =
    { game : PokerGame
    , players : PlayersData
    , currentRound : RoundData
    }


initialModel : PokerGame -> Model
initialModel game =
    Model game RemoteData.NotAsked RemoteData.NotAsked


getGame : Id -> List PokerGame -> Maybe PokerGame
getGame id games =
    games
        |> List.filter (\game -> game.id == id)
        |> List.head



-- MESSAGES --


type Msg
    = DataFetched GameData



-- UPDATE --


init : UserToken -> PokerGame -> ( Model, Cmd Msg )
init userToken game =
    initialModel game => fetchRoundandPlayers userToken game



-- VIEW --


view : Model -> Html Msg
view { game } =
    div []
        [ h1 [] [ text game.name ] ]



-- REQUEST --


fetchRoundandPlayers : UserToken -> PokerGame -> Cmd Msg
fetchRoundandPlayers token game =
    Cmd.none
