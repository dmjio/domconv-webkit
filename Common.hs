module Common where

import Data.List
import Debug.Trace (trace)
import qualified Utils as U
import qualified IDLSyn as I
import qualified Language.Haskell.Syntax as H (Module(..))
import Data.Char (isSpace)
import SplitBounds (parts)

jsname' "DOMApplicationCache" = "ApplicationCache"
jsname' "DOMWindowCSS" = "CSS"
jsname' "DOMCoreException" = "DOMException"
jsname' "DOMFormData" = "FormData"
jsname' "DOMURL" = "URL"
jsname' "DOMSecurityPolicy" = "SecurityPolicy"
jsname' "DOMSelection" = "Selection"
jsname' "DOMWindow" = "Window"
jsname' "DOMMimeType" = "MimeType"
jsname' "DOMMimeTypeArray" = "MimeTypeArray"
jsname' "DOMPlugin" = "Plugin"
jsname' "DOMPluginArray" = "PluginArray"
jsname' "DOMPath" = "Path2D"
jsname' x = x

--jsname "CryptoKey" = "Key"
--jsname "CryptoKeyPair" = "KeyPair"
jsname "SubtleCrypto" = "WebKitSubtleCrypto"
jsname "DOMNamedFlowCollection" = "WebKitNamedFlowCollection"
jsname "MediaKeyError" = "WebKitMediaKeyError"
jsname "MediaKeyMessageEvent" = "WebKitMediaKeyMessageEvent"
jsname "MediaKeySession" = "WebKitMediaKeySession"
jsname "MediaKeys" = "WebKitMediaKeys"
jsname "MediaStream" = "webkitMediaStream"
jsname "RTCPeerConnection" = "webkitRTCPeerConnection"
--jsname "AudioContext" = "webkitAudioContext"
--jsname "OfflineAudioContext" = "webkitOfflineAudioContext"
jsname "PannerNode" = "webkitAudioPannerNode"
jsname "DataCue" = "WebKitDataCue"
jsname x = jsname' x

inWebKitGtk = (`elem` ["Attr", "AudioTrack", "AudioTrackList", "BarProp", "BatteryManager", "Blob",
                    "CDATASection", "Comment", "CSSRule", "CSSRuleList", "CSSStyleDeclaration",
                    "CSSStyleSheet", "CSSValue", "CharacterData", "Console", "Core", "Css",
                    "Attr", "ApplicationCache", "DOMImplementation", "MimeType", "MimeTypeArray",
                    "DOMNamedFlowCollection", "Plugin", "PluginArray", "Range", "Screen", "SecurityPolicy",
                    "Selection", "DOMSettableTokenList", "DOMStringList", "DOMTokenList",
                    "Window", "CSS", "Document", "DocumentFragment", "DocumentType",
                    "Element", "EntityReference", "Enums", "Event", "EventTarget", "EventTargetClosures", "Events", "File",
                    "FileList", "Geolocation", "HTMLAnchorElement", "HTMLAppletElement",
                    "HTMLAreaElement", "HTMLAudioElement", "HTMLBRElement", "HTMLBaseElement", "HTMLBaseFontElement",
                    "HTMLBodyElement", "HTMLButtonElement", "HTMLCanvasElement", "HTMLCollection",
                    "HTMLDListElement", "HTMLDetailsElement", "HTMLDirectoryElement",
                    "HTMLDivElement", "HTMLDocument", "HTMLElement", "HTMLEmbedElement",
                    "HTMLFieldSetElement", "HTMLFontElement", "HTMLFormElement", "HTMLFrameElement",
                    "HTMLFrameSetElement", "HTMLHRElement", "HTMLHeadElement", "HTMLHeadingElement",
                    "HTMLHtmlElement", "HTMLIFrameElement", "HTMLImageElement", "HTMLInputElement",
                    "HTMLKeygenElement", "HTMLLIElement", "HTMLLabelElement", "HTMLLegendElement",
                    "HTMLLinkElement", "HTMLMapElement", "HTMLMarqueeElement", "HTMLMediaElement",
                    "HTMLMenuElement", "HTMLMetaElement", "HTMLModElement", "HTMLOListElement",
                    "HTMLObjectElement", "HTMLOptGroupElement", "HTMLOptionElement",
                    "HTMLOptionsCollection", "HTMLParagraphElement", "HTMLParamElement",
                    "HTMLPreElement", "HTMLQuoteElement", "HTMLScriptElement", "HTMLSelectElement",
                    "HTMLStyleElement", "HTMLTableCaptionElement", "HTMLTableCellElement",
                    "HTMLTableColElement", "HTMLTableElement", "HTMLTableRowElement",
                    "HTMLTableSectionElement", "HTMLTextAreaElement", "HTMLTitleElement",
                    "HTMLUListElement", "HTMLVideoElement", "History", "Html", "KeyboardEvent",
                    "Location", "MediaError", "MediaList", "MediaQueryList", "MessagePort", "MouseEvent",
                    "NamedNodeMap", "Navigator", "Node", "NodeFilter",
                    "NodeIterator", "NodeList", "Offline", "Performance", "PerformanceNavigation", "PerformanceTiming", "ProcessingInstruction",
                    "Range", "Ranges", "Screen", "Storage", "StorageInfo", "StorageQuota", "StyleMedia",
                    "StyleSheet", "StyleSheetList", "Stylesheets", "Text", "TextTrack", "TextTrackCue", "TextTrackCueList", "TextTrackList", "TimeRanges", "Touch",
                    "Traversal", "TreeWalker", "UIEvent", "ValidityState", "VideoTrack", "VideoTrackList", "View", "WebKitAnimation",
                    "WebKitAnimationList", "WebKitNamedFlow", "WebKitPoint", "WheelEvent",
                    "XPathExpression", "XPathNSResolver", "XPathResult", "Xml", "Xpath"])

