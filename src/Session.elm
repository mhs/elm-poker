module Session exposing (Session(..), SessionData, UserToken, createSession)

import Graphql.Http exposing (Error(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import PokerApi.Mutation as Mutation
import PokerApi.Object.Session as ApiSession
import PokerApi.Query as Query
import RemoteData exposing (RemoteData)


type alias UserToken =
    { token : String }


type alias SessionData =
    RemoteData (Graphql.Http.Error (Maybe UserToken)) (Maybe UserToken)


{-| A session represents all of a user's data. Currently it contains their user
token.
-}
type Session
    = NotLoggedIn
    | LoggedIn UserToken


apiUrl =
    "http://localhost:4000/api/graphql"



-- REQUEST --


sessionSelect =
    ApiSession.selection UserToken
        |> with ApiSession.token


mutation model =
    Mutation.selection identity
        |> with (Mutation.login { email = model.email } sessionSelect)


createSession : (SessionData -> msg) -> { login | email : String } -> Cmd msg
createSession msgTag model =
    mutation model
        |> Graphql.Http.mutationRequest apiUrl
        |> Graphql.Http.send (RemoteData.fromResult >> msgTag)
