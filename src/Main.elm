module Main exposing (main)

import Browser exposing (application)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (..)
import Page exposing (Page(..))
import Page.Login as Login
import Page.Home as Home
import Page.NotFound as NotFound
import Page.GameList as GameList
import Route exposing (Route)
import Url exposing (Url)

-- MODEL --

type alias Model =
    { key : Key
    , page : Page
    -- , session : Session
    }


type alias Flags =
    {}


type Msg
    = LinkClicked Browser.UrlRequest
    | SetRoute (Maybe Route)


-- INIT --

init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags location key =
    updateRoute (Route.fromLocation location) (initialModel flags key)


initialModel : Flags -> Key -> Model
initialModel flags key =
    { key = key
    , page = Blank
    }


-- UPDATE --
update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked urlRequest ->
           case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        SetRoute route ->
            updateRoute route model

-- VIEW --

view : Model -> Browser.Document Msg
view model =
    let
        title sub =
            "Elm Poker: " ++ sub

        frame =
            Page.frame model.page
    in
    case model.page of
        NotFound ->
            frame (title "Not Found") NotFound.view

        Blank ->
            frame (title "Loading...") (Html.text "Loading...")

        Home ->
            frame (title "Home") Home.view

        Login ->
            frame (title "Login") Login.view

        GameList ->
            frame (title "Games") GameList.view


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
        , onUrlChange = Route.fromLocation >> SetRoute
        , onUrlRequest = LinkClicked
        }


-- HELPERS --

updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
updateRoute route model =
    case route of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Home ->
            ( { model | page = Home }, Cmd.none )

        Just Route.Login ->
            ( { model | page = Login }, Cmd.none )

        Just Route.GameList ->
            ( { model | page = GameList }, Cmd.none )