fixEventName "Window" "onblur" = "BlurEvent"
fixEventName "Window" "onfocus" = "FocusEvent"
fixEventName "Window" "onscroll" = "ScrollEvent"
fixEventName "Element" "onblur" = "BlurEvent"
fixEventName "Element" "onfocus" = "FocusEvent"
fixEventName "FileReader" "onabort" = "AbortEvent"
fixEventName "HTMLMediaElement" "onpause" = "PauseEvent"
fixEventName "HTMLMediaElement" "onplay" = "PlayEvent"
fixEventName "IDBTransaction" "onabort" = "AbortEvent"
fixEventName "MediaStream" "onaddtrack" = "AddTrackEvent"
fixEventName "MediaStream" "onremovetrack" = "RemoveTrackEvent"
fixEventName "Notification" "onshow" = "ShowEvent"
fixEventName "RTCDataChannel" "onclose" = "CloseEvent"
fixEventName "RTCPeerConnection" "onaddstream" = "AddStreamEvent"
fixEventName "RTCPeerConnection" "onremovestream" = "RemoveStreamEvent"
fixEventName "WebSocket" "onclose" = "CloseEvent"
fixEventName "XMLHttpRequest" "onabort" = "AbortEvent"
fixEventName _ ('o':'n':x) = fixEventName' x
fixEventName i x = error $ "Event that does not start with 'On' : " ++ x ++ " in " ++ i

