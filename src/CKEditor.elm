module CKEditor
    exposing
        ( ckeditor
        , config
        , content
        , onCKEditorChange
        , onCKEditorBlur
        , defaultConfig
        )

{-|


# HTML Element

@docs ckeditor


# Attributes

@docs config, content, onCKEditorChange, onCKEditorBlur


# Helpers

@docs defaultConfig

-}

import Html exposing (node, Html, Attribute)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Encode as Encode exposing (encode, Value)


{-| Render a CKEditor instance

    view model =
        ckeditor
            [ config defaultConfig
            , content model.content
            , onCKEditorChange CKEditorChanged
            , onCKEditorBlur CKEditorBlurred
            ]
            []

-}
ckeditor : List (Attribute msg) -> List (Html msg) -> Html msg
ckeditor =
    node "x-ckeditor"


{-| Config property of the CKEditor web component. Upon changing the config,
the CKEditor instance is reloaded to apply the changes.

    config <|
        Json.Encode.object
            [ ( "uiColor", JsonEncode.string "#AADC6E" ) ]

Available options are documented at
<http://docs.ckeditor.com/#!/api/CKEDITOR.config>

-}
config : Value -> Attribute msg
config =
    property "config"


{-| Content property of the CKEditor web component. This is an HTML string.

    content "<p>Hello CKEditor!</p>\n"

-}
content : String -> Attribute msg
content value =
    property "content" (Encode.string value)


{-| Event fired when the CKEditor content changed. This event will not
necessarily fire on every single input action.

    type Msg
        = CKEditorChanged String

    onCKEditorChange CKEditorChanged

-}
onCKEditorChange : (String -> msg) -> Attribute msg
onCKEditorChange msg =
    on "ckeditorchange" (Decode.map msg (Decode.field "detail" Decode.string))


{-| Event fired when blur the CKEditor.

    type Msg
        = onCKEditorBlurred String

    onCKEditorBlur onCKEditorBlurred

-}
onCKEditorBlur : (String -> msg) -> Attribute msg
onCKEditorBlur msg =
    on "ckeditorblur" (Decode.map msg (Decode.field "detail" Decode.string))


{-| Default CKEditor config, this is just an empty JSON object value
-}
defaultConfig : Value
defaultConfig =
    Encode.object [
        ("removePlugins", Encode.string "elementspath,image,form"),
        ("resize_enabled", Encode.bool False),
        ("toolbar", 
            Encode.list [
                Encode.list [
                    Encode.string "Maximize",
                    Encode.string "Format",
                    Encode.string "Bold",
                    Encode.string "TextColor",
                    Encode.string "Subscript",
                    Encode.string "Superscript"
                ]
            ]
        )
    ]

