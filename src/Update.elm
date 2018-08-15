module Update exposing (init, update)

import Games.Game as Game exposing (getGame, init)
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
    updateRoute (Route.fromLocation location) (Model.initialModel flags)


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
                NotLoggedIn ->
                    model => redirectTo Route.Login

                LoggedIn userToken (RemoteData.Success games) ->
                    let
                        maybeGame =
                            Game.getGame id games
                    in
                    case maybeGame of
                        Nothing ->
                            { model | page = NotFound } => Cmd.none

                        Just game ->
                            let
                                ( gameModel, gameCmd ) =
                                    Game.init userToken game
                            in
                            { model | page = Game gameModel } => Cmd.map GameMsg gameCmd

                LoggedIn _ _ ->
                    -- This may happen when the user hits the game url directly
                    Debug.crash "TODO: Not defined yet"


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
                            case userToken of
                                Nothing ->
                                    { model | session = NotLoggedIn }

                                Just token ->
                                    { model | session = LoggedIn token RemoteData.NotAsked }
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


maybeFetchGames : UserToken -> GamesData -> Cmd Msg.Msg
maybeFetchGames userToken games =
    case games of
        RemoteData.NotAsked ->
            gamesQuery userToken

        _ ->
            Cmd.none
