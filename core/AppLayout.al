space $AppLayout {
    init($res, $useStringLanguage => true, $StringLanguageLanguage => "en-GB", $StringLanguageFallbackLanguage => "en-GB") {
        me: $layout => $res;
        me: $useStringLanguage => $useStringLanguage;

        if ($useStringLanguage) {
            if (type($StringLanguageLanguage) = "string") {
                me: $translator => create $StringLanguage($StringLanguageLanguage, $StringLanguageFallbackLanguage);
            } else {
                error {
                    $name key> "LayoutStringLanguageError",
                    $message key> "StringLanguage is requested, but parameter " + $stringesc + "StringLanguageLanguage" + $stringesc + " is not defined."
                };
            }
        }
    }

    $draw() {
        $appSelector("body"): $html("");

        define $useStringLanguage => me: $useStringLanguage;
        define $translator => me: $translator;

        $appSelector("body"): $css($res["res-style"]);

        to $exploreLayout($childLayout, $path) {
            for (define $key partof $childLayout) {
                if (type($childLayout[$key]) = "space" & $childLayout[$key] !:= none) {
                    if ($childLayout[$key]["element"] != undefined) {
                        if ($appSelector($path + " > ." + $childLayout[$key]["element"]): length = 0) {

                            test {
                                if ($res["core-ui-" + $childLayout[$key]["element"]]["html"] = undefined) {
                                    error none;
                                }

                                $appSelector($path): $append("<" + $res["core-ui-" + $childLayout[$key]["element"]]["html"] + " id='" + $key + "'></div>");

                                define $translateDefaultValue => true;
                                define $translateTagAttributes => true;

                                test {
                                    if ($res["core-ui-" + $childLayout[$key]["element"]]["translateDefaultValue"] != undefined) {
                                        $translateDefaultValue => $res["core-ui-" + $childLayout[$key]["element"]]["translateDefaultValue"];
                                    }
                                } ignore;

                                test {
                                    if ($res["core-ui-" + $childLayout[$key]["element"]]["translateTagAttributes"] != undefined) {
                                        $translateTagAttributes => $res["core-ui-" + $childLayout[$key]["element"]]["translateTagAttributes"];
                                    }
                                } ignore;

                                if ($useStringLanguage & $translateDefaultValue) {
                                    define $defaultValue => $translator: $read($res["core-ui-" + $childLayout[$key]["element"]]["defaultValue"]);
                                } else {
                                    define $defaultValue => $res["core-ui-" + $childLayout[$key]["element"]]["defaultValue"];
                                }

                                define $valueAttribute => $res["core-ui-" + $childLayout[$key]["element"]]["valueAttribute"];
                                define $defaultStyle => $res["core-ui-" + $childLayout[$key]["element"]]["defaultStyle"];
                                define $actionStyle => $res["core-ui-" + $childLayout[$key]["element"]]["actionStyle"];
                                define $defaultAttributes => $res["core-ui-" + $childLayout[$key]["element"]]["defaultAttributes"];
                                define $styleAttributes => $res["core-ui-" + $childLayout[$key]["element"]]["styleAttributes"];
                                define $tagAttributes => $res["core-ui-" + $childLayout[$key]["element"]]["tagAttributes"];
                                define $childLayoutProperties => $childLayout[$key];
                                define $selection => $path + " > #" + $key;

                                if (type($defaultValue) = "string") {
                                    if (type($valueAttribute) = "string") {
                                        $appSelector($path + " > #" + $key): $attr($valueAttribute, $defaultValue);
                                    } else {
                                        $appSelector($path + " > #" + $key): $text($defaultValue);
                                    }
                                }

                                test {
                                    $appSelector($selection): $css($defaultStyle);
                                } ignore;

                                test {
                                    keys($actionStyle): each(to($key) {
                                        define $actionEvent => $actionStyle[$key];
                                        define $targetSelection => $selection;

                                        if ($key = "hoverIn") {
                                            $appSelector($selection): $mouseenter(to($event) {
                                                $appSelector($targetSelection): $css($actionEvent);
                                            });
                                        } elif ($key = "hoverOut") {
                                            $appSelector($selection): $mouseleave(to($event) {
                                                $appSelector($targetSelection): $css($actionEvent);
                                            });
                                        }
                                    });
                                } ignore;

                                test {
                                    keys($defaultAttributes): each(to($key) {
                                        if ($useStringLanguage & $translateTagAttributes) {
                                            $appSelector($selection): $attr($key, $translator: $read($defaultAttributes[$key]));
                                        } else {
                                            $appSelector($selection): $attr($key, $defaultAttributes[$key]);
                                        }
                                    });
                                } ignore;

                                keys($childLayoutProperties): each(to($key) {
                                    if ($key != "element") {
                                        if ($key = "text") {
                                            if (type($valueAttribute) = "string") {
                                                if ($useStringLanguage) {
                                                    $appSelector($selection): $attr($valueAttribute, $translator: $read($childLayoutProperties[$key]));
                                                } else {
                                                    $appSelector($selection): $attr($valueAttribute, $childLayoutProperties[$key]);
                                                }
                                            } else {
                                                if ($useStringLanguage) {
                                                    $appSelector($selection): $text($translator: $read($childLayoutProperties[$key]));
                                                } else {
                                                    $appSelector($selection): $text($childLayoutProperties[$key]);
                                                }
                                            }
                                        }

                                        test {
                                            $appSelector($selection): $css($styleAttributes[$key], $childLayoutProperties[$key]);
                                        } ignore;

                                        test {
                                            if ($useStringLanguage & $translateTagAttributes) {
                                                $appSelector($selection): $attr($tagAttributes[$key], $translator: $read($childLayoutProperties[$key]));
                                            } else {
                                                $appSelector($selection): $attr($tagAttributes[$key], $childLayoutProperties[$key]);
                                            }
                                        } ignore;
                                    }
                                });    
                            } catch ($error) {
                                error $error; #({
                                    $name key> "LayoutError",
                                    $message key> "Layout html " + $stringesc + $childLayout[$key]["element"] + $stringesc + " is undefined or is improperly defined in Cobalt."
                                });
                            }
                        }

                        $exploreLayout($childLayout[$key], $path + " > #" + $key);
                    } else {
                        $exploreLayout($childLayout[$key], $path);
                    }
                }
            }
        }

        $exploreLayout(me: $layout, "body");
    }
}