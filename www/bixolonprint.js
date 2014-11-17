
var BixolonPrintLoader = function (require, exports, module) {

    var exec = require('cordova/exec');

    var BixolonPrint = function () {

        this.version = "0.2.1";

        this.textLines = [];

        this.TextAlign = {
            LEFT   : 'left',
            CENTER : 'center',
            RIGHT  : 'right'
        };

        this.FontType = {
            A: 'A',
            B: 'B'
        };

        this.FontStyle = {
            DEFAULT   : 'default',
            BOLD      : 'bold',
            UNDERLINE : 'underlined',
            REVERSE   : 'reversed'
        };

        this.TextDimension = {
            TD_0: 0,
            TD_1: 1,
            TD_2: 2,
            TD_3: 3,
            TD_4: 4,
            TD_5: 5,
            TD_6: 6,
            TD_7: 7
        };
    };

    BixolonPrint.prototype.addHr = function (simbol) {

        var sp = "=";

        if ((typeof simbol == 'string' || simbol instanceof String) && simbol.length == 1) {
            sp = simbol;
        }

        this.addLine('[hr]' + sp);
    };

    /**
     * @param obj
     */
    BixolonPrint.prototype.addLine = function (obj) {

        var rObj = {
            text       : '',
            textAlign  : this.TextAlign.LEFT,
            textWidth  : this.TextDimension.TD_0,
            textHeight : this.TextDimension.TD_0,
            fontType   : this.FontType.A,
            fontStyle  : this.FontStyle.DEFAULT
        };

        if ( typeof obj == 'string' || obj instanceof String ) {
            rObj.text = obj;
        } else if ( obj.text ) {
            for (var key in obj) {
                if (obj.hasOwnProperty(key)) {
                    switch (key) {
                        case 'text':
                            rObj.text = obj[key];
                            break;
                        case 'align':
                        case 'textAlign':
                            rObj.textAlign = obj[key];
                            break;
                        case 'width':
                        case 'textWidth':
                            rObj.textWidth = obj[key];
                            break;
                        case 'height':
                        case 'textHeight':
                            rObj.textHeight = obj[key];
                            break;
                        case 'type':
                        case 'fontType':
                            rObj.fontType = obj[key];
                            break;
                        case 'style':
                        case 'fontStyle':
                            rObj.fontStyle = obj[key];
                            break;
                    }
                }
            }
        } else {
            console.error("BixolonPrint.addLines failure: rObj.text parameter not found!");
            return;
        }

        this.textLines.push(rObj);
    };

    BixolonPrint.prototype.printText = function (successCallback, errorCallback, cutPaper) {

        if (successCallback === null) {
            successCallback = function (response) {
                console.log('BixolonPrint.printText success: ' + response);
            };
        }

        if (errorCallback === null) {
            errorCallback = function (error) {
                console.error('BixolonPrint.printText failure: ' + error);
            };
        }

        if (typeof errorCallback != "function") {
            console.error("BixolonPrint.printText failure: failure parameter not a function");
            return;
        }

        if (typeof successCallback != "function") {
            console.error("BixolonPrint.printText failure: success callback parameter must be a function");
            return;
        }

        var textLines = this.textLines;
        this.textLines = [];

        if(!cutPaper || !(parseInt(cutPaper) === cutPaper && cutPaper > 0) ) {
            cutPaper = 5;
        }

        exec(
            successCallback,
            errorCallback,
            "BixolonPrint",
            "printText",
            [textLines, cutPaper]
        );
    };

    /**
     *
     * @param successCallback
     * @param errorCallback
     * @param lineNumber
     */
    BixolonPrint.prototype.cutPaper = function (successCallback, errorCallback, lineNumber) {

        if (successCallback === null) {
            successCallback = function (response) {
                console.log('BixolonPrint.cutPaper success: ' + response);
            };
        }

        if (errorCallback === null) {
            errorCallback = function (error) {
                console.error('BixolonPrint.cutPaper failure: ' + error);
            };
        }

        if (typeof errorCallback != "function") {
            console.error("BixolonPrint.cutPaper failure: failure parameter not a function");
            return;
        }

        if (typeof successCallback != "function") {
            console.error("BixolonPrint.cutPaper failure: success callback parameter must be a function");
            return;
        }

        if( !lineNumber ) lineNumber = 5;

        exec(
            successCallback,
            errorCallback,
            "BixolonPrint",
            "cutPaper",
            [lineNumber]
        );
    };

    /**
     *
     * @param successCallback
     * @param errorCallback
     * @param printStatus
     */
    BixolonPrint.prototype.getStatus = function (successCallback, errorCallback, printStatus) {

        if (successCallback === null) {
            successCallback = function (response) {
                console.log('BixolonPrint.getStatus success: ' + response);
            };
        }

        if (errorCallback === null) {
            errorCallback = function (error) {
                console.error('BixolonPrint.getStatus failure: ' + error);
            };
        }

        if (typeof errorCallback != "function") {
            console.error("BixolonPrint.getStatus failure: failure parameter not a function");
            return;
        }

        if (typeof successCallback != "function") {
            console.error("BixolonPrint.getStatus failure: success callback parameter must be a function");
            return;
        }

        if( !printStatus ) printStatus = false;

        exec(
            successCallback,
            errorCallback,
            "BixolonPrint",
            "getStatus",
            [printStatus]
        );
    };

    module.exports = new BixolonPrint();
};

BixolonPrintLoader(require, exports, module);
cordova.define("cordova/plugin/BixolonPrint", BixolonPrintLoader );