module Games.Game exposing (Model, getGame, init, update, view)

import Games.Messages exposing (GameData(..), Msg(..))
import Html exposing (..)
import Model.PokerGame exposing (PokerGame)
import Model.PokerPlayer exposing (PokerPlayer)
import Model.PokerRound exposing (PokerRound)
import Model.Session exposing (UserToken)
import PokerApi.Scalar exposing (Id(..))
import RemoteData exposing (RemoteData)
import Request exposing (fetchRoundAndPlayers)
import Util exposing ((=>))


-- MODEL --


type alias Model =
    { game : PokerGame

    -- TODO: Replace players, currentRound with GameDataResponse
    , players : List PokerPlayer
    , currentRound : Maybe PokerRound
    }


initialModel : PokerGame -> Model
initialModel game =
    -- TODO: Change [] Nothing to RemoteData.NotAsked
    Model game [] Nothing


getGame : Id -> List PokerGame -> Maybe PokerGame
getGame id games =
    games
        |> List.filter (\game -> game.id == id)
        |> List.head



-- UPDATE --


init : UserToken -> PokerGame -> ( Model, Cmd Msg )
init userToken game =
    initialModel game => fetchRoundAndPlayers userToken game.id


update : Msg -> Model -> ( Model, Cmd Msg )
update (DataFetched response) model =
    case response of
        RemoteData.Success maybeGameData ->
            case maybeGameData of
                Nothing ->
                    model => Cmd.none

                Just (GameData players maybeRound) ->
                    { model | players = players, currentRound = maybeRound } => Cmd.none

        _ ->
            Debug.crash "TODO: handle fetch error"



-- VIEW --


view : Model -> Html Msg
view { game } =
    div []
        [ h1 [] [ text game.name ] ]
