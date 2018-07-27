module Update exposing (init, update)

import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Model, Page(..), initialModel)
import Navigation exposing (Location)
import Route exposing (Route)
import Util exposing ((=>))


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    updateRoute (Route.fromLocation location) (initialModel val)


redirectTo : Route -> Cmd Msg
redirectTo =
    Route.routeToString >> Navigation.modifyUrl


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
updateRoute route model =
    case route of
        Nothing ->
            { model | page = NotFound } => Cmd.none

        Just Route.Home ->
            model => redirectTo Route.Login

        Just Route.Login ->
            { model | page = Login } => Cmd.none

        Just Route.GameList ->
            { model | page = GameList } => Cmd.none

        Just (Route.Game id) ->
            { model | page = Game } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetRoute route ->
            updateRoute route model
