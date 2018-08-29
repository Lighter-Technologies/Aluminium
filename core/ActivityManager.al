space $ActivityManager {
    init($refer) {
        me: $refer => $refer;
    }

    $openActivity($activity, $referValue => none) {
        define $launch => create $activity(me: $refer, $referValue);

        $launch: $start();
    }
}