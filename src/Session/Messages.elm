module Session.Messages exposing (ExternalMsg(..), Msg(..))

import Graphql.Http exposing (Error(..))
import Model.Session exposing (UserToken)
import RemoteData exposing (RemoteData)


type alias SessionData =
    RemoteData (Graphql.Http.Error (Maybe UserToken)) (Maybe UserToken)


type Msg
    = SubmitForm
    | SetEmail String
    | LoginCompleted SessionData


type ExternalMsg
    = NoOp
    | SetSession (Maybe UserToken)
