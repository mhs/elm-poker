port module Port.Main exposing (sessionStore, sessionChanged)

import Json.Encode as E

port sessionStore : E.Value -> Cmd msg

port sessionChanged : (E.Value -> msg) -> Sub msg