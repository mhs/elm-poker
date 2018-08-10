module Update exposing (init, update)

import Graphqelm.Http exposing (Error(..))
import Graphqelm.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Messages exposing (Msg(..))
import Model exposing (Flags, Model, Page(..), initialModel)
import Model.PokerGame exposing (PokerGame)
import Model.Session exposing (GamesData, Session(..), UserToken)
import Navigation exposing (Location)
import PokerApi.Object.Game as ApiGame
import PokerApi.Query as Query
import RemoteData exposing (RemoteData)
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


gameSelection =
    ApiGame.selection PokerGame
        |> with ApiGame.id
        |> with ApiGame.name
        |> with ApiGame.status


query =
    Query.selection identity
        |> with (Query.myGames gameSelection)


maybeFetchGames : Maybe UserToken -> GamesData -> Cmd Msg
maybeFetchGames maybeUserToken games =
    case maybeUserToken of
        Nothing ->
            Cmd.none

        Just userToken ->
            case games of
                RemoteData.NotAsked ->
                    query
                        |> Graphqelm.Http.queryRequest "http://localhost:4000/api/graphql"
                        |> Graphqelm.Http.withHeader "authorization" ("Bearer " ++ userToken.token)
                        |> Graphqelm.Http.send (RemoteData.fromResult >> GotGames)

                _ ->
                    Cmd.none
