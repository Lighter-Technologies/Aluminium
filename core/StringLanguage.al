space $StringLanguage {
    init($language, $fallbackLanguage => "en-GB") {
        me: $language => $language;
        me: $fallbackLanguage => $fallbackLanguage;

        test {
            if ($res["strings-" + me: $language]["format"]["rtl"] = true) {
                $appSelector("html"): $attr("dir", "rtl");
            } else {
                $appSelector("html"): $attr("dir", "ltr");
            }
        } catch ($error) {
            if ($res["strings-" + me: $fallbackLanguage]["format"]["rtl"] = true) {
                $appSelector("html"): $attr("dir", "rtl");
            } else {
                $appSelector("html"): $attr("dir", "ltr");
            }
        }
    }

    $read($entry, $vars => {}) {
        test {
            if (type($res["strings-" + me: $language]["strings"][$entry]) = "string") {
                define $translated => $res["strings-" + me: $language]["strings"][$entry];
                define $language => me: $language;

                keys($vars): each(to($key) {
                    $translated => $translated: replace("$" + $key, $vars[$key]: localeNumeralBy($language));
                });

                return $translated;
            } else {
                return $entry;
            }
        } catch ($error) {
            if (type($res["strings-" + me: $fallbackLanguage]["strings"][$entry]) = "string") {
                define $translated => $res["strings-" + me: $fallbackLanguage]["strings"][$entry];
                define $fallbackLanguage => me: $fallbackLanguage;

                keys($vars): each(to($key) {
                    $translated => $translated: replace("$" + $key, $vars[$key]: localeNumeralBy($fallbackLanguage));
                });

                return $translated;
            } else {
                return $entry;
            }
        }
    }
}