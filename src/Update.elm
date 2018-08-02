module Update exposing (init, update)

import Messages exposing (Msg(..))
import Model exposing (Flags, Model, Page(..), initialModel)
import Navigation exposing (Location)
import Route exposing (Route, redirectTo)
import Util exposing ((=>))
import View.Session.Login as Login


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    updateRoute (Route.fromLocation location) (initialModel flags)


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
updateRoute route model =
    case route of
        Nothing ->
            { model | page = NotFound } => Cmd.none

        Just Route.Home ->
            model => redirectTo Route.Login

        Just Route.Login ->
            { model | page = Login Login.initialModel } => Cmd.none

        Just Route.GameList ->
            { model | page = GameList } => Cmd.none

        Just (Route.Game id) ->
            { model | page = Game } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage model.page msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage currentPage msg model =
    case ( msg, currentPage ) of
        ( SetRoute route, _ ) ->
            updateRoute route model

        ( LoginMsg subMsg, Login subModel ) ->
            let
                ( ( pageModel, cmd ), externalMsg ) =
                    Login.update subMsg subModel

                updatedModel =
                    case externalMsg of
                        Login.NoOp ->
                            model

                        Login.SetSession session ->
                            model
            in
            { updatedModel | page = Login pageModel }
                => Cmd.map LoginMsg cmd

        ( _, _ ) ->
            ( model, Cmd.none )