fixEventName' ('w':'e':'b':'k':'i':'t':x) = "WebKit" ++ fixEventName' x
fixEventName' "addstream" = "AddStream"
fixEventName' "addtrack" = "AddTrack"
fixEventName' "audioprocess" = "AudioProcess"
fixEventName' "afterprint" = "AfterPrint"
fixEventName' "beforecopy" = "BeforeCopy"
fixEventName' "beforecut" = "BeforeCut"
fixEventName' "beforepaste" = "BeforePaste"
fixEventName' "beforeunload" = "BeforeUnload"
fixEventName' "canplay" = "CanPlay"
fixEventName' "canplaythrough" = "CanPlayThrough"
fixEventName' "chargingchange" = "ChargingChange"
fixEventName' "chargingtimechange" = "ChargingTimeChange"
fixEventName' "contextmenu" = "ContextMenu"
fixEventName' "cuechange" = "CueChange"
fixEventName' "currentplaybacktargetiswirelesschanged" = "CurrentPlaybackTargetIsWirelessChanged"
fixEventName' "datachannel" = "DataChannel"
fixEventName' "dblclick" = "DblClick"
fixEventName' "devicemotion" = "DeviceMotion"
fixEventName' "deviceorientation" = "DeviceOrientation"
fixEventName' "deviceproximity" = "DeviceProximity"
fixEventName' "dischargingtimechange" = "DischargingTimeChange"
fixEventName' "durationchange" = "DurationChange"
fixEventName' "fullscreenchange" = "FullscreenChange"
fixEventName' "fullscreenerror" = "FullscreenError"
fixEventName' "gesturechange" = "GestureChange"
fixEventName' "gestureend" = "GestureEnd"
fixEventName' "gesturestart" = "GestureStart"
fixEventName' "hashchange" = "HashChange"
fixEventName' "icecandidate" = "IceCandidate"
fixEventName' "iceconnectionstatechange" = "IceConnectionStateChange"
fixEventName' "keyadded" = "KeyAdded"
fixEventName' "keydown" = "KeyDown"
fixEventName' "keyerror" = "KeyError"
fixEventName' "keymessage" = "KeyMessage"
fixEventName' "keypress" = "KeyPress"
fixEventName' "keyup" = "KeyUp"
fixEventName' "levelchange" = "LevelChange"
fixEventName' "loadeddata" = "LoadedData"
fixEventName' "loadedmetadata" = "LoadedMetadata"
fixEventName' "loadend" = "LoadEnd"
fixEventName' "loadingdone" = "LoadingDone"
fixEventName' "loadstart" = "LoadStart"
fixEventName' "needkey" = "NeedKey"
fixEventName' "negotiationneeded" = "NegotiationNeeded"
fixEventName' "noupdate" = "NoUpdate"
fixEventName' "orientationchange" = "OrientationChange"
fixEventName' "overconstrained" = "OverConstrained"
fixEventName' "pagehide" = "PageHide"
fixEventName' "pageshow" = "PageShow"
fixEventName' "playbacktargetavailabilitychanged" = "PlaybackTargetAvailabilityChanged"
fixEventName' "presentationmodechanged" = "PresentationModeChanged"
fixEventName' "popstate" = "PopState"
fixEventName' "ratechange" = "RateChange"
fixEventName' "readystatechange" = "ReadyStateChange"
fixEventName' "removestream" = "RemoveStream"
fixEventName' "removetrack" = "RemoveTrack"
fixEventName' "resourcetimingbufferfull" = "ResourceTimingBufferFull"
fixEventName' "selectstart" = "SelectStart"
fixEventName' "signalingstatechange" = "SignalingStateChange"
fixEventName' "timeupdate" = "TimeUpdate"
fixEventName' "tonechange" = "ToneChange"
fixEventName' "transitionend" = "TransitionEnd"
fixEventName' "updateready" = "UpdateReady"
fixEventName' "upgradeneeded" = "UpgradeNeeded"
fixEventName' "versionchange" = "VersionChange"
fixEventName' "volumechange" = "VolumeChange"
fixEventName' "willrevealbottom" = "WillRevealBottom"
fixEventName' "willrevealleft" = "WillRevealLeft"
fixEventName' "willrevealright" = "WillRevealRight"
fixEventName' "willrevealtop" = "WillRevealTop"
fixEventName' ('a':'n':'i':'m':'a':'t':'i':'o':'n':x) = 'A':'n':'i':'m':'a':'t':'i':'o':'n':U.toUpperHead x
fixEventName' ('m':'o':'u':'s':'e':x) = 'M':'o':'u':'s':'e':U.toUpperHead x
fixEventName' ('t':'o':'u':'c':'h':x) = 'T':'o':'u':'c':'h':U.toUpperHead x
fixEventName' ('d':'r':'a':'g':x) = 'D':'r':'a':'g':U.toUpperHead x
-- fixEventName' x = trace ("fixEventName' \""++x++"\" = \"" ++ U.toUpperHead x ++ "\"") x
fixEventName' x = U.toUpperHead x

eventType "XMLHttpRequest"       "onabort"    = "XMLHttpRequestProgressEvent"
eventType "XMLHttpRequestUpload" "onabort"    = "XMLHttpRequestProgressEvent"
eventType i "onabort" | "IDB" `isPrefixOf` i  = "Event"
                      | otherwise             = "UIEvent"
eventType _ "onafterprint"                    = "Event"
eventType _ "onanimationstart"                = "AnimationEvent"
eventType _ "onanimationiteration"            = "AnimationEvent"
eventType _ "onanimationend"                  = "AnimationEvent"
eventType _ "onwebkitanimationend"            = "AnimationEvent"
eventType _ "onwebkitanimationiteration"      = "AnimationEvent"
eventType _ "onwebkitanimationstart"          = "AnimationEvent"
eventType _ "onaudioprocess" = "AudioProcessingEvent"
eventType _ "onbeforeprint" = "Event"
eventType _ "onbeforeunload" = "BeforeUnloadEvent"
eventType _ "onbeginEvent" = "TimeEvent"
eventType _ "onblocked" = "IDBVersionChangeEvent"
eventType _ "onblur" = "FocusEvent"
eventType _ "oncached" = "Event"
eventType _ "oncanplay" = "Event"
eventType _ "oncanplaythrough" = "Event"
eventType _ "onchange" = "Event"
eventType _ "onchargingchange" = "Event"
eventType _ "onchargingtimechange" = "Event"
eventType _ "onchecking" = "Event"
eventType _ "onclick" = "MouseEvent"
eventType _ "onclose" = "CloseEvent"
eventType _ "oncompassneedscalibration" = "Unimplemented"
eventType i "oncomplete" | "IDB" `isPrefixOf` i  = "Event"
                         | otherwise = "OfflineAudioCompletionEvent"
