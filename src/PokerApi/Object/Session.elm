-- Do not manually edit this file, it was auto-generated by Graphql
-- https://github.com/dillonkearns/graphqelm


module PokerApi.Object.Session exposing (selection, token)

import Graphql.Field as Field exposing (Field)
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import PokerApi.InputObject
import PokerApi.Interface
import PokerApi.Object
import PokerApi.Scalar
import PokerApi.Union


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) PokerApi.Object.Session
selection constructor =
    Object.selection constructor


token : Field String PokerApi.Object.Session
token =
    Object.fieldDecoder "token" [] Decode.string
