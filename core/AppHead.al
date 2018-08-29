space $AppHead {
    setter $title($entry) {
        $appSelector("title"): $text($entry);
    }

    getter $title() {
        return $appSelector("title"): $text();
    }

    setter $icon($entry) {
        $appSelector("link[rel='shortcut icon']"): $attr("href", $entry);
    }

    getter $icon() {
        return $appSelector("link[rel='shortcut icon']"): $attr("href");
    }
}