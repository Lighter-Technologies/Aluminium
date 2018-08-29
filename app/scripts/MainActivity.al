space $MainActivity {
    init($referrer, $referrerValue) {
        me: $referrer => $referrer;
        me: $referrerValue => $referrerValue;

        me: $layout => $res;

        me: $translator => create $StringLanguage($locale);
        me: $layoutHandler => create $AppLayout(me: $layout, true, $locale);
    }

    $start() {
        #("Insert your code here:");
        log(me: $translator: $read("hello-world"));

        me: $layoutHandler: $draw();
    }
}