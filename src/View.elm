module View exposing (..)

import Games.Game as Game
import Games.List as GameList
import Html exposing (..)
import Messages exposing (Msg(..))
import Model exposing (Model, Page(..))
import Session.Login as Login
import View.Home as Home
import View.NotFound as NotFound
import View.Page as Page


view : Model -> Html Msg
view model =
    let
        frame =
            Page.frame model.page model.session
    in
    case model.page of
        NotFound ->
            frame NotFound.view

        Blank ->
            frame <| Html.text "Loading..."

        Home ->
            frame Home.view

        Login subModel ->
            frame (Login.view subModel)
                |> Html.map LoginMsg

        GameList ->
            frame (GameList.view model.session)

        Game ->
            frame Game.view
