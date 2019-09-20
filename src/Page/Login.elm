module Page.Login exposing (Model, Msg(..), initialModel, initialView, update, view)

import Graphql.Http exposing (Error(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (RemoteData)
import Route exposing (Route(..), redirectTo)
import Session exposing (Credentials, Email, SessionData, UserToken, createSession, storeLogin, clearLogin)
import Validate exposing (Validator, ifBlank, ifInvalidEmail, validate)
import ViewHelpers.Form as Form exposing (input, viewErrors)



-- MODEL --


type Msg
    = SubmitForm
    | SetEmail String
    | LoginCompleted SessionData


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



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitForm ->
            case validate modelValidator model of
                Ok valid ->
                     ( { model | errors = [] }, createSession LoginCompleted (Credentials model.email) )

                Err errors ->
                     ( { model | errors = errors }, Cmd.none )

        SetEmail email ->
             ( { model | email = email }, Cmd.none )

        LoginCompleted (RemoteData.Failure error) ->
             ( { model | errors = processApiError error }, Cmd.none )

        LoginCompleted (RemoteData.Success maybeUserToken) ->
            let
                cmd =
                    case maybeUserToken of
                        Nothing ->
                            Cmd.none

                        Just token ->
                            storeLogin model.email token
            in
             ( model, cmd )

        LoginCompleted _ ->
             ( model, Cmd.none )



-- VIEW --


initialView : Html Msg
initialView =
    view initialModel


view : Model -> Html Msg
view model =
    div [ class "mt4 mt6-1 pa4" ]
        [ h1 [] [ text "Log in" ]
        , div [ class "measure center" ]
            [ viewErrors model.errors
            , Html.form [ onSubmit SubmitForm ]
                [ Form.input "Email" [ type_ "email", onInput SetEmail ] []
                , button [ value "submit", class "b ph3 pv2 input-reset ba b--black bg-transparent grow pointer f6" ] [ text "Log In" ]
                ]
            ]
        ]



-- Helpers --
-- REQUEST --


processApiError : Graphql.Http.Error (Maybe UserToken) -> List Error
processApiError error =
    case error of
        GraphqlError data errors ->
            errors |> List.map .message |> List.map (\m -> ( Email, m ))

        HttpError errorMsg ->
            [ ( Form, Debug.toString errorMsg ) ]



-- VALIDATION


modelValidator : Validator Error Model
modelValidator =
    Validate.all
        [ Validate.firstError
            [ ifBlank .email ( Email, "can't be blank" )
            , ifInvalidEmail .email <| \email -> ( Email, "'" ++ email ++ "' is not a valid email address" )
            ]
        ]
