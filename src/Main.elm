module Main exposing (main)

import Browser exposing (application)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (..)
import Page exposing (Page(..), login, titleFromString)
import Page.GameList as GameList
import Page.Home as Home
import Page.Login as Login exposing (ExternalMsg(..), Msg(..))
import Page.NotFound as NotFound
import Route exposing (Route(..), redirectTo)
import Session exposing (Session(..))
import Url exposing (Url)



-- MODEL --


type alias Model =
    { key : Key
    , page : Page
    , session : Session
    }


type alias Flags =
    {}


type Msg
    = LinkClicked Browser.UrlRequest
    | SetRoute Url
    | LoginMsg Login.Msg



-- INIT --


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags location key =
    location |> Route.fromLocation |> updateRoute (initialModel flags key)


initialModel : Flags -> Key -> Model
initialModel flags key =
    { key = key
    , session = NotLoggedIn
    , page = Blank
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case model.session of
                        NotLoggedIn ->
                            ( model, Nav.pushUrl model.key (Url.toString url) )

                        LoggedIn _ ->
                            ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( SetRoute location, _ ) ->
            location |> Route.fromLocation |> updateRoute model

        ( LoginMsg loginMsg, Page.Login loginModel ) ->
            let
                ( ( updatedLogin, loginCmd ), appMsg ) =
                    Login.update loginMsg loginModel
            in
            case appMsg of
                SetSession session ->
                    case session of
                        Nothing ->
                            ( { model | session = NotLoggedIn, page = Page.Login updatedLogin }, Cmd.map LoginMsg loginCmd )

                        Just token ->
                            ( { model | session = LoggedIn token }, redirectTo Route.Home model.key )

                NoOp ->
                    ( { model | page = Page.Login updatedLogin }, Cmd.map LoginMsg loginCmd )

        ( LoginMsg _, _ ) ->
            ( model, Cmd.none )



-- VIEW --


view : Model -> Browser.Document Msg
view model =
    let
        title sub =
            titleFromString ("Elm Poker: " ++ sub)

        withFrame =
            Page.frame model.page model.session
    in
    case model.page of
        NotFound ->
            withFrame (title "Not Found") NotFound.view

        Blank ->
            withFrame (title "Loading...") (Html.text "Loading...")

        Page.Home ->
            withFrame (title "Home") Home.view

        Page.Login loginModel ->
            withFrame (title "Login") (Html.map LoginMsg (Login.view loginModel))

        Page.GameList ->
            withFrame (title "Games") GameList.view



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub msg
subscriptions model_ =
    Sub.none



-- MAIN --


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = SetRoute
        , onUrlRequest = LinkClicked
        }



-- HELPERS --


updateRoute : Model -> Maybe Route -> ( Model, Cmd Msg )
updateRoute model route =
    case route of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Home ->
            ( { model | page = Page.Home }, Cmd.none )

        Just Route.Login ->
            ( { model | page = Page.login }, Cmd.none )

        Just Route.GameList ->
            ( { model | page = Page.GameList }, Cmd.none )
