module Session.Login exposing (Model, initialModel, update, view)

import Graphql.Http exposing (Error(..))
import Helpers.Form as Form exposing (input, viewErrors)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Session exposing (Session(..), UserToken)
import RemoteData exposing (RemoteData)
import Request exposing (createSession)
import Route exposing (Route(..), redirectTo)
import Session.Messages exposing (ExternalMsg(..), Msg(..))
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
                Ok valid ->
                    ( ( { model | errors = [] }
                      , createSession model
                      )
                    , NoOp
                    )

                Err errors ->
                    ( ( { model | errors = errors }
                      , Cmd.none
                      )
                    , NoOp
                    )

        SetEmail email ->
            ( ( { model | email = email }
              , Cmd.none
              )
            , NoOp
            )

        LoginCompleted (RemoteData.Failure error) ->
            ( ( { model | errors = processApiError error }
              , Cmd.none
              )
            , NoOp
            )

        LoginCompleted (RemoteData.Success session) ->
            ( ( model
              , Cmd.none
              )
            , SetSession session
            )

        LoginCompleted _ ->
            ( ( model, Cmd.none ), NoOp )



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
