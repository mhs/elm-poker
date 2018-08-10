module View.Page exposing (frame, rhref)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Model exposing (Page(..))
import Model.Session exposing (Session(..))
import Route exposing (Route(..))


rhref : Route -> Attribute msg
rhref route =
    route
        |> Route.routeToString
        |> Attr.href


frame : Page -> Session -> Html msg -> Html msg
frame currentPage session content =
    div []
        [ viewHeader currentPage session
        , content
        ]


viewHeader : Page -> Session -> Html msg
viewHeader currentPage session =
    let
        navLinks =
            case session of
                NotLoggedIn ->
                    [ navbarLink currentPage Route.Login [ text "Login" ] ]

                LoggedIn _ _ ->
                    [ navbarLink currentPage Route.Home [ text "Home" ]
                    , navbarLink currentPage Route.GameList [ text "Games" ]
                    ]
    in
    header [ class "bg-white black-80 tc pv4 avenir" ]
        [ a [ class "mt2 mb0 link baskerville i fw1 f1", title "Home", rhref Route.Home ] [ text "Planning Poker" ]
        , nav [ class "bt bb tc mw7 center mt4" ] navLinks
        ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink currentPage linkRoute linkContent =
    let
        active =
            case isActive currentPage linkRoute of
                True ->
                    "bg-light-green"

                False ->
                    ""
    in
    a [ rhref linkRoute, class "f6 f5-l link bg-animate black-80 hover-bg-lightest-blue dib pa3 ph3-l", class active ] linkContent


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
