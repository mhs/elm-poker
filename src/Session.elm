module Session exposing (Credentials, Email, Session(..), SessionData, UserToken, createSession, storeLogin, clearLogin, decodeSession)

import Graphql.Http exposing (Error(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Json.Decode as D
import Json.Encode as E
import PokerApi.Mutation as Mutation
import PokerApi.Object.Session as ApiSession
import PokerApi.Query as Query
import Port.Main as Port exposing (sessionStore)
import RemoteData exposing (RemoteData)


type alias UserToken =
    { token : String }

type alias Email = String

type alias Credentials =
    { email : Email }


type alias SessionData =
    RemoteData (Graphql.Http.Error (Maybe UserToken)) (Maybe UserToken)


{-| A session represents all of a user's data. Currently it contains their user
token.
-}
type Session
    = NotLoggedIn
    | LoggedIn Email

apiUrl =
    "http://localhost:4000/api/graphql"



-- REQUEST --


sessionSelect =
    ApiSession.selection UserToken
        |> with ApiSession.token


mutation credentials =
    Mutation.selection identity
        |> with (Mutation.login { email = credentials.email } sessionSelect)


createSession : (SessionData -> msg) -> Credentials -> Cmd msg
createSession msgTag credentials =
    mutation credentials
        |> Graphql.Http.mutationRequest apiUrl
        |> Graphql.Http.send (RemoteData.fromResult >> msgTag)


storeLogin : Email -> UserToken -> Cmd msg
storeLogin email token =
    sessionStore (encodeUser email token)


clearLogin : Cmd msg
clearLogin =
    sessionStore (E.object [("type", E.string "clearCurrentUser")])


encodeUser : String -> UserToken -> E.Value
encodeUser email token =
    E.object
        [ ("type", E.string "setCurrentUser")
        , ("data", E.object
            [ ("email", E.string email)
            , ("token", E.string token.token)
            ])
        ]


sessionDecoder : D.Decoder Email
sessionDecoder =
    D.field "data" (D.field "email" D.string)


decodeSession : E.Value -> Maybe Email
decodeSession =
    (D.decodeValue sessionDecoder) >> Result.toMaybe