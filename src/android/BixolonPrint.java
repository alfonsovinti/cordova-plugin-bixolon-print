/*
 *
 * Copyright (C) 2013 Alfonso Vinti <me@alfonsovinti.it>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 */

package it.alfonsovinti.cordova.plugins.bixolonprint;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.bixolon.android.library.BxlService;

import android.annotation.SuppressLint;
import android.util.Log;
//import android.widget.Toast;

public class BixolonPrint extends CordovaPlugin {

    // Action to execute
    public static final String PRINT_TEXT = "printText";
    public static final String PRINT_IMG = "printImg";
    public static final String CONNECT = "connect";
    public static final String DISCONNECT = "disconnect";
    public static final String GET_STATUS = "getStatus";
    public static final String GET_INFO = "getInfo";
    public static final String CUT_PAPER = "cutPaper";
    public static final String GET_PRINT_NAME = "getPrinterName";

    //Allignment string
    public static final String LEFT = "LEFT";
    public static final String CENTER = "CENTER";
    public static final String RIGHT = "RIGHT";

    //Font string
    public static final String FONT_A = "A";
    public static final String FONT_B = "B";

    private static final String TAG = "BixolonPrint";

    static BxlService mBxlService = null;

    private CallbackContext cbContext;

    private boolean actionValid;

    private boolean conn = false;

    private final static int[] PRODUCT_IDS = {
            10,    // SPP-R200
            18,    // SPP-100
            22,    // SRP-F310
            31,    // SRP-350II
            29,    // SRP-350plusII
            35,    // SRP-F312
            36,    // SRP-350IIK
            40,    // SPP-R200II
            33,    // SPP-R300
            41     // SPP-R400
    };

    private final static String[] STATUS_TXT = {
            "BXL_SUCCESS"
    };

    private final static int[] MAX_COL = {
            69
    };

