module Page exposing (Page(..), frame, login, rhref, titleFromString)

import Browser
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Page.Login exposing (Model, initialModel)
import Route exposing (Route(..))
import Session exposing (Session(..))



-- MODEL --


type Page
    = Blank
    | NotFound
    | Home
    | Login Page.Login.Model
    | GameList


type Title
    = Title String


login : Page
login =
    Login Page.Login.initialModel



-- VIEW HELPERS --


frame : Page -> Session -> Title -> Html msg -> Browser.Document msg
frame currentPage session (Title title) content =
    { title = title
    , body =
        [ div []
            [ viewHeader currentPage session
            , section [ class "pa4 black-80 helvetica" ]
                [ div [ class "measure center" ]
                    [ content
                    ]
                ]
            ]
        ]
    }


viewHeader : Page -> Session -> Html msg
viewHeader currentPage session =
    let
        navLinks =
            case session of
                LoggedIn _ ->
                    [ navbarLink currentPage Route.Home [ text "Home" ]
                    , navbarLink currentPage Route.GameList [ text "Games" ]
                    ]

                NotLoggedIn ->
                    [ navbarLink currentPage Route.Home [ text "Home" ]
                    ]
    in
    nav [ class "helvetica cf pa3 pa3-ns bb" ]
        [ div [class "fl"]
            ((a [ class "link pt2 pb2 dim black b f6 f5-ns dib mr3", rhref Route.Home ] [ text "Planning Poker" ]) :: navLinks)
        , div [class "fr"] ( loginLogout session currentPage )
        ]


loginLogout : Session -> Page -> List (Html msg)
loginLogout session currentPage =
    case session of
        LoggedIn email ->
            [ span [class "mr3"] [text ("Hello, " ++ email ++ "!")]
            , a [ rhref Route.Logout, class "link pt2 pb2 dim gray f6 f5-ns dib mr3"] [text "Logout"] ]

        NotLoggedIn ->
            [ a [ rhref Route.Login, class "link pt2 pb2 dim gray f6 f5-ns dib mr3"] [text "Login"] ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink currentPage linkRoute linkContent =
    let
        active =
            case isActive currentPage linkRoute of
                True ->
                    "bb bw2"

                False ->
                    ""
    in
    a [ rhref linkRoute, class "link pt2 pb2 dim gray f6 f5-ns dib mr3", class active ] linkContent


rhref : Route -> Attribute msg
rhref route =
    route
        |> Route.routeToString
        |> Attr.href


isActive : Page -> Route -> Bool
isActive currentPage linkRoute =
    case ( currentPage, linkRoute ) of
        ( Home, Route.Home ) ->
            True

        ( Login _, Route.Login ) ->
            True

        ( GameList, Route.GameList ) ->
            True

        _ ->
            False


titleFromString : String -> Title
titleFromString title =
    Title title
