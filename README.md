BixolonPrint Corodva Plugin
==============

Cross-platform BixolonPrint Plugin for Cordova / PhoneGap.

### Supported Platforms

- Android
- iOS

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
cordova.plugins.bixolonPrint.addHr(simbol String);
```

### Print text lines

```javascript
cordova.plugins.bixolonPrint.printText(successCallback, errorCallback, cutPaper int);
```

### Cut paper

```javascript
cordova.plugins.bixolonPrint.cutPaper(successCallback, errorCallback, lineNumber int);
```

### Get printer status

```javascript
cordova.plugins.bixolonPrint.getStatus(successCallback, errorCallback, printStatus Boolean);
```

## Examples

```javascript
cordova.plugins.bixolonPrint.addLine("hello cordova!");
cordova.plugins.bixolonPrint.printText(null, null);
```