    /**
     * Executes the request and returns PluginResult
     *
     * @param action          Action to execute
     * @param data            JSONArray of arguments to the plugin
     * @param callbackContext The callback context used when calling back into JavaScript.
     * @return A PluginRequest object with a status
     */
    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) {
        this.cbContext = callbackContext;
        this.actionValid = true;

        if (PRINT_TEXT.equals(action)) {
            JSONArray obj = args.optJSONArray(0);
            int cutLines = args.optInt(1);
            if (obj != null) {
                /*cordova.getThreadPool().execute(new Runnable() {
                    public void run() {
						printl(text, align, attribute, w, h);
					}
				});*/
                this.printText(obj, cutLines);
            } else {
                Log.d("BixolonPrint", "Got JSON Exception ");
                this.cbContext.error("User did not specify data to encode");
                this.actionValid = false;
            }
        } else if (CUT_PAPER.equals(action)) {
            int line = args.optInt(0);
            this.cutPaper(line);
        } else if (CONNECT.equals(action)) {
            this.connect();
        } else if (DISCONNECT.equals(action)) {
            this.disconnect();
        } else if (GET_STATUS.equals(action)) {
            boolean printStatus = args.optBoolean(0);
            this.getStatus(printStatus);
        } else if (GET_INFO.equals(action)) {
            this.getInfo();
        } else if (GET_PRINT_NAME.equals(action)) {
            this.getPrinterName();
        } else {
            this.actionValid = false;
            this.cbContext.error("Invalid Action");
            Log.d("BixolonPrintPlugin", "Invalid action : " + action
                    + " passed");
        }
        return this.actionValid;
    }

    public String getPrinterName() {

        if (!this.conn) {
            if (!this.printConnect()) {
                this.cbContext.error("connect error!");
            }
        }

        String returnValue = mBxlService.GetPrinterName();

        Log.i(TAG, "Printer Name: " + returnValue);

        if (returnValue != null) {
            this.actionValid = true;
            this.cbContext.success(returnValue);
        } else {
            this.actionValid = false;
            this.cbContext.error("getPrinterName error!");
        }

        this.disconnect();

        return returnValue;
    }

    public int printText(JSONArray arObj, int cutLines) {
        CheckGC("Print_Start");

        int returnValue = BxlService.BXL_SUCCESS;
        String hrBCode = "[hr]";
        int paperWidth = 0;

        if (!this.conn) {
            if (!this.printConnect()) {
                this.cbContext.error("connect error!");
            }
        }

        int arlength = arObj.length();

        String text;
        String align;
        String fontType;
        String fontStyle;
        int height;
        int width;

        int textAlignment;
        int textAttribute;
        int textWidth;
        int textHeight;

        JSONObject obj;

        returnValue = mBxlService.GetStatus();

        for (int i = 0; i < arlength; i++) {
            try {

                obj = arObj.getJSONObject(i);
                text = obj.optString("text");
                align = obj.optString("textAlign");
                width = obj.optInt("textWidth");
                height = obj.optInt("textHeight");
                fontType = obj.optString("fontType");
                fontStyle = obj.optString("fontStyle");

                if (hrBCode.startsWith(text.substring(0, Math.min(4, text.length())))) {
                    String hrStr = text.substring(text.length() - 1);
                    text = "";
                    if (mBxlService.GetPrinterName().equals("SPP-R300")) {
                        paperWidth = 48;
                    } else {
                        paperWidth = 69;
                    }

                    for (int j = 0; j < paperWidth; j++) {
                        text += hrStr;
                    }

                }

                if (returnValue == BxlService.BXL_SUCCESS) {
                    textAlignment = this.getAlignment(align);
                    textAttribute = this.getAttribute(fontType, fontStyle);
                    textWidth = this.getTextWidth(width);
                    textHeight = this.getTextHeight(height);

                    returnValue = mBxlService.PrintText(
                            text + "\r\n",
                            textAlignment,
                            textAttribute,
                            textWidth | textHeight
                    );
                }

            } catch (JSONException e) {
                this.actionValid = false;
                this.cbContext.error("print error: " + returnValue + " JSONException:" + e.getMessage());
            }
        }

        returnValue = mBxlService.LineFeed(cutLines, true);
        if (returnValue == BxlService.BXL_SUCCESS) {
            this.actionValid = true;
            this.cbContext.success("print success");
        } else {
            this.actionValid = false;
            this.cbContext.error("print error: " + returnValue);
        }

        CheckGC("PrintLine_End");

        this.disconnect();

        return returnValue;
    }


    public int cutPaper(int line) {

        CheckGC("CutPaper_Start");

        if (!this.conn) {
            if (!this.printConnect()) {
                this.cbContext.error("connect error!");
            }
        }

        int returnValue;
        returnValue = mBxlService.LineFeed(line, true);
        if (returnValue == BxlService.BXL_SUCCESS) {
            this.actionValid = true;
            this.cbContext.success("lineFeed success!");
        } else {
            this.actionValid = false;
            this.cbContext.error("lineFeed error!");
        }

        CheckGC("CutPaper_End");
        this.disconnect();

        return returnValue;

    }

    public boolean getStatus(boolean printStatus) {
        CheckGC("GetStatus_Start");

        if (!this.conn) {
            if (!this.printConnect()) {
                this.cbContext.error("connect error!");
            }
        }

        JSONObject obj = new JSONObject();
        boolean returnValue;

        try {
            returnValue = true;
            this.actionValid = true;

            obj.put("status", mBxlService.GetStatus());

            String printerName = mBxlService.GetPrinterName();
            obj.put("printerName", printerName);

            //String serialNumber = mBxlService.GetSerialNumber();
            //obj.put("serialNumber", serialNumber);

            String sdkVersion = mBxlService.GetSDKVersion();
            obj.put("sdkVersion", sdkVersion);

            String powerStatus = "";
            if (mBxlService.GetPowerStatus() == mBxlService.BXL_PWR_HIGH) {
                powerStatus = "HIGH";
            } else if (mBxlService.GetPowerStatus() == mBxlService.BXL_PWR_MIDDLE) {
                powerStatus = "MIDDLE";
            } else if (mBxlService.GetPowerStatus() == mBxlService.BXL_PWR_LOW) {
                powerStatus = "LOW";
            } else if (mBxlService.GetPowerStatus() == mBxlService.BXL_PWR_SMALL) {
                powerStatus = "SMALL";
            } else if (mBxlService.GetPowerStatus() == mBxlService.BXL_PWR_NOT) {
                powerStatus = "NOT";
            }
            obj.put("powerStatus", powerStatus);

            if (printStatus) {
                mBxlService.GetPrinterName();
                mBxlService.PrintText("Printer Name :" + printerName + "\r\n", 0, 0, 0);
                //mBxlService.PrintText("Serial Number :" + serialNumber + "\r\n", 0, 0, 0);
                mBxlService.PrintText("SDK Version :" + sdkVersion + "\r\n", 0, 0, 0);
                mBxlService.PrintText("Power Status :" + powerStatus + "\r\n", 0, 0, 0);
                mBxlService.LineFeed(5, true);
            }

            this.cbContext.success(obj);

        } catch (JSONException e) {
            returnValue = false;
            this.actionValid = false;
            this.cbContext.error("getStatus error!");
        }

        CheckGC("GetStatus_End");
        this.disconnect();

        return returnValue;
    }

    public boolean getInfo() {
        JSONObject obj = new JSONObject();
        int statusValue;
        boolean returnValue = true;
        CheckGC("GetPrinterName_Start");
        statusValue = mBxlService.GetStatus();

        String printerName = null;
        if (statusValue == BxlService.BXL_SUCCESS) {
            printerName = mBxlService.GetPrinterName();
        }

        if (printerName != null) {
            try {
                obj.put("status", mBxlService.GetStatus());
                String tem_buffer = new String();
                tem_buffer = "[" + printerName + "]";
                obj.put("name", tem_buffer.subSequence(0, tem_buffer.getBytes().length));
                tem_buffer = null;
                this.actionValid = true;
                this.cbContext.success(obj);
            } catch (JSONException e) {
                returnValue = false;
                this.actionValid = false;
                this.cbContext.error("getInfo error!");
            }
        } else {
            try {
                String tem_buffer = new String();
                tem_buffer = "ERROR [" + statusValue + "]";
                obj.put("status", tem_buffer.subSequence(0, tem_buffer.getBytes().length));
                tem_buffer = null;
                this.actionValid = true;
                this.cbContext.error(obj);
            } catch (JSONException e) {
                this.actionValid = false;
                this.cbContext.error("getInfo error!");
            }
            returnValue = false;
        }
        CheckGC("GetPrinterName_End");
        return returnValue;
    }


    /**
     * @return
     */
    public boolean disconnect() {
        CheckGC("Disconnect_Start");
        mBxlService.Disconnect();
        mBxlService = null;
        this.conn = false;
        // defense code for HTC Desire because of reconnect' fail
        // finish();
        CheckGC("Disconnect_End");
        return true;
    }

    /**
     * @return
     */
    public boolean connect() {
        CheckGC("Connect_Start");
        boolean returnStatus = false;
        if (this.printConnect()) {
            returnStatus = true;
            this.actionValid = true;
            this.cbContext.success("connect success!");
        } else {
            this.actionValid = false;
            this.cbContext.error("connect error!");
        }
        CheckGC("Connect_End");
        return returnStatus;
    }
	
	
	
	/*         METODI ACCESSORI
	 ---------------------------------------*/

    private boolean printConnect() {
        boolean returnStatus = false;
        mBxlService = new BxlService();
        if (mBxlService.Connect() == 0) {
            returnStatus = true;
            this.conn = true;
        } else {
            this.conn = false;
        }
        return returnStatus;
    }

    //private boolean printDisconnect() {
    //    return true;
    //}

    /**
     * @param fontType
     * @param fontStyle
     * @return
     */
    @SuppressLint("DefaultLocale")
    private int getAttribute(String fontType, String fontStyle) {
        // setting attribute
        int attribute = BxlService.BXL_FT_DEFAULT;
        if (fontType.toUpperCase().equals("B")) {
            attribute |= BxlService.BXL_FT_FONTB;
        }

        if (fontStyle.toUpperCase().equals("BOLD")) {
            attribute |= BxlService.BXL_FT_BOLD;
        }

        if (fontStyle.toUpperCase().equals("UNDERLINE")) {
            attribute |= BxlService.BXL_FT_UNDERLINE;
        }

        if (fontStyle.toUpperCase().equals("REVERSE")) {
            attribute |= BxlService.BXL_FT_REVERSE;
        }
        return attribute;
    }

    /**
     * @param align
     * @return
     */
    @SuppressLint("DefaultLocale")
    private int getAlignment(String align) {
        int alignment;
        if (LEFT.equals(align.toUpperCase())) {
            alignment = BxlService.BXL_ALIGNMENT_LEFT;
        } else if (CENTER.equals(align.toUpperCase())) {
            alignment = BxlService.BXL_ALIGNMENT_CENTER;
        } else if (RIGHT.equals(align.toUpperCase())) {
            alignment = BxlService.BXL_ALIGNMENT_RIGHT;
        } else {
            alignment = -1;
        }
        return alignment;
    }

    private int getTextWidth(int width) {
        int textWidth = -1;
        switch (width) {
            case 0:
                textWidth = BxlService.BXL_TS_0WIDTH;
                break;
            case 1:
                textWidth = BxlService.BXL_TS_1WIDTH;
                break;
            case 2:
                textWidth = BxlService.BXL_TS_2WIDTH;
                break;
            case 3:
                textWidth = BxlService.BXL_TS_3WIDTH;
                break;
            case 4:
                textWidth = BxlService.BXL_TS_4WIDTH;
                break;
            case 5:
                textWidth = BxlService.BXL_TS_5WIDTH;
                break;
            case 6:
                textWidth = BxlService.BXL_TS_6WIDTH;
                break;
            case 7:
                textWidth = BxlService.BXL_TS_7WIDTH;
                break;
        }
        //Log.i("TW", "textWidth: "+BxlService.BXL_TS_7WIDTH);
        return textWidth;
    }

    private int getTextHeight(int height) {
        int textHeight = -1;
        switch (height) {
            case 0:
                textHeight = BxlService.BXL_TS_0HEIGHT;
                break;
            case 1:
                textHeight = BxlService.BXL_TS_1HEIGHT;
                break;
            case 2:
                textHeight = BxlService.BXL_TS_2HEIGHT;
                break;
            case 3:
                textHeight = BxlService.BXL_TS_3HEIGHT;
                break;
            case 4:
                textHeight = BxlService.BXL_TS_4HEIGHT;
                break;
            case 5:
                textHeight = BxlService.BXL_TS_5HEIGHT;
                break;
            case 6:
                textHeight = BxlService.BXL_TS_6HEIGHT;
                break;
            case 7:
                textHeight = BxlService.BXL_TS_7HEIGHT;
                break;
        }
        return textHeight;
    }

    /**
     * @param FunctionName
     */
    private void CheckGC(String FunctionName) {
        long VmfreeMemory = Runtime.getRuntime().freeMemory();
        long VmmaxMemory = Runtime.getRuntime().maxMemory();
        long VmtotalMemory = Runtime.getRuntime().totalMemory();
        long Memorypercentage = ((VmtotalMemory - VmfreeMemory) * 100)
                / VmtotalMemory;

        Log.i(TAG, FunctionName + "Before Memorypercentage" + Memorypercentage
                + "% VmtotalMemory[" + VmtotalMemory + "] " + "VmfreeMemory["
                + VmfreeMemory + "] " + "VmmaxMemory[" + VmmaxMemory + "] ");

        // Runtime.getRuntime().gc();
        System.runFinalization();
        System.gc();
        VmfreeMemory = Runtime.getRuntime().freeMemory();
        VmmaxMemory = Runtime.getRuntime().maxMemory();
        VmtotalMemory = Runtime.getRuntime().totalMemory();
        Memorypercentage = ((VmtotalMemory - VmfreeMemory) * 100)
                / VmtotalMemory;

        Log.i(TAG, FunctionName + "_After Memorypercentage" + Memorypercentage
                + "% VmtotalMemory[" + VmtotalMemory + "] " + "VmfreeMemory["
                + VmfreeMemory + "] " + "VmmaxMemory[" + VmmaxMemory + "] ");
    }

}