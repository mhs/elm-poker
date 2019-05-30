module Request exposing (apiUrl, createSession, fetchGames, fetchRoundAndPlayers, gameDataSelection, gameQuery, gameSelection, gamesQuery, mutation, playerSelection, roundSelection, sessionSelect)

import Games.Messages as GamesMsg exposing (GameData(..), GameDataResponse, Msg(..))
import Graphql.Http exposing (Error(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Messages exposing (Msg(..))
import Model.PokerGame exposing (PokerGame)
import Model.PokerPlayer exposing (PokerPlayer)
import Model.PokerRound exposing (PokerRound)
import Model.Session exposing (UserToken)
import PokerApi.Mutation as Mutation
import PokerApi.Object.Game as ApiGame
import PokerApi.Object.Round as ApiRound
import PokerApi.Object.Session as ApiSession
import PokerApi.Object.User as ApiPlayer
import PokerApi.Query as Query
import RemoteData exposing (RemoteData)
import Session.Messages as Session exposing (Msg(..))


apiUrl =
    "http://localhost:4000/api/graphql"



-- SESSION --


sessionSelect =
    ApiSession.selection UserToken
        |> with ApiSession.token


mutation model =
    Mutation.selection identity
        |> with (Mutation.login { email = model.email } sessionSelect)


createSession model =
    mutation model
        |> Graphql.Http.mutationRequest apiUrl
        |> Graphql.Http.send (RemoteData.fromResult >> LoginCompleted)



-- GAMES --
-- List --


gameSelection =
    ApiGame.selection PokerGame
        |> with ApiGame.id
        |> with ApiGame.name
        |> with ApiGame.status


gamesQuery =
    Query.selection identity
        |> with (Query.myGames gameSelection)


fetchGames userToken =
    gamesQuery
        |> Graphql.Http.queryRequest apiUrl
        |> Graphql.Http.withHeader "authorization" ("Bearer " ++ userToken.token)
        |> Graphql.Http.send (RemoteData.fromResult >> GotGames)



-- Detail --


playerSelection =
    ApiPlayer.selection PokerPlayer
        |> with ApiPlayer.id
        |> with ApiPlayer.email


roundSelection =
    ApiRound.selection PokerRound
        |> with ApiRound.id
        |> with ApiRound.status


gameDataSelection =
    ApiGame.selection GameData
        |> with (ApiGame.players playerSelection)
        |> with (ApiGame.currentRound roundSelection)


gameQuery id =
    Query.selection identity
        |> with (Query.game { id = id } gameDataSelection)


fetchRoundAndPlayers userToken id =
    gameQuery id
        |> Graphql.Http.queryRequest apiUrl
        |> Graphql.Http.withHeader "authorization" ("Bearer " ++ userToken.token)
        |> Graphql.Http.send (RemoteData.fromResult >> DataFetched)
