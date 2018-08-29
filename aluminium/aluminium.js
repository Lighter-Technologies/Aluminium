var aluminium = {
    libs: {},
    compilation: "",
    keywords: {
        "define": "var",
        "to": "function",
        "space": "class",
        "in": "extends",
        "init": "constructor",
        "getter": "get",
        "setter": "set",
        "static": "static",
        "return": "return",
        "me": "this",
        "partof": "in",
        "parent": "super",
        "create": "new",
        "if": "if",
        "elif": "else if",
        "else": "else",
        "while": "while",
        "exit": "break",
        "skip": "continue",
        "for": "for",
        "keys": "Object.keys",
        "each": "forEach",
        "test": "try",
        "catch": "catch",
        "ignore": "catch (error) {}",
        "after": "finally",
        "error": "throw",
        "length": "length",
        "log": "aluminiumLog",
        "logWarning": "aluminiumLogWarning",
        "logError": "aluminiumLogError",
        "true": "true",
        "false": "false",
        "none": "null",
        "nan": "NaN",
        "object": "space",
        "undefined": "undefined",
        "dispose": "delete",
        "getString": "aluminiumString",
        "getNumber": "Number",
        "splitStringBy": "split",
        "substringBy": "substring",
        "charAtStringBy": "charAt",
        "localeNumeralBy": "toLocaleString",
        "replace": "replace",
        "+": "+",
        "-": "-",
        "*": "*",
        "/": "/",
        "^": "**",
        "me+": "++",
        "me-": "--",
        "+>": "+=",
        "->": "-=",
        "*>": "*=",
        "mod>": "%=",
        "mod": "%",
        "%": "/ 100",
        "=": "==",
        "!=": "!=",
        ":=": "===",
        "!:=": "!==",
        "<": "<",
        ">": ">",
        "<=": "<=",
        ">=": ">=",
        "&": "&&",
        "|": "||",
        "!": "!",
        "type": "aluminiumType",
        "(": "(",
        ")": ")",
        "{": "{",
        "}": "}",
        "[": "[",
        "]": "]",
        ";": ";",
        "#": "aluminiumComment",
        ",": ", ",
        "=>": "= ",
        "key>": ": ",
        ":": "."
    },

    splitByKeywords: function(script) {
        var keywords = script.match(/(".*?"|[^"\s]+)(?=\s*|\s*$)/g);
        var bracketedKeywords = [];

        for (var i = 0; i < keywords.length; i++) {
            if (keywords[i].charAt(0) == '"') {
                bracketedKeywords.push(keywords[i]);
            } else {
                bracketedKeywords = bracketedKeywords.concat(keywords[i].replace(/\(/g, " ( ").replace(/\)/g, " ) ").replace(/\{/g, " { ").replace(/\}/g, " } ").replace(/\[/g, " [ ").replace(/\]/g, " ] ").replace(/\:/g, " : ").replace(/: =/g, ":=").replace(/\,/g, " , ").replace(/;/g, " ; ").replace(/%/g, " % ").replace(/!/g, " ! ").replace(/! =/g, "!=").replace(/!  :=/g, "!:=").match(/(".*?"|[^"\s]+)(?=\s*|\s*$)/g));
            }
        }

        return bracketedKeywords;
    },

    readFlow: function(script, iteration) {
        var keyword = script[iteration];
        var endOfCommand = false;

        if (keyword[keyword.length - 1] == ";") {
            endOfCommand = true;
        }

        if (keyword.charAt(0) == '"' && keyword.charAt(keyword.length - 1) == '"') {
            this.compilation += keyword + " ";
        } else if (keyword.charAt(0) == "$") {
            this.compilation += keyword.substring(1) + " ";
        } else if (!isNaN(keyword)) {
            this.compilation += keyword;
        } else if (keyword != "") {
            if (this.keywords[keyword] == undefined) {
                this.errorState = {
                    type: "KeywordError",
                    message: "Undefined keyword: \"" + keyword + "\".",
                    marker: iteration
                }
            } else {
                this.compilation += this.keywords[keyword] +  " ";
            }
        }

        if (endOfCommand) {
            this.compilation = this.compilation.substring(0, this.compilation.length - 1) + ";\n";
        }
    },

    errorFriendlify: function(errorMessage, keywords, errorType) {
        var errorMessageReplacements = {
            "Permission denied to access property": "Permission denied while accessing =",
            "too much recursion": "Recursion limit passed",
            "argument is not a valid code point": "Argument is an invalid code point",
            "invalid array length": "Invalid array length",
            "invalid date": "Invalid date",
            "precision is out of range": "Precision is out of range",
            "radix must be an integer": "Radix must be an integer",
            "repeat count must be less than infinity": "Repeat count must not be infinite",
            "repeat count must be non-negative": "Repeat count must be positive",
            "is not defined": "is undefined",
            "assignment to undeclared variable": "Couldn't assign to undefined variable",
            "can't access lexical declaration": "Can't access variable",
            "before initialization": "before initialisation",
            "deprecated caller or arguments usage": "Can't use deprecated caller or argument for security reasons",
            "invalid assignment left-hand side": "Invalid assignment structure",
            "reference to undefined property": "Can't reference undefined property",
            "Unexpected token": "Unexpected"
        };

        Object.keys(keywords).forEach(function(key) {
                errorMessage = errorMessage.replace(new RegExp(keywords[key].replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"), "g"), key);
            });

            Object.keys(errorMessageReplacements).forEach(function(key) {
                errorMessage = errorMessage.replace(new RegExp(key, "g"), errorMessageReplacements[key]);
            });

            return errorMessage;
    },

    start: function() {
        var script = this.splitByKeywords(source);

        for (var i = 0; i < script.length; i++) {
            this.readFlow(script, i);
        }

        if (this.errorState == undefined) {
            (function(aluminiumCompilation, aluminiumKeywords, aluminiumErrorFriendlify, res, libs, appWindow, appSelector) {
                "use strict";

                var newline = "\n";
                var stringesc = "\"";
                
                if (navigator.languages != undefined) {
                    var locale = navigator.languages[0];
                } else {
                    var locale = navigator.language;
                }

                function aluminiumString(entry) {
                    if (typeof entry == "null") {
                        return "none";
                    } else if (typeof entry == "undefined") {
                        return "undefined";
                    } else if (typeof entry == "number" || typeof entry == "string" || typeof entry == "boolean") {
                        return entry;
                    } else if (typeof entry == "object" && !Array.isArray(entry)) {
                        return "(Type) space";
                    } else {
                        return "(Type) " + typeof entry;
                    }
                }

                function aluminiumLog(entry) {
                    console.log(aluminiumString(entry));
                }

                function aluminiumLogWarning(entry) {
                    console.warn(aluminiumString(entry));
                }

                function aluminiumLogError(entry) {
                    console.error(aluminiumString(entry));
                }

                function aluminiumType(object) {
                    if (typeof object in aluminiumKeywords) {
                        return aluminiumKeywords[typeof object];
                    } else {
                        return typeof object;
                    }
                }

                String.prototype.aluminiumReplace = function(search, replace) {
                    return this.replace(new RegExp(search, "g"), replace);
                };

                function aluminiumComment(comment) {}

                try {
                    eval(aluminiumCompilation.replace(/;;/g, ";"));
                } catch (error) {
                    if (error.message.charAt(error.message.length - 1) == ".") {
                        console.error(
                            "Runtime Error: Aluminium" + "\n" +
                            "Error:   " + error.name + "\n" +
                            "Message: " + aluminiumErrorFriendlify(error.message, aluminiumKeywords, error.name) + "\n"
                        );
                    } else {
                        console.error(
                            "Runtime Error: Aluminium" + "\n" +
                            "Error:   " + error.name + "\n" +
                            "Message: " + aluminiumErrorFriendlify(error.message, aluminiumKeywords, error.name) + "." + "\n"
                        );
                    }
                }
            })(this.compilation, this.keywords, this.errorFriendlify, res, this.libs, window, $);
        } else {
            console.error(
                "Compilation Error: Aluminium" + "\n" +
                "Error:   " + this.errorState.type + "\n" +
                "Message: " + this.errorState.message + "\n" +
                "At iter: " + this.errorState.marker
            );
        }
    }
};