eventType _ "oncompositionend" = "CompositionEvent"
eventType _ "oncompositionstart" = "CompositionEvent"
eventType _ "oncompositionupdate" = "CompositionEvent"
eventType _ "oncontextmenu" = "MouseEvent"
eventType _ "oncopy" = "Event" -- Mozilla has ClipboardEvent but clipboardData is just on Event in webkit
eventType _ "oncut" = "Event" -- Mozilla has ClipboardEvent but clipboardData is just on Event in webkit
eventType _ "ondblclick" = "MouseEvent"
eventType _ "ondevicelight" = "DeviceLightEvent"
eventType _ "ondevicemotion" = "DeviceMotionEvent"
eventType _ "ondeviceorientation" = "DeviceOrientationEvent"
eventType _ "onwebkitdeviceproximity" = "DeviceProximityEvent"
eventType _ "ondeviceproximity" = "DeviceProximityEvent"
eventType _ "ondischargingtimechange" = "Event"
eventType _ "onDOMContentLoaded" = "Event"
eventType _ "ondownloading" = "Event"
eventType _ "ondrag" = "MouseEvent" -- Mozilla has a DragEvent interface
eventType _ "ondragend" = "MouseEvent" -- Mozilla has a DragEvent interface
eventType _ "ondragenter" = "MouseEvent" -- Mozilla has a DragEvent interface
eventType _ "ondragleave" = "MouseEvent" -- Mozilla has a DragEvent interface
eventType _ "ondragover" = "MouseEvent" -- Mozilla has a DragEvent interface
eventType _ "ondragstart" = "MouseEvent" -- Mozilla has a DragEvent interface
eventType _ "ondrop" = "MouseEvent" -- Mozilla has a DragEvent interface
eventType _ "ondurationchange" = "Event"
eventType _ "onemptied" = "Event"
eventType _ "onended" = "Event"
eventType _ "onendEvent" = "TimeEvent"
eventType "Document"             "onerror"    = "UIEvent"
eventType "Element"              "onerror"    = "UIEvent"
eventType "XMLHttpRequest"       "onerror"    = "XMLHttpRequestProgressEvent"
eventType "XMLHttpRequestUpload" "onerror"    = "XMLHttpRequestProgressEvent"
eventType i "onerror" | "IDB" `isPrefixOf` i  = "Event"
                      | otherwise             = "UIEvent"
