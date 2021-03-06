-- Do not manually edit this file, it was auto-generated by Graphql
-- https://github.com/dillonkearns/graphqelm


module PokerApi.Query exposing (GameRequiredArguments, RoundRequiredArguments, UserRequiredArguments, currentUser, game, games, myGames, round, selection, user)

import Graphql.Field as Field exposing (Field)
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import PokerApi.InputObject
import PokerApi.Interface
import PokerApi.Object
import PokerApi.Scalar
import PokerApi.Union


{-| Select fields to build up a top-level query. The request can be sent with
functions from `Graphql.Http`.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) RootQuery
selection constructor =
    Object.selection constructor


{-| Gets the profile for the current user
-}
currentUser : SelectionSet decodesTo PokerApi.Object.User -> Field (Maybe decodesTo) RootQuery
currentUser object =
    Object.selectionField "currentUser" [] object (identity >> Decode.nullable)


type alias GameRequiredArguments =
    { id : PokerApi.Scalar.Id }


{-| Get a game
-}
game : GameRequiredArguments -> SelectionSet decodesTo PokerApi.Object.Game -> Field (Maybe decodesTo) RootQuery
game requiredArgs object =
    Object.selectionField "game" [ Argument.required "id" requiredArgs.id (\(PokerApi.Scalar.Id raw) -> Encode.string raw) ] object (identity >> Decode.nullable)


{-| Get all games
-}
games : SelectionSet decodesTo PokerApi.Object.Game -> Field (List decodesTo) RootQuery
games object =
    Object.selectionField "games" [] object (identity >> Decode.list)


{-| Get all games for the current user
-}
myGames : SelectionSet decodesTo PokerApi.Object.Game -> Field (List decodesTo) RootQuery
myGames object =
    Object.selectionField "myGames" [] object (identity >> Decode.list)


type alias RoundRequiredArguments =
    { id : PokerApi.Scalar.Id }


{-| Get a round
-}
round : RoundRequiredArguments -> SelectionSet decodesTo PokerApi.Object.Round -> Field (Maybe decodesTo) RootQuery
round requiredArgs object =
    Object.selectionField "round" [ Argument.required "id" requiredArgs.id (\(PokerApi.Scalar.Id raw) -> Encode.string raw) ] object (identity >> Decode.nullable)


type alias UserRequiredArguments =
    { id : PokerApi.Scalar.Id }


{-| Get a user
-}
user : UserRequiredArguments -> SelectionSet decodesTo PokerApi.Object.User -> Field (Maybe decodesTo) RootQuery
user requiredArgs object =
    Object.selectionField "user" [ Argument.required "id" requiredArgs.id (\(PokerApi.Scalar.Id raw) -> Encode.string raw) ] object (identity >> Decode.nullable)
