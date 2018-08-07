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
    nav [ class "dt w-100 border-box pa3 ph5-ns" ]
        [ a [ class "dtc v-mid mid-gray link dim w-25", title "Home", href Route.Home ] [ text "Planning Poker" ]
        , div [ class "dtc v-mid w-75 tr" ] <|
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
    a [ href linkRoute, class "link hover-black f6 f5-ns dib mr3 mr4-ns", class active ] linkContent


isActive : Page -> Route -> Bool
isActive currentPage linkRoute =
    case ( currentPage, linkRoute ) of
        ( Model.Home, Route.Home ) ->
            True

        ( Model.Login subModel, Route.Login ) ->
            True

        ( Model.GameList, Route.GameList ) ->
            True

        ( Model.Game, Route.GameList ) ->
            True

        _ ->
            False
