module Request exposing (..)

import Graphqelm.Http exposing (Error(..))
import Graphqelm.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Messages exposing (Msg(..))
import Model.PokerGame exposing (PokerGame)
import Model.Session exposing (UserToken)
import PokerApi.Mutation as Mutation
import PokerApi.Object.Game as ApiGame
import PokerApi.Object.Session as ApiSession
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
        |> Graphqelm.Http.mutationRequest apiUrl
        |> Graphqelm.Http.send (RemoteData.fromResult >> LoginCompleted)



-- GAMES --


gameSelection =
    ApiGame.selection PokerGame
        |> with ApiGame.id
        |> with ApiGame.name
        |> with ApiGame.status


query =
    Query.selection identity
        |> with (Query.myGames gameSelection)


gamesQuery userToken =
    query
        |> Graphqelm.Http.queryRequest apiUrl
        |> Graphqelm.Http.withHeader "authorization" ("Bearer " ++ userToken.token)
        |> Graphqelm.Http.send (RemoteData.fromResult >> GotGames)
