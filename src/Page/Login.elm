module Page.Login exposing (Model, initialModel, view)

import Graphql.Http exposing (Error(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (RemoteData)
import Route exposing (Route(..), redirectTo)
import Validate exposing (Validator, ifBlank, ifInvalidEmail, validate)



-- MODEL --

type Msg
    = SubmitForm
    | SetEmail String
    | LoginCompleted


type ExternalMsg
    = NoOp
    | SetSession


type Field
    = Form
    | Email


type alias Error =
    ( Field, String )


type alias Model =
    { email : String
    , errors : List Error
    }


initialModel : Model
initialModel =
    { email = ""
    , errors = []
    }



-- VIEW --


view : Html msg
view =
    div [ class "mt4 mt6-1 pa4" ]
        [ h1 [] [ text "Log in" ]
        , div [ class "measure center" ] []
        ]

