var cobalt = {
    compilation: "",
    keywords: [
        "{",
        "}",
        "true",
        "false",
    ],
    
    splitByKeywords: function(script) {
        var keywords = script.match(/(".*?"|[^"\s]+)(?=\s*|\s*$)/g);
        var bracketedKeywords = [];

        for (var i = 0; i < keywords.length; i++) {
            if (keywords[i].charAt(0) == '"') {
                bracketedKeywords.push(keywords[i]);
            } else {
                bracketedKeywords = bracketedKeywords.concat(keywords[i].replace(/\{/g, " { ").replace(/\}/g, " } ").match(/(".*?"|[^"\s]+)(?=\s*|\s*$)/g));
            }
        }

        return bracketedKeywords;
    },

    readFlow: function(script, iteration) {
        var keyword = script[iteration];
        
        if (keyword.charAt(0) == '"' && keyword.charAt(keyword.length - 1) == '"') {
            this.compilation += keyword + ", ";
        } else if (keyword.charAt(0) == "#") {
            this.compilation += '"' + keyword.substring(1) + '": ';
        } else if (keyword == "none") {
            this.compilation += "null, ";
        } else if (!isNaN(keyword)) {
            this.compilation += keyword + ", ";
        } else if (this.keywords.includes(keyword)) {
            if (keyword == "{" || keyword == "}") {
                if (keyword == "}") {
                    this.compilation += keyword + ", ";
                } else {
                    this.compilation += keyword;
                }
            } else {
                this.compilation += keyword + ", ";
            }
        } else {
            this.compilation += '"' + keyword + '": ';
        }
    },

    start: function() {
        var script = this.splitByKeywords(resCobalt);

        this.compilation = "{";

        for (var i = 0; i < script.length; i++) {
            this.readFlow(script, i);
        }

        this.compilation += "}";
        this.compilation = this.compilation.replace(/,}/g, "}").replace(/,]/g, "]").replace(/, }/g, "}").replace(/, ]/g, "]");

        try {
            res = JSON.parse(this.compilation.replace(/\\`/g, "`"));
        } catch (e) {
            console.error(
                "Compilation Error: Cobalt" + "\n" +
                "Error:   " + "SyntaxError" + "\n" +
                "Message: " + "Syntax error while reading resource."
            );
        }
    }
};