module Session.Login exposing (ExternalMsg(..), Model, Msg(..), initialModel, update, view)

import Graphqelm.Http exposing (Error(..))
import Graphqelm.Operation exposing (RootMutation)
import Graphqelm.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Helpers.Form as Form exposing (input, viewErrors)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Session exposing (Session)
import PokerApi.Mutation as Mutation
import PokerApi.Object.Session as ApiSession
import RemoteData exposing (RemoteData)
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


type alias SessionData =
    RemoteData (Graphqelm.Http.Error (Maybe Session)) (Maybe Session)


type Msg
    = SubmitForm
    | SetEmail String
    | LoginCompleted SessionData


type ExternalMsg
    = NoOp
    | SetSession (Maybe Session)



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

        LoginCompleted (RemoteData.Failure error) ->
            { model | errors = processApiError error }
                => Cmd.none
                => NoOp

        LoginCompleted (RemoteData.Success session) ->
            model
                => redirectTo Route.Home
                => SetSession session

        LoginCompleted _ ->
            model => Cmd.none => NoOp



-- REQUEST --


sessionSelect =
    ApiSession.selection Session
        |> with ApiSession.token


mutation : Model -> SelectionSet (Maybe Session) RootMutation
mutation model =
    Mutation.selection identity
        |> with (Mutation.login { email = model.email } sessionSelect)


makeRequest : Model -> Cmd Msg
makeRequest model =
    mutation model
        |> Graphqelm.Http.mutationRequest "http://localhost:4000/api/graphql"
        |> Graphqelm.Http.send (RemoteData.fromResult >> LoginCompleted)


processApiError : Graphqelm.Http.Error (Maybe Session) -> List Error
processApiError error =
    case error of
        GraphqlError data errors ->
            errors |> List.map .message |> List.map (\m -> Form => m)

        HttpError error ->
            [ Form => toString error ]



-- VALIDATION


modelValidator : Validator Error Model
modelValidator =
    Validate.all
        [ Validate.firstError
            [ ifBlank .email (Email => "can't be blank")
            , ifInvalidEmail .email <| \email -> Email => "'" ++ email ++ "' is not a valid email address"
            ]
        ]
