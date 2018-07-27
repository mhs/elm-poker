module View.Page exposing (frame)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Model exposing (Page(..))
import Route exposing (Route(..))


href : Route -> Attribute msg
href route =
    route
        |> Route.routeToString
        |> Attr.href


frame : Page -> Html msg -> Html msg
frame currentPage content =
    div []
        [ viewHeader currentPage
        , content
        ]


viewHeader : Page -> Html msg
viewHeader currentPage =
    nav []
        [ a [ title "Home", href Route.Home ] [ text "Planning Poker" ]
        , div [] <|
            [ navbarLink currentPage Route.Home [ text "Home" ]
            , navbarLink currentPage Route.Login [ text "Login" ]
            , navbarLink currentPage Route.GameList [ text "Games" ]
            ]
        ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink currentPage linkRoute linkContent =
    let
        active =
            case isActive currentPage linkRoute of
                True ->
                    "active"

                False ->
                    "inactive"
    in
    a [ href linkRoute, class active ] linkContent


isActive : Page -> Route -> Bool
isActive currentPage linkRoute =
    case ( currentPage, linkRoute ) of
        ( Model.Home, Route.Home ) ->
            True

        ( Model.Login, Route.Login ) ->
            True

        ( Model.GameList, Route.GameList ) ->
            True

        ( Model.Game, Route.GameList ) ->
            True

        _ ->
            False