eventType _ "onfocus" = "FocusEvent"
eventType _ "onfocusinUnimplemented" = "see"
eventType _ "onfocusoutUnimplemented" = "see"
eventType _ "onfullscreenchange" = "Event"
eventType _ "onfullscreenerror" = "Event"
eventType _ "ongamepadconnected" = "GamepadEvent"
eventType _ "ongamepaddisconnected" = "GamepadEvent"
eventType _ "ongesturestart" = "UIEvent"
eventType _ "ongesturechange" = "UIEvent"
eventType _ "ongestureend" = "UIEvent"
eventType _ "onhashchange" = "HashChangeEvent"
eventType _ "oninput" = "Event"
eventType _ "oninvalid" = "Event"
eventType _ "onkeydown" = "KeyboardEvent"
eventType _ "onkeypress" = "KeyboardEvent"
eventType _ "onkeyup" = "KeyboardEvent"
eventType _ "onlanguagechange" = "Event"
eventType _ "onThe" = "definition"
eventType _ "onlevelchange" = "Event"
eventType "XMLHttpRequest"       "onload" = "XMLHttpRequestProgressEvent"
eventType "XMLHttpRequestUpload" "onload" = "XMLHttpRequestProgressEvent"
eventType _                      "onload" = "UIEvent"
eventType _ "onloadeddata" = "Event"
eventType _ "onloadedmetadata" = "Event"
eventType _ "onloadend" = "ProgressEvent"
eventType _ "onloadstart" = "ProgressEvent"
eventType _ "onmessage" = "MessageEvent"
eventType _ "onmousedown" = "MouseEvent"
eventType _ "onmouseenter" = "MouseEvent"
eventType _ "onmouseleave" = "MouseEvent"
eventType _ "onmousemove" = "MouseEvent"
eventType _ "onmouseout" = "MouseEvent"
eventType _ "onmouseover" = "MouseEvent"
eventType _ "onmouseup" = "MouseEvent"
eventType _ "onnoupdate" = "Event"
eventType _ "onobsolete" = "Event"
eventType _ "onoffline" = "Event"
eventType _ "ononline" = "Event"
eventType _ "onopen" = "Event"
eventType _ "onorientationchange" = "Event"
eventType _ "onpagehide" = "PageTransitionEvent"
eventType _ "onpageshow" = "PageTransitionEvent"
eventType _ "onpaste" = "Event" -- Mozilla has ClipboardEvent but clipboardData is just on Event in webkit
eventType _ "onpause" = "Event"
eventType _ "onpointerlockchange" = "Event"
eventType _ "onpointerlockerror" = "Event"
eventType _ "onplay" = "Event"
eventType _ "onplaying" = "Event"
eventType _ "onpopstate" = "PopStateEvent"
eventType "XMLHttpRequest"       "onprogress" = "XMLHttpRequestProgressEvent"
eventType "XMLHttpRequestUpload" "onprogress" = "XMLHttpRequestProgressEvent"
eventType _                      "onprogress" = "ProgressEvent"
eventType _ "onratechange" = "Event"
eventType _ "onreadystatechange" = "Event"
eventType _ "onrepeatEvent" = "TimeEvent"
eventType _ "onreset" = "Event"
eventType _ "onresize" = "UIEvent"
eventType _ "onscroll" = "UIEvent"
eventType _ "onseeked" = "Event"
eventType _ "onseeking" = "Event"
eventType _ "onselect" = "UIEvent"
eventType _ "onshow" = "MouseEvent"
eventType _ "onstalled" = "Event"
eventType _ "onstorage" = "StorageEvent"
eventType _ "onsubmit" = "Event"
eventType _ "onsuccess" = "Event"
eventType _ "onsuspend" = "Event"
eventType _ "onSVGAbort" = "SVGEvent"
eventType _ "onSVGError" = "SVGEvent"
eventType _ "onSVGLoad" = "SVGEvent"
eventType _ "onSVGResize" = "SVGEvent"
eventType _ "onSVGScroll" = "SVGEvent"
eventType _ "onSVGUnload" = "SVGEvent"
eventType _ "onSVGZoom" = "SVGZoomEvent"
eventType _ "ontimeout" = "ProgressEvent"
eventType _ "ontimeupdate" = "Event"
eventType _ "ontouchcancel" = "TouchEvent"
eventType _ "ontouchend" = "TouchEvent"
eventType _ "ontouchenter" = "TouchEvent"
eventType _ "ontouchleave" = "TouchEvent"
eventType _ "ontouchmove" = "TouchEvent"
eventType _ "ontouchstart" = "TouchEvent"
eventType _ "onwebkittransitionend" = "TransitionEvent"
eventType _ "ontransitionend" = "TransitionEvent"
eventType _ "onunload" = "UIEvent"
eventType _ "onupdateready" = "Event"
eventType _ "onupgradeneeded" = "IDBVersionChangeEvent"
eventType _ "onuserproximity" = "SensorEvent"
eventType _ "onversionchange" = "IDBVersionChangeEvent"
eventType _ "onvisibilitychange" = "Event"
eventType _ "onvolumechange" = "Event"
eventType _ "onwaiting" = "Event"
eventType _ "onwheel" = "WheelEvent"
eventType _ "onaddtrack" = "Event"
eventType _ "onremovetrack" = "Event"
eventType _ "onmousewheel" = "MouseEvent"
eventType _ "onsearch" = "Event"
eventType _ "onwebkitwillrevealbottom" = "Event"
eventType _ "onwebkitwillrevealleft" = "Event"
eventType _ "onwebkitwillrevealright" = "Event"
eventType _ "onwebkitwillrevealtop" = "Event"
eventType _ "onbeforecut" = "Event"
eventType _ "onbeforecopy" = "Event"
eventType _ "onbeforepaste" = "Event"
eventType _ "onselectstart" = "Event"
eventType _ "onwebkitfullscreenchange" = "Event"
eventType _ "onwebkitfullscreenerror" = "Event"
eventType _ "onloading" = "Event"
eventType _ "onloadingdone" = "Event"
eventType _ "onwebkitkeyadded" = "Event"
eventType _ "onwebkitkeyerror" = "Event"
eventType _ "onwebkitkeymessage" = "Event"
eventType _ "onwebkitneedkey" = "Event"
eventType _ "onwebkitcurrentplaybacktargetiswirelesschanged" = "Event"
eventType _ "onwebkitplaybacktargetavailabilitychanged" = "Event"
eventType _ "onactive" = "Event"
eventType _ "oninactive" = "Event"
eventType _ "onmute" = "Event"
eventType _ "onunmute" = "Event"
eventType _ "onstarted" = "Event"
eventType _ "onoverconstrained" = "Event"
eventType _ "onwebkitresourcetimingbufferfull" = "Event"
eventType _ "ontonechange" = "Event"
eventType _ "onnegotiationneeded" = "Event"
eventType _ "onicecandidate" = "RTCIceCandidateEvent"
eventType _ "onsignalingstatechange" = "Event"
eventType _ "onaddstream" = "Event"
eventType _ "onremovestream" = "Event"
eventType _ "oniceconnectionstatechange" = "Event"
eventType _ "ondatachannel" = "Event"
eventType _ "onconnect" = "Event"
eventType _ "onstart" = "Event"
eventType _ "onend" = "Event"
eventType _ "onresume" = "Event"
eventType _ "onmark" = "Event"
eventType _ "onboundary" = "Event"
eventType _ "oncuechange" = "Event"
eventType _ "onenter" = "Event"
eventType _ "onexit" = "Event"
eventType _ "onwebkitpresentationmodechanged" = "Event"
eventType i e                                 = trace ("Please add:\neventType _ \"" ++ e ++ "\" = \"Event\"") e

