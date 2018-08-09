module Update exposing (init, update)

import Messages exposing (Msg(..))
import Model exposing (Flags, Model, Page(..), initialModel)
import Model.PokerGame exposing (PokerGame)
import Model.Session exposing (Session(..))
import Navigation exposing (Location)
import Route exposing (Route, redirectTo)
import Session.Login as Login
import Util exposing ((=>))


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    updateRoute (Route.fromLocation location) (initialModel flags)


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
updateRoute route model =
    case route of
        Nothing ->
            { model | page = NotFound } => Cmd.none

        Just Route.Home ->
            case model.session of
                LoggedIn _ _ ->
                    model => redirectTo Route.GameList

                NotLoggedIn ->
                    model => redirectTo Route.Login

        Just Route.Login ->
            { model | page = Login Login.initialModel } => Cmd.none

        Just Route.GameList ->
            { model | page = GameList } => Cmd.none

        Just (Route.Game id) ->
            case model.session of
                LoggedIn _ _ ->
                    { model | page = Game } => Cmd.none

                NotLoggedIn ->
                    model => redirectTo Route.Login


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

                        Login.SetSession userToken ->
                            { model | session = LoggedIn userToken Nothing }
            in
            { updatedModel | page = Login pageModel }
                => Cmd.map LoginMsg cmd

        ( _, _ ) ->
            ( model, Cmd.none )
