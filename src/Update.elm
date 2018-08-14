module Update exposing (init, update)

import Messages as Msg exposing (Msg(..))
import Model exposing (Flags, Model, Page(..), initialModel)
import Model.Session exposing (GamesData, Session(..), UserToken)
import Navigation exposing (Location)
import RemoteData exposing (RemoteData)
import Request exposing (gamesQuery)
import Route exposing (Route, redirectTo)
import Session.Login as Login
import Session.Messages as SessionMsg exposing (ExternalMsg(..), Msg(..))
import Util exposing ((=>))


init : Flags -> Location -> ( Model, Cmd Msg.Msg )
init flags location =
    updateRoute (Route.fromLocation location) (initialModel flags)


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg.Msg )
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
            let
                loggedOutModel =
                    case model.session of
                        LoggedIn _ _ ->
                            { model | session = NotLoggedIn }

                        NotLoggedIn ->
                            model
            in
            { loggedOutModel | page = Login Login.initialModel } => Cmd.none

        Just Route.GameList ->
            case model.session of
                LoggedIn userToken games ->
                    { model | page = GameList } => maybeFetchGames userToken games

                NotLoggedIn ->
                    model => redirectTo Route.Login

        Just (Route.Game id) ->
            case model.session of
                LoggedIn _ _ ->
                    { model | page = Game } => Cmd.none

                NotLoggedIn ->
                    model => redirectTo Route.Login


update : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
update msg model =
    updatePage model.page msg model


updatePage : Page -> Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
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
                        SessionMsg.NoOp ->
                            model

                        SessionMsg.SetSession userToken ->
                            { model | session = LoggedIn userToken RemoteData.NotAsked }
            in
            { updatedModel | page = Login pageModel }
                => Cmd.map LoginMsg cmd

        ( GotGames gamesData, GameList ) ->
            case model.session of
                NotLoggedIn ->
                    ( model, Cmd.none )

                LoggedIn userToken _ ->
                    { model | session = LoggedIn userToken gamesData } => Cmd.none

        ( _, _ ) ->
            ( model, Cmd.none )



-- REQUEST --


maybeFetchGames : Maybe UserToken -> GamesData -> Cmd Msg.Msg
maybeFetchGames maybeUserToken games =
    case maybeUserToken of
        Nothing ->
            Cmd.none

        Just userToken ->
            case games of
                RemoteData.NotAsked ->
                    gamesQuery userToken

                _ ->
                    Cmd.none