paramName (I.Param _ (I.Id p) _ _ _) = paramName' p

paramName' "data"    = "data'"
paramName' "pattern" = "pattern'"
paramName' "type"    = "type'"
paramName' "where"   = "where'"
paramName' "family"  = "family'"
paramName' p = p

disambiguate "WebGLRenderingContextBase" a b = disambiguate "WebGLRenderingContext" a b
disambiguate "CSS" "supports" [_, _] = "2"
disambiguate "HTMLInputElement" "setRangeText" [_, _, _, _] = "4"
disambiguate "HTMLTextAreaElement" "setRangeText" [_, _, _, _] = "4"
disambiguate "Navigator" "vibrate" [I.Param _ _ (I.TySequence _ _) _ _] = "Pattern"
disambiguate "AudioContext" "createBuffer" [_, _] = "FromArrayBuffer"
disambiguate "AudioNode" "connect" [I.Param _ _ (I.TyOptional (I.TyName "AudioParam" _)) _ _, _] = "Param"
disambiguate "CanvasRenderingContext2D" name (I.Param _ _ (I.TyName "Path2D" _) _ _:_) | name `elem` canvasPathFunctionNames = "Path"
disambiguate "CanvasRenderingContext2D" "setStrokeColor" (I.Param _ (I.Id "grayLevel") _ _ _:_) = "Gray"
disambiguate "CanvasRenderingContext2D" "setStrokeColor" (I.Param _ (I.Id "r") _ _ _:_) = "RGB"
disambiguate "CanvasRenderingContext2D" "setStrokeColor" (I.Param _ (I.Id "c") _ _ _:_) = "CYMK"
disambiguate "CanvasRenderingContext2D" "setFillColor" (I.Param _ (I.Id "grayLevel") _ _ _:_) = "Gray"
disambiguate "CanvasRenderingContext2D" "setFillColor" (I.Param _ (I.Id "r") _ _ _:_) = "RGB"
disambiguate "CanvasRenderingContext2D" "setFillColor" (I.Param _ (I.Id "c") _ _ _:_) = "CYMK"
disambiguate "CanvasRenderingContext2D" "setShadow" (_:_:_:I.Param _ (I.Id "grayLevel") _ _ _:_) = "Gray"
disambiguate "CanvasRenderingContext2D" "setShadow" (_:_:_:I.Param _ (I.Id "r") _ _ _:_) = "RGB"
disambiguate "CanvasRenderingContext2D" "setShadow" (_:_:_:I.Param _ (I.Id "c") _ _ _:_) = "CYMK"
disambiguate "CanvasRenderingContext2D" "drawImage" [I.Param _ (I.Id "canvas") _ _ _,_,_] = "FromCanvas"
disambiguate "CanvasRenderingContext2D" "drawImage" [I.Param _ (I.Id "canvas") _ _ _,_,_,_,_] = "FromCanvasScaled"
disambiguate "CanvasRenderingContext2D" "drawImage" [I.Param _ (I.Id "canvas") _ _ _,_,_,_,_,_,_,_,_] = "FromCanvasPart"
disambiguate "CanvasRenderingContext2D" "drawImage" [I.Param _ (I.Id "video") _ _ _,_,_] = "FromVideo"
disambiguate "CanvasRenderingContext2D" "drawImage" [I.Param _ (I.Id "video") _ _ _,_,_,_,_] = "FromVideoScaled"
disambiguate "CanvasRenderingContext2D" "drawImage" [I.Param _ (I.Id "video") _ _ _,_,_,_,_,_,_,_,_] = "FromVideoPart"
disambiguate "CanvasRenderingContext2D" "drawImage" [_,_,_] = ""
disambiguate "CanvasRenderingContext2D" "drawImage" [_,_,_,_,_] = "Scaled"
disambiguate "CanvasRenderingContext2D" "drawImage" [_,_,_,_,_,_,_,_,_] = "Part"
disambiguate "CanvasRenderingContext2D" "putImageData" [_,_,_,_,_,_,_] = "Dirty"
disambiguate "CanvasRenderingContext2D" "webkitPutImageDataHD" [_,_,_,_,_,_,_] = "Dirty"
disambiguate "CanvasRenderingContext2D" "createPattern" [I.Param _ (I.Id "canvas") _ _ _,_] = "FromCanvas"
disambiguate "CanvasRenderingContext2D" "createImageData" [_,_] = "Size"
disambiguate "CanvasRenderingContext2D" "setLineWidth" _ = "Function"
disambiguate "CanvasRenderingContext2D" "setLineCap" _ = "Function"
disambiguate "CanvasRenderingContext2D" "setLineJoin" _ = "Function"
disambiguate "CanvasRenderingContext2D" "setMiterLimit" _ = "Function"
disambiguate "DataTransferItemList" "add" [_] = "File"
disambiguate "MediaControlsHost" "sortedTrackListForMenu" [I.Param _ _ (I.TyName "AudioTrackList" _) _ _] = "Audio"
disambiguate "MediaControlsHost" "displayNameForTrack" [I.Param _ _ (I.TyName "AudioTrack" _) _ _] = "Audio"
disambiguate "RTCDataChannel" "send" [I.Param _ _ (I.TyName "ArrayBufferView" _) _ _] = "View"
disambiguate "RTCDataChannel" "send" [I.Param _ _ (I.TyName "Blob" _) _ _] = "Blob"
disambiguate "RTCDataChannel" "send" [I.Param _ _ (I.TyName "DOMString" _) _ _] = "String"
disambiguate "WebSocket" "send" [I.Param _ _ (I.TyName "ArrayBufferView" _) _ _] = "View"
disambiguate "WebSocket" "send" [I.Param _ _ (I.TyName "Blob" _) _ _] = "Blob"
disambiguate "WebSocket" "send" [I.Param _ _ (I.TyName "DOMString" _) _ _] = "String"
disambiguate "SourceBuffer" "appendBuffer" [I.Param _ _ (I.TyName "ArrayBufferView" _) _ _] = "View"
disambiguate "WebGL2RenderingContext" "getBufferSubData" [_, _, I.Param _ _ (I.TyName "ArrayBufferView" _) _ _] = "View"
disambiguate "WebGL2RenderingContext" "texSubImage3D" [_, _, _, _, _, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "ArrayBufferView" _)) _ _] = "View"
disambiguate "WebGL2RenderingContext" "texSubImage3D" [_, _, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "ImageData" _)) _ _] = "Data"
disambiguate "WebGL2RenderingContext" "texSubImage3D" [_, _, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "HTMLCanvasElement" _)) _ _] = "Canvas"
disambiguate "WebGL2RenderingContext" "texSubImage3D" [_, _, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "HTMLVideoElement" _)) _ _] = "Video"
disambiguate "WebGLRenderingContext" "bufferData" [_, I.Param _ _ (I.TyOptional (I.TyName "ArrayBufferView" _)) _ _, _] = "View"
disambiguate "WebGLRenderingContext" "bufferData" [_, I.Param _ _ (I.TyName "GLsizeiptr" _) _ _, _] = "Ptr"
disambiguate "WebGLRenderingContext" "bufferSubData" [_, _, I.Param _ _ (I.TyOptional (I.TyName "ArrayBufferView" _)) _ _] = "View"
disambiguate "WebGLRenderingContext" "texImage2D" [_, _, _, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "ArrayBufferView" _)) _ _] = "View"
disambiguate "WebGLRenderingContext" "texImage2D" [_, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "ImageData" _)) _ _] = "Data"
disambiguate "WebGLRenderingContext" "texImage2D" [_, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "HTMLCanvasElement" _)) _ _] = "Canvas"
disambiguate "WebGLRenderingContext" "texImage2D" [_, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "HTMLVideoElement" _)) _ _] = "Video"
disambiguate "WebGLRenderingContext" "texSubImage2D" [_, _, _, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "ArrayBufferView" _)) _ _] = "View"
disambiguate "WebGLRenderingContext" "texSubImage2D" [_, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "ImageData" _)) _ _] = "Data"
disambiguate "WebGLRenderingContext" "texSubImage2D" [_, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "HTMLCanvasElement" _)) _ _] = "Canvas"
disambiguate "WebGLRenderingContext" "texSubImage2D" [_, _, _, _, _, _, I.Param _ _ (I.TyOptional (I.TyName "HTMLVideoElement" _)) _ _] = "Video"
disambiguate "URL" "createObjectURL" [I.Param _ _ (I.TyOptional (I.TyName "MediaSource" _)) _ _] = "Source"
disambiguate "URL" "createObjectURL" [I.Param _ _ (I.TyOptional (I.TyName "MediaStream" _)) _ _] = "Stream"
disambiguate "IDBDatabase" "transaction" [I.Param _ (I.Id "storeNames") _ _ _, _] = "'"
disambiguate "IDBIndex" "openCursor" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _, _] = "Range"
disambiguate "IDBIndex" "openKeyCursor" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _, _] = "Range"
disambiguate "IDBIndex" "get" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _] = "Range"
disambiguate "IDBIndex" "getKey" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _] = "Range"
disambiguate "IDBIndex" "count" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _] = "Range"
disambiguate "IDBObjectStore" "delete" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _] = "Range"
disambiguate "IDBObjectStore" "get" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _] = "Range"
disambiguate "IDBObjectStore" "openCursor" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _, _] = "Range"
disambiguate "IDBObjectStore" "createIndex" [_, I.Param _ _ (I.TySequence _ _) _ _, _] = "'"
disambiguate "IDBObjectStore" "count" [I.Param _ _ (I.TyOptional (I.TyName "IDBKeyRange" _)) _ _] = "Range"
disambiguate "HTMLOptionsCollection" "add" [_, I.Param _ (I.Id "before") _ _ _] = "Before"
disambiguate "HTMLSelectElement" "add" [_, I.Param _ (I.Id "before") _ _ _] = "Before"
disambiguate "KeyboardEvent" "initKeyboardEvent" [_,_,_,_,_,_,_,_,_,_] = "'"
disambiguate _ name _ = ""

