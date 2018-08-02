module View.Session.Login exposing (ExternalMsg(..), Model, Msg(..), initialModel, update, view)

import Graphqelm.Http
import Helpers.Form as Form exposing (input, viewErrors)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Session exposing (Session)
import RemoteData exposing (RemoteData(..))
import Route exposing (Route(..), redirectTo)
import Util exposing ((=>))
import Validate exposing (Validator, ifBlank, ifInvalidEmail, validate)


-- MODEL --


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



-- MESSAGES --


type Msg
    = SubmitForm
    | SetEmail String
    | LoginCompleted (RemoteData Graphqelm.Http.Error Session)


type ExternalMsg
    = NoOp
    | SetSession Session



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "mt4 mt6-1 pa4" ]
        [ h1 [] [ text "Log in" ]
        , div [ class "measure center" ]
            [ viewErrors model.errors
            , viewForm
            ]
        ]


viewForm : Html Msg
viewForm =
    Html.form [ onSubmit SubmitForm ]
        [ Form.input "Email" [ type_ "email", onInput SetEmail ] []
        , button [ value "submit", class "b ph3 pv2 input-reset ba b--black bg-transparent grow pointer f6" ] [ text "Log In" ]
        ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        SubmitForm ->
            case validate modelValidator model of
                [] ->
                    { model | errors = [] }
                        => makeRequest model
                        => NoOp

                errors ->
                    { model | errors = errors }
                        => Cmd.none
                        => NoOp

        SetEmail email ->
            { model | email = email }
                => Cmd.none
                => NoOp

        LoginCompleted RemoteData.NotAsked ->
            model => Cmd.none => NoOp

        LoginCompleted RemoteData.Loading ->
            model => Cmd.none => NoOp

        LoginCompleted (RemoteData.Failure error) ->
            { model | errors = processApiError error }
                => Cmd.none
                => NoOp

        LoginCompleted (RemoteData.Success session) ->
            model
                => redirectTo Route.Home
                => SetSession session


makeRequest : Model -> Cmd Msg
makeRequest model =
    Cmd.none


processApiError : a -> List Error
processApiError error =
    []



-- VALIDATION


modelValidator : Validator Error Model
modelValidator =
    Validate.all
        [ Validate.firstError
            [ ifBlank .email (Email => "can't be blank")
            , ifInvalidEmail .email <| \email -> Email => "'" ++ email ++ "' is not a valid email address"
            ]
        ]
