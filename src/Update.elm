module Update exposing (init, update)

import Browser.Navigation exposing (Key)
import Games.Game as Game exposing (getGame, init, update)
import Games.Messages as GameMsg exposing (Msg(..))
import Messages as Msg exposing (Msg(..))
import Model exposing (Flags, Model, Page(..), initialModel)
import Model.Session exposing (GamesData, Session(..), UserToken)
import RemoteData exposing (RemoteData)
import Request exposing (fetchGames)
import Route exposing (Route, redirectTo)
import Session.Login as Login
import Session.Messages as SessionMsg exposing (ExternalMsg(..), Msg(..))
import Url exposing (Url)


init : Flags -> Url -> Key -> ( Model, Cmd Msg.Msg )
init flags location key =
    updateRoute (Route.fromLocation location) (Model.initialModel flags key)


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg.Msg )
updateRoute route model =
    case route of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Home ->
            case model.session of
                LoggedIn _ _ ->
                    ( model, redirectTo Route.GameList model.key )

                NotLoggedIn ->
                    ( model, redirectTo Route.Login model.key )

        Just Route.Login ->
            let
                loggedOutModel =
                    case model.session of
                        LoggedIn _ _ ->
                            { model | session = NotLoggedIn }

                        NotLoggedIn ->
                            model
            in
            ( { loggedOutModel | page = Login Login.initialModel }, Cmd.none )

        Just Route.GameList ->
            case model.session of
                LoggedIn userToken games ->
                    ( { model | page = GameList }, maybeFetchGames userToken games )

                NotLoggedIn ->
                    ( model, redirectTo Route.Login model.key )

        Just (Route.Game id) ->
            case model.session of
                NotLoggedIn ->
                    ( model, redirectTo Route.Login model.key )

                LoggedIn userToken (RemoteData.Success games) ->
                    let
                        maybeGame =
                            Game.getGame id games
                    in
                    case maybeGame of
                        Nothing ->
                            ( { model | page = NotFound }, Cmd.none )

                        Just game ->
                            let
                                ( gameModel, gameCmd ) =
                                    Game.init userToken game
                            in
                            ( { model | page = Game gameModel }, Cmd.map GameMsg gameCmd )

                LoggedIn _ _ ->
                    -- This may happen when the user hits the game url directly
                    Debug.todo "TODO: Not defined yet"


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

                ( updatedModel, newCmd ) =
                    case externalMsg of
                        SessionMsg.NoOp ->
                            ( model, cmd )

                        SessionMsg.SetSession userToken ->
                            case userToken of
                                Nothing ->
                                    ( { model | session = NotLoggedIn }, cmd )

                                Just token ->
                                    ( { model | session = LoggedIn token RemoteData.NotAsked }, redirectTo Route.Home model.key )
            in
            ( { updatedModel | page = Login pageModel }
            , Cmd.map LoginMsg newCmd
            )

        ( GotGames gamesData, GameList ) ->
            case model.session of
                NotLoggedIn ->
                    ( model, Cmd.none )

                LoggedIn userToken _ ->
                    ( { model | session = LoggedIn userToken gamesData }, Cmd.none )

        ( GameMsg gameMsg, Game gameModel ) ->
            case model.session of
                NotLoggedIn ->
                    ( model, Cmd.none )

                LoggedIn _ _ ->
                    let
                        ( updated, cmd ) =
                            Game.update gameMsg gameModel
                    in
                    ( { model | page = Game updated }, Cmd.map GameMsg cmd )

        ( _, _ ) ->
            ( model, Cmd.none )



-- REQUEST --


maybeFetchGames : UserToken -> GamesData -> Cmd Msg.Msg
maybeFetchGames userToken games =
    case games of
        RemoteData.NotAsked ->
            fetchGames userToken

        _ ->
            Cmd.none
