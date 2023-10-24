package com.example.uboyniy_cex

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.device.ScanManager
import android.device.scanner.configuration.PropertyID
import android.device.scanner.configuration.Symbology
import android.util.Log
import io.flutter.plugin.common.EventChannel


class ScannerStreamHandler(private var activity: Activity?) : EventChannel.StreamHandler  {

    private var eventSink:EventChannel.EventSink? = null
    private var scanManager: ScanManager? = null

    private val mReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            if (ACTION_DECODE == action) {
                val barcode = intent.getByteArrayExtra(DECODE_DATA_TAG)
                val barcodeLen = intent.getIntExtra(BARCODE_LENGTH_TAG, 0)
                val barcodeStr = intent.getStringExtra(BARCODE_STRING_TAG)
                var scanResult = String(barcode!!, 0, barcodeLen)
                eventSink?.success(barcodeStr)
//                val msg = mHandler.obtainMessage(MSG_SHOW_SCAN_RESULT)
//                msg.obj = scanResult
//                mHandler.sendMessage(msg)
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        scanManager = ScanManager()
        Log.d("hello", "world")
        registerReceiver(true)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        activity = null
        registerReceiver(false)
    }

    private fun registerReceiver(register: Boolean) {
        if (register && scanManager != null) {
            val filter = IntentFilter()
            val idbuf = intArrayOf(PropertyID.WEDGE_INTENT_ACTION_NAME, PropertyID.WEDGE_INTENT_DATA_STRING_TAG)
            val value_buf = scanManager!!.getParameterString(idbuf)
            if (value_buf != null && value_buf[0] != null && value_buf[0] != "") {
                filter.addAction(value_buf[0])
            } else {
                filter.addAction(ACTION_DECODE)
            }
            activity?.registerReceiver(mReceiver, filter)
        } else if (scanManager != null) {
            scanManager!!.stopDecode()
            activity?.unregisterReceiver(mReceiver)
        }
    }

    companion object {
        private const val TAG = "ScanManagerDemo"
        private const val DEBUG = true
        private const val ACTION_DECODE = ScanManager.ACTION_DECODE // default action
        private const val ACTION_DECODE_IMAGE_REQUEST = "action.scanner_capture_image"
        private const val ACTION_CAPTURE_IMAGE = "scanner_capture_image_result"
        private const val BARCODE_STRING_TAG = ScanManager.BARCODE_STRING_TAG
        private const val BARCODE_TYPE_TAG = ScanManager.BARCODE_TYPE_TAG
        private const val BARCODE_LENGTH_TAG = ScanManager.BARCODE_LENGTH_TAG
        private const val DECODE_DATA_TAG = ScanManager.DECODE_DATA_TAG
        private const val DECODE_ENABLE = "decode_enable"
        private const val DECODE_TRIGGER_MODE = "decode_trigger_mode"
        private const val DECODE_TRIGGER_MODE_HOST = "HOST"
        private const val DECODE_TRIGGER_MODE_CONTINUOUS = "CONTINUOUS"
        private const val DECODE_TRIGGER_MODE_PAUSE = "PAUSE"
        private var DECODE_TRIGGER_MODE_CURRENT = DECODE_TRIGGER_MODE_HOST
        private const val DECODE_OUTPUT_MODE_INTENT = 0
        private const val DECODE_OUTPUT_MODE_FOCUS = 1
        private var DECODE_OUTPUT_MODE_CURRENT = DECODE_OUTPUT_MODE_FOCUS
        private const val DECODE_OUTPUT_MODE = "decode_output_mode"
        private const val DECODE_CAPTURE_IMAGE_KEY = "bitmapBytes"
        private const val DECODE_CAPTURE_IMAGE_SHOW = "scan_capture_image"
        private var mScanEnable = true
        private var mScanSettingsView = false
        private var mScanCaptureImageShow = false
        private var mScanBarcodeSettingsMenuBarcodeList = false
        private var mScanBarcodeSettingsMenuBarcode = false
        //private val mBarcodeMap: MutableMap<String, MainActivity.BarcodeHolder> = HashMap()
        private const val MSG_SHOW_SCAN_RESULT = 1
        private const val MSG_SHOW_SCAN_IMAGE = 2
        private val SCAN_KEYCODE = intArrayOf(520, 521, 522, 523)

        /**
         * byte[] toHex String
         *
         * @param src
         * @return String
         */
        fun bytesToHexString(src: ByteArray?): String? {
            val stringBuilder = StringBuilder("")
            if (src == null || src.size <= 0) {
                return null
            }
            for (i in src.indices) {
                val v = src[i].toInt() and 0xFF
                val hv = Integer.toHexString(v)
                if (hv.length < 2) {
                    stringBuilder.append(0)
                }
                stringBuilder.append(hv)
            }
            return stringBuilder.toString()
        }

        /**
         * Use of android.device.scanner.configuration.Symbology enums
         */
        private val BARCODE_SUPPORT_SYMBOLOGY = arrayOf(
                Symbology.AZTEC,
                Symbology.CHINESE25,
                Symbology.CODABAR,
                Symbology.CODE11,
                Symbology.CODE32,
                Symbology.CODE39,
                Symbology.CODE93,
                Symbology.CODE128,
                Symbology.COMPOSITE_CC_AB,
                Symbology.COMPOSITE_CC_C,
                Symbology.DATAMATRIX,
                Symbology.DISCRETE25,
                Symbology.EAN8,
                Symbology.EAN13,
                Symbology.GS1_14,
                Symbology.GS1_128,
                Symbology.GS1_EXP,
                Symbology.GS1_LIMIT,
                Symbology.INTERLEAVED25,
                Symbology.MATRIX25,
                Symbology.MAXICODE,
                Symbology.MICROPDF417,
                Symbology.MSI,
                Symbology.PDF417,
                Symbology.POSTAL_4STATE,
                Symbology.POSTAL_AUSTRALIAN,
                Symbology.POSTAL_JAPAN,
                Symbology.POSTAL_KIX,
                Symbology.POSTAL_PLANET,
                Symbology.POSTAL_POSTNET,
                Symbology.POSTAL_ROYALMAIL,
                Symbology.POSTAL_UPUFICS,
                Symbology.QRCODE,
                Symbology.TRIOPTIC,
                Symbology.UPCA,
                Symbology.UPCE,
                Symbology.UPCE1,
                Symbology.NONE
        )
    }
}