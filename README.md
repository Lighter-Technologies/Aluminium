# Aluminium
The programming language that comes packed with features.

**Status**: Development.

## Features
* Object-oriented programming language.
* Multi-lingual and right-to-left text support in your apps.
* Easy way to define user interface layouts and elements.
* Comes with jQuery-like features with `$appSelector`.
* Apps are modelled around activities (screens and processes that can call each other).

## Examples
### `ActivityManager`
```
define $launch => create $ActivityManager(me);

$launch: $openActivity($ExampleActivity);
```

### `AppHead`
```
define $head => create $AppHead();

$head: $title("Example App");
```

### `AppLayout`
```
#("We define $layout so that we can have a temporary copy of $res that we can change.");
define $layout => $res;
define $layoutHandler => create $AppLayout($layout, true, $locale);

$layoutHandler: $draw();
```

### `AppSettingsStorage`
```
define $userIsHappy => create $AppSettingsStorage("happy");

$userIsHappy: $value => true;
```

### `StringLanguage`
```
define $translator => create $StringLanguage($locale);

log($translator: $read("hello-world"));
```

## Getting Started
1. Clone this repository. (Obviously!)
2. Go into the `app` directory. This is where you'll be coding everything.
3. Code in `res` and `scripts`. `res` is where all of the read-only information goes. It can't be changed in your app as when you reload your app the changes will be reverted. `scripts` is where all of the Aluminium code goes. It defines spaces (classes in other programming languages) per file. `MainActivity.al` is the main activity that runs when your app is launched.
4. Make sure that all of the files that you have in the `app` directory are listed in the `makefile.txt` file in the root directory.
5. Run `build.bat` or `build.sh` in the root directory (depending on your operating system) to compile your code. Use `build` or `bash build.sh` commands depending on your operating system.
6. Open `app.html` in the root directory and observe what you just did! Debug code using your browser's JavaScript console.
7. If you need to change anything, go to step 3 and continue from there.