canvasPathFunctionNames = [
    "fill",
    "stroke",
    "clip",
    "isPointInPath",
    "isPointInStroke",
    "drawFocusIfNeeded"]

-- | Retrieve a module name as a string from Module
modName :: H.Module -> String
modName m = read $ drop 1 $ dropWhile (not . isSpace) (show m)

-- | Get a module namespace (all elements of name separated with dots except
-- the last one)
modNS :: String -> String
modNS mn = intercalate "." . reverse . drop 1 . reverse $ parts (== '.') mn

webkitTypeGuard "DOMNamedFlowCollection" = "webkitgtk-2.2"
webkitTypeGuard "SecurityPolicy" =  "webkitgtk-1.10"
webkitTypeGuard "WindowCSS" = "webkitgtk-2.2"
webkitTypeGuard "KeyboardEvent" = "webkitgtk-2.2"
webkitTypeGuard "StorageInfo" = "webkitgtk-1.10"
webkitTypeGuard "AudioTrack" = "webkitgtk-2.2"
webkitTypeGuard "AudioTrackList" = "webkitgtk-2.2"
webkitTypeGuard "BarProp" = "webkitgtk-2.2"
webkitTypeGuard "BatteryManager" = "webkitgtk-2.2"
webkitTypeGuard "CSS" = "webkitgtk-2.2"
webkitTypeGuard "Performance" = "webkitgtk-2.2"
webkitTypeGuard "PerformanceNavigation" = "webkitgtk-2.2"
webkitTypeGuard "PerformanceTiming" = "webkitgtk-2.2"
webkitTypeGuard "StorageQuota" = "webkitgtk-2.2"
webkitTypeGuard "TextTrack" = "webkitgtk-2.2"
webkitTypeGuard "TextTrackCue" = "webkitgtk-2.2"
webkitTypeGuard "TextTrackCueList" = "webkitgtk-2.2"
webkitTypeGuard "TextTrackList" = "webkitgtk-2.2"
webkitTypeGuard "Touch" = "webkitgtk-2.4"
webkitTypeGuard "VideoTrack" = "webkitgtk-2.2"
webkitTypeGuard "VideoTrackList" = "webkitgtk-2.2"
webkitTypeGuard "WheelEvent" = "webkitgtk-2.4"
webkitTypeGuard _ = "webkit-dom"
