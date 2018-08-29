space $Core {
    init() {
        me: $launch => create $ActivityManager(me);
    }

    $start() {
        me: $launch: $openActivity($MainActivity);
    }
}

define $launcher => create $Core();

$launcher: $start();