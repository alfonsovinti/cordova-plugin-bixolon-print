BixolonPrint Corodva Plugin
==============

Cross-platform BixolonPrint Plugin for Cordova / PhoneGap.

### Supported Platforms

- Android
- iOS

## Installation
Below are the methods for installing this plugin automatically using command line tools.

### Using the Cordova CLI

```
$ cordova plugin add https://github.com/alfonsovinti/cordova-plugin-bixolon-print.git
```

### Using the Phonegap CLI

```
$ phonegap local plugin add https://github.com/alfonsovinti/cordova-plugin-bixolon-print.git
```

## Plugin Options

```javascript
cordova.plugins.bixolonPrint.settings = {
  lineFeed: 3,
  formFeed: false,      // enable\disable jump to next position, in black marker and label modes
  autoConnect: true,    // Android only: if this is set to false displays a dialog box for selecting the printer
  toastMessage: true,   // Android only: show a printer message
  separator: '=',
  codePage: cordova.plugins.bixolonPrint.CodePage.CP_1252_LATIN1 // define code page, default value is set to CP_1252_LATIN1.
};
```

## Available Code Page

    CP_437_USA               : 0,
    CP_KATAKANA              : 1,
    CP_850_MULTILINGUAL      : 2,
    CP_860_PORTUGUESE        : 3,
    CP_863_CANADIAN_FRENCH   : 4,
    CP_865_NORDIC            : 5,
    CP_1252_LATIN1           : 16,
    CP_866_CYRILLIC2         : 17,
    CP_852_LATIN2            : 18,
    CP_858_EURO              : 19,
    CP_862_HEBREW_DOS_CODE   : 21, // Android only
    CP_864_ARABIC            : 22,
    CP_THAI42                : 23,
    CP_1253_GREEK            : 24,
    CP_1254_TURKISH          : 25,
    CP_1257_BALTIC           : 26,
    CP_FARSI                 : 27,
    CP_1251_CYRILLIC         : 28,
    CP_737_GREEK             : 29,
    CP_775_BALTIC            : 30,
    CP_THAI14                : 31,
    CP_1255_HEBREW_NEW_CODE  : 33,
    CP_THAI11                : 34, // Android only
    CP_THAI18                : 35, // Android only
    CP_855_CYRILLIC          : 36,
    CP_857_TURKISH           : 37,
    CP_928_GREEK             : 38,
    CP_THAI16                : 39,
    CP_1256_ARABIC           : 40,
    CP_1258_VIETNAM          : 41, // Android only
    CP_KHMER_CAMBODIA        : 42, // Android only
    CP_1250_CZECH            : 43  // Android only

## Using the plugin

The plugin creates the object `cordova/plugin/BixolonPrint` with following methods:

### Add line to print

```javascript
cordova.plugins.bixolonPrint.addLine({
    text       : String,    // text to print
    textAlign  : String,    // text align, default left
    textWidth  : int,       // text width, default 0
    textHeight : int,       // text height, default 0
    fontType   : String,    // font type, A or B
    fontStyle  : String     // font style, bold or underlined or reversed
});
```

### Add line separator

```javascript
cordova.plugins.bixolonPrint.addHr(separator String);
```

### Print text lines

```javascript
cordova.plugins.bixolonPrint.printText(successCallback, errorCallback, config Object);
```

### Cut paper

```javascript
cordova.plugins.bixolonPrint.cutPaper(successCallback, errorCallback, config Object);
```

### Get printer status

```javascript
cordova.plugins.bixolonPrint.getStatus(successCallback, errorCallback, printStatus Boolean);
```

## Examples

### Print a text

```javascript
cordova.plugins.bixolonPrint.addLine("hello cordova!");
cordova.plugins.bixolonPrint.printText();
```
### Print a custom text

```javascript
// compose text
cordova.plugins.bixolonPrint.addLine({
    text: "hello cordova!"
    textAlign: cordova.plugins.bixolonPrint.TextAlign.CENTER,
    fontStyle: cordova.plugins.bixolonPrint.FontStyle.BOLD
});
cordova.plugins.bixolonPrint.addHr();
cordova.plugins.bixolonPrint.addLine("#@*èòçìàé€");
// finally print
cordova.plugins.bixolonPrint.printText(
    function (response) {
        alert("print success!")
    },
    function (error) {
        alert("print failure: " + error)
    },
    {
        codePage: cordova.plugins.bixolonPrint.CodePage.CP_1252_LATIN1
    }
);
```