module View exposing (view)

import Browser
import Games.Game as Game
import Games.List as GameList
import Html exposing (..)
import Messages exposing (Msg(..))
import Model exposing (Model, Page(..))
import Session.Login as Login
import View.Home as Home
import View.NotFound as NotFound
import View.Page as Page


view : Model -> Browser.Document Msg
view model =
    let
        title sub =
            "Elm Poker: " ++ sub

        frame =
            Page.frame model.page model.session
    in
    case model.page of
        NotFound ->
            frame (title "Not Found") NotFound.view

        Blank ->
            frame (title "Loading...") (Html.text "Loading...")

        Home ->
            frame (title "Home") Home.view

        Login subModel ->
            frame (title "Login") (Login.view subModel |> Html.map LoginMsg)

        GameList ->
            frame (title "Games") (GameList.view model.session)

        Game subModel ->
            frame (title "Game" ++ subModel.game.name) (Game.view subModel |> Html.map GameMsg)
