space $AppSettingsStorage {
    init($key) {
        me: $localStorage => $appWindow["localStorage"];
        me: $key => $key;
    }

    setter $value($valueToStore) {
        me: $localStorage["setItem"](me: $key, $valueToStore);
    }

    getter $value() {
        if (me: $localStorage["getItem"](me: $key) = "null") {
            return none;
        } else {
            return me: $localStorage["getItem"](me: $key);
        }
    }
}