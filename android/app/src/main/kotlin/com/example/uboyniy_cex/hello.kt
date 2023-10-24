//package com.scan.demo
//
//import android.R
//import android.app.AlertDialog
//import android.app.FragmentManager
//import android.app.ProgressDialog
//import android.content.*
//import android.device.ScanManager
//import android.device.scanner.configuration.Constants
//import android.device.scanner.configuration.PropertyID
//import android.device.scanner.configuration.Symbology
//import android.device.scanner.configuration.Triggering
//import android.graphics.Bitmap
//import android.graphics.BitmapFactory
//import android.os.AsyncTask
//import android.os.Bundle
//import android.os.Handler
//import android.os.Message
//import android.preference.*
//import android.preference.Preference.OnPreferenceChangeListener
//import android.support.v7.app.AppCompatActivity
//import android.util.Log
//import android.view.*
//import android.view.View.OnTouchListener
//import android.widget.*
//import androidx.appcompat.app.AppCompatActivity
//
///**
// * ScanManagerDemo
// *
// * @author shenpidong
// * @effect Introduce the use of android.device.ScanManager
// * @date 2020-03-06
// * @description , Steps to use ScanManager:
// * 1.Obtain an instance of BarCodeReader with ScanManager scan = new ScanManager().
// * 2.Call openScanner to power on the barcode reader.
// * 3.After that, the default output mode is TextBox Mode that send barcode data to the focused text box. User can check the output mode using getOutputMode and set the output mode using switchOutputMode.
// * 4.Then, the default trigger mode is manually trigger signal. User can check the trigger mode using getTriggerMode and set the trigger mode using setTriggerMode.
// * 5.If necessary, check the current settings using getParameterInts or set the scanner configuration properties PropertyID using setParameterInts.
// * 6.To begin a decode session, call startDecode. If the configured PropertyID.WEDGE_KEYBOARD_ENABLE is 0, your registered broadcast receiver will be called when a successful decode occurs.
// * 7.If the output mode is intent mode, the captured data is sent as an implicit Intent. An application interestes in the scan data should register an action as android.intent.ACTION_DECODE_DATA broadcast listerner.
// * 8.To get a still image through an Android intent. Register the "scanner_capture_image_result" broadcast reception image, trigger the scan to listen to the result output and send the "action.scanner_capture_image" broadcast request to the scan service to output the image.
// * 9.Call stopDecode to end the decode session.
// * 10.Call closeScanner to power off the barcode reader.
// * 11.Can set parameters before closing the scan service.
// */
//class ScanManagerDemo : AppCompatActivity() {
//    private var showScanResult: EditText? = null
//    private var mScan: Button? = null
//    private var mHome: LinearLayout? = null
//    private var mFlagment: FrameLayout? = null
//    private var settings: MenuItem? = null
//    private var mScanImage: ImageView? = null
//    private var mScanManager: ScanManager? = null
//    private var mScanSettingsMenuBarcodeList: FrameLayout? = null
//    private var mScanSettingsMenuBarcode: FrameLayout? = null
//    private var mScanSettingsBarcode: ScanSettingsBarcode? = null
//    private var mSettingsBarcodeList: SettingsBarcodeList? = null
//    private val mScanSettingsFragment = ScanSettingsFragment()
//    private val mReceiver: BroadcastReceiver = object : BroadcastReceiver() {
//        override fun onReceive(context: Context, intent: Intent) {
//            val action = intent.action
//            LogI("onReceive , action:$action")
//            // Get Scan Image . Make sure to make a request before getting a scanned image
//            if (ACTION_CAPTURE_IMAGE == action) {
//                val imagedata = intent.getByteArrayExtra(DECODE_CAPTURE_IMAGE_KEY)
//                if (imagedata != null && imagedata.size > 0) {
//                    val bitmap = BitmapFactory.decodeByteArray(imagedata, 0, imagedata.size)
//                    val msg = mHandler.obtainMessage(MSG_SHOW_SCAN_IMAGE)
//                    msg.obj = bitmap
//                    mHandler.sendMessage(msg)
//                } else {
//                    LogI("onReceive , ignore imagedata:$imagedata")
//                }
//            } else {
//                // Get scan results, including string and byte data etc.
//                val barcode = intent.getByteArrayExtra(DECODE_DATA_TAG)
//                val barcodeLen = intent.getIntExtra(BARCODE_LENGTH_TAG, 0)
//                val temp = intent.getByteExtra(BARCODE_TYPE_TAG, 0.toByte())
//                val barcodeStr = intent.getStringExtra(BARCODE_STRING_TAG)
//                if (mScanCaptureImageShow) {
//                    // Request images of this scan
//                    context.sendBroadcast(Intent(ACTION_DECODE_IMAGE_REQUEST))
//                }
//                LogI("barcode type:$temp")
//                var scanResult = String(barcode!!, 0, barcodeLen)
//                // print scan results.
//                scanResult = """ length：$barcodeLen
//barcode：$scanResult
//bytesToHexString：${bytesToHexString(barcode)}
//barcodeStr:$barcodeStr"""
//                val msg = mHandler.obtainMessage(MSG_SHOW_SCAN_RESULT)
//                msg.obj = scanResult
//                mHandler.sendMessage(msg)
//            }
//        }
//    }
//    private val mHandler: Handler = object : Handler() {
//        override fun handleMessage(msg: Message) {
//            super.handleMessage(msg)
//            when (msg.what) {
//                MSG_SHOW_SCAN_RESULT -> {
//                    val scanResult = msg.obj as String
//                    printScanResult(scanResult)
//                }
//                MSG_SHOW_SCAN_IMAGE -> if (mScanImage != null && mScanCaptureImageShow) {
//                    val bitmap = msg.obj as Bitmap
//                    mScanImage!!.setImageBitmap(bitmap)
//                    mScanImage!!.visibility = View.VISIBLE
//                } else {
//                    mScanCaptureImageShow = false
//                    mScanImage!!.visibility = View.INVISIBLE
//                    LogI("handleMessage , MSG_SHOW_SCAN_IMAGE scan image:$mScanImage")
//                }
//            }
//        }
//    }
//
//    /**
//     * Button helper
//     */
//    internal inner class ButtonListener : View.OnClickListener, OnTouchListener {
//        override fun onClick(v: View) {
//            LogD("ButtonListener onClick")
//        }
//
//        override fun onTouch(v: View, event: MotionEvent): Boolean {
//            if (v.id == R.id.scan_trigger) {
//                if (event.action == MotionEvent.ACTION_UP) {
//                    LogD("onTouch button Up")
//                    mScan.setText(R.string.scan_trigger_start)
//                    if (triggerMode == Triggering.HOST) {
//                        stopDecode()
//                    }
//                }
//                if (event.action == MotionEvent.ACTION_DOWN) {
//                    LogD("onTouch button Down")
//                    mScan.setText(R.string.scan_trigger_end)
//                    startDecode()
//                }
//            }
//            return false
//        }
//    }
//
//    /**
//     * @param register , ture register , false unregister
//     */
//    private fun registerReceiver(register: Boolean) {
//        if (register && mScanManager != null) {
//            val filter = IntentFilter()
//            val idbuf = intArrayOf(PropertyID.WEDGE_INTENT_ACTION_NAME, PropertyID.WEDGE_INTENT_DATA_STRING_TAG)
//            val value_buf = mScanManager!!.getParameterString(idbuf)
//            if (value_buf != null && value_buf[0] != null && value_buf[0] != "") {
//                filter.addAction(value_buf[0])
//            } else {
//                filter.addAction(ACTION_DECODE)
//            }
//            filter.addAction(ACTION_CAPTURE_IMAGE)
//            registerReceiver(mReceiver, filter)
//        } else if (mScanManager != null) {
//            mScanManager!!.stopDecode()
//            unregisterReceiver(mReceiver)
//        }
//    }
//
//    /**
//     * Intent Output Mode print scan results.
//     *
//     * @param msg
//     */
//    private fun printScanResult(msg: String?) {
//        if (msg == null || showScanResult == null) {
//            LogI("printScanResult , ignore to show msg:$msg,showScanResult$showScanResult")
//            return
//        }
//        showScanResult!!.setText(msg)
//    }
//
//    private fun initView() {
//        val enable = getDecodeScanShared(DECODE_ENABLE)
//        mScanEnable = enable
//        showScanResult = findViewById(R.id.scan_result) as EditText?
//        mScan = findViewById(R.id.scan_trigger) as Button?
//        val listener: ButtonListener = ButtonListener()
//        mScan!!.setOnTouchListener(listener)
//        mScan!!.setOnClickListener(listener)
//        mScanImage = findViewById(R.id.scan_image) as ImageView?
//        mScanCaptureImageShow = getDecodeScanShared(DECODE_CAPTURE_IMAGE_SHOW)
//        updateCaptureImage()
//        mFlagment = findViewById(R.id.fl) as FrameLayout?
//        mScanSettingsMenuBarcodeList = findViewById(R.id.flagment_menu_barcode_list) as FrameLayout?
//        mScanSettingsMenuBarcode = findViewById(R.id.flagment_menu_barcode) as FrameLayout?
//        mHome = findViewById(R.id.homeshow) as LinearLayout?
//    }
//
//    private fun updateCaptureImage() {
//        if (mScanImage == null) {
//            LogI("updateCaptureImage ignore.")
//            return
//        }
//        if (mScanCaptureImageShow) {
//            mScanImage!!.visibility = View.VISIBLE
//        } else {
//            mScanImage!!.visibility = View.INVISIBLE
//        }
//    }
//
//    private fun scanSettingsUpdate() {
//        LogD("scanSettingsUpdate")
//        val fm: FragmentManager = this.getFragmentManager()
//        val ft = fm.beginTransaction()
//        mScanSettingsFragment.setScanManagerDemo(this)
//        ft.replace(R.id.fl, mScanSettingsFragment)
//        ft.commit()
//        mScanSettingsView = true
//        mHome!!.visibility = View.GONE
//        mScanBarcodeSettingsMenuBarcodeList = false
//        mScanBarcodeSettingsMenuBarcode = false
//        mScanSettingsMenuBarcode!!.visibility = View.GONE
//        mScanSettingsMenuBarcodeList!!.visibility = View.GONE
//        if (settings != null) {
//            settings!!.isVisible = false
//        }
//        mFlagment!!.visibility = View.VISIBLE
//    }
//
//    /**
//     * helper
//     */
//    private fun scanSettingsBarcodeList() {
//        LogD("scanSettingsBarcodeList")
//        val fm: FragmentManager = this.getFragmentManager()
//        val ft = fm.beginTransaction()
//        mSettingsBarcodeList = SettingsBarcodeList()
//        mSettingsBarcodeList!!.setScanManagerDemo(this)
//        ft.replace(R.id.flagment_menu_barcode_list, mSettingsBarcodeList)
//        ft.commit()
//        mScanSettingsView = true
//        mScanBarcodeSettingsMenuBarcodeList = true
//        mScanBarcodeSettingsMenuBarcode = false
//        mFlagment!!.visibility = View.GONE
//        mHome!!.visibility = View.GONE
//        mScanSettingsMenuBarcode!!.visibility = View.GONE
//        mScanSettingsMenuBarcodeList!!.visibility = View.VISIBLE
//        if (settings != null) {
//            settings!!.isVisible = false
//        }
//    }
//
//    /**
//     * helper
//     */
//    private fun updateScanSettingsBarcode(key: String) {
//        mScanSettingsView = true
//        mScanBarcodeSettingsMenuBarcodeList = true
//        mScanBarcodeSettingsMenuBarcode = true
//        Log.d(TAG, "updateScanSettingsBarcode , key:$key")
//        val fm: FragmentManager = this.getFragmentManager()
//        val ft = fm.beginTransaction()
//        Log.d(TAG, "updateScanSettingsBarcode , isEmpty:")
//        mScanSettingsBarcode = ScanSettingsBarcode()
//        mScanSettingsBarcode!!.setScanManagerDemo(this, key)
//        ft.replace(R.id.flagment_menu_barcode, mScanSettingsBarcode)
//        ft.commit()
//        mHome!!.visibility = View.GONE
//        mFlagment!!.visibility = View.GONE
//        mScanSettingsMenuBarcodeList!!.visibility = View.GONE
//        mScanSettingsMenuBarcode!!.visibility = View.VISIBLE
//        if (settings != null) {
//            settings!!.isVisible = false
//        }
//    }
//
//    private fun getDecodeIntShared(key: String): Int {
//        val sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this)
//        return sharedPrefs.getInt(key, 1)
//    }
//
//    /**
//     * Attribute helper
//     *
//     * @param key
//     * @param value
//     */
//    private fun updateIntShared(key: String?, value: Int) {
//        if (key == null || "" == key.trim { it <= ' ' }) {
//            LogI("updateIntShared , key:$key")
//            return
//        }
//        val sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this)
//        if (value == getDecodeIntShared(key)) {
//            LogI("updateIntShared ,ignore key:$key update.")
//            return
//        }
//        val editor = sharedPrefs.edit()
//        editor.putInt(key, value)
//        editor.apply()
//        editor.commit()
//    }
//
//    private fun getDecodeStringShared(key: String): String? {
//        val sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this)
//        return sharedPrefs.getString(key, "")
//    }
//
//    /**
//     * Attribute helper
//     *
//     * @param key
//     * @param value
//     */
//    private fun updateStringShared(key: String?, value: String) {
//        if (key == null || "" == key.trim { it <= ' ' }) {
//            LogI("updateStringShared , key:$key")
//            return
//        }
//        val sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this)
//        if (value === getDecodeStringShared(key) || "" == value.trim { it <= ' ' }) {
//            LogI("updateStringShared ,ignore key:$key update.")
//            return
//        }
//        val editor = sharedPrefs.edit()
//        editor.putString(key, value)
//        editor.apply()
//        editor.commit()
//    }
//
//    private fun getDecodeScanShared(key: String): Boolean {
//        val sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this)
//        return sharedPrefs.getBoolean(key, true)
//    }
//
//    /**
//     * Attribute helper
//     *
//     * @param key
//     * @param enable
//     */
//    private fun updateScanShared(key: String?, enable: Boolean) {
//        if (key == null || "" == key.trim { it <= ' ' }) {
//            LogI("updateScanShared , key:$key")
//            return
//        }
//        val sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this)
//        if (enable == getDecodeScanShared(key)) {
//            LogI("updateScanShared ,ignore key:$key update.")
//            return
//        }
//        val editor = sharedPrefs.edit()
//        editor.putBoolean(key, enable)
//        editor.apply()
//        editor.commit()
//    }
//
//    private fun initScan() {
//        mScanManager = ScanManager()
//        var powerOn = mScanManager!!.scannerState
//        if (!powerOn) {
//            powerOn = mScanManager!!.openScanner()
//            if (!powerOn) {
//                val builder = AlertDialog.Builder(this)
//                builder.setMessage("Scanner cannot be turned on!")
//                builder.setPositiveButton("OK") { dialog, which -> dialog.dismiss() }
//                val mAlertDialog = builder.create()
//                mAlertDialog.show()
//            }
//        }
//        initBarcodeParameters()
//    }
//
//    /**
//     * ScanManager.getTriggerMode
//     *
//     * @return
//     */
//    private val triggerMode: Triggering
//        private get() = mScanManager!!.triggerMode
//
//    /**
//     * ScanManager.setTriggerMode
//     *
//     * @param mode value : Triggering.HOST, Triggering.CONTINUOUS, or Triggering.PULSE.
//     */
//    private fun setTrigger(mode: Triggering) {
//        val currentMode = triggerMode
//        LogD("setTrigger , mode;$mode,currentMode:$currentMode")
//        if (mode != currentMode) {
//            mScanManager!!.triggerMode = mode
//            if (mode == Triggering.HOST) {
//                DECODE_TRIGGER_MODE_CURRENT = DECODE_TRIGGER_MODE_HOST
//                updateStringShared(DECODE_TRIGGER_MODE, DECODE_TRIGGER_MODE_HOST)
//            } else if (mode == Triggering.CONTINUOUS) {
//                DECODE_TRIGGER_MODE_CURRENT = DECODE_TRIGGER_MODE_CONTINUOUS
//                updateStringShared(DECODE_TRIGGER_MODE, DECODE_TRIGGER_MODE_CONTINUOUS)
//            } else if (mode == Triggering.PULSE) {
//                DECODE_TRIGGER_MODE_CURRENT = DECODE_TRIGGER_MODE_PAUSE
//                updateStringShared(DECODE_TRIGGER_MODE, DECODE_TRIGGER_MODE_PAUSE)
//            }
//        } else {
//            LogI("setTrigger , ignore update Trigger mode:$mode")
//        }
//    }
//    /**
//     * ScanManager.getOutputMode
//     *
//     * @return
//     */
//    /**
//     * ScanManager.switchOutputMode
//     *
//     * @param mode
//     */
//    private var scanOutputMode: Int
//        private get() = mScanManager!!.outputMode
//        private set(mode) {
//            val currentMode = scanOutputMode
//            if (mode != currentMode && (mode == DECODE_OUTPUT_MODE_FOCUS ||
//                            mode == DECODE_OUTPUT_MODE_INTENT)) {
//                mScanManager!!.switchOutputMode(mode)
//                if (mode == DECODE_OUTPUT_MODE_FOCUS) {
//                    DECODE_OUTPUT_MODE_CURRENT = DECODE_OUTPUT_MODE_FOCUS
//                    updateIntShared(DECODE_OUTPUT_MODE, DECODE_OUTPUT_MODE_FOCUS)
//                } else if (mode == DECODE_OUTPUT_MODE_INTENT) {
//                    DECODE_OUTPUT_MODE_CURRENT = DECODE_OUTPUT_MODE_INTENT
//                    updateIntShared(DECODE_OUTPUT_MODE, DECODE_OUTPUT_MODE_INTENT)
//                }
//            } else {
//                LogI("setScanOutputMode , ignore update Output mode:$mode")
//            }
//        }
//
//    private fun resetScanner() {
//        showResetDialog()
//    }
//
//    /**
//     * ScanManager.getTriggerLockState
//     *
//     * @return
//     */
//    private fun getlockTriggerState(): Boolean {
//        return mScanManager!!.triggerLockState
//    }
//
//    /**
//     * ScanManager.lockTrigger and ScanManager.unlockTrigger
//     *
//     * @param state value ture or false
//     */
//    private fun updateLockTriggerState(state: Boolean) {
//        val currentState = getlockTriggerState()
//        if (state != currentState) {
//            if (state) {
//                mScanManager!!.lockTrigger()
//            } else {
//                mScanManager!!.unlockTrigger()
//            }
//        } else {
//            LogI("updateLockTriggerState , ignore update lockTrigger state:$state")
//        }
//    }
//
//    /**
//     * ScanManager.startDecode
//     */
//    private fun startDecode() {
//        if (!mScanEnable) {
//            LogI("startDecode ignore, Scan enable:" + mScanEnable)
//            return
//        }
//        val lockState = getlockTriggerState()
//        if (lockState) {
//            LogI("startDecode ignore, Scan lockTrigger state:$lockState")
//            return
//        }
//        if (mScanManager != null) {
//            mScanManager!!.startDecode()
//        }
//    }
//
//    /**
//     * ScanManager.stopDecode
//     */
//    private fun stopDecode() {
//        if (!mScanEnable) {
//            LogI("stopDecode ignore, Scan enable:" + mScanEnable)
//            return
//        }
//        if (mScanManager != null) {
//            mScanManager!!.stopDecode()
//        }
//    }
//
//    /**
//     * ScanManager.closeScanner
//     *
//     * @return
//     */
//    private fun closeScanner(): Boolean {
//        var state = false
//        if (mScanManager != null) {
//            mScanManager!!.stopDecode()
//            state = mScanManager!!.closeScanner()
//        }
//        return state
//    }
//
//    /**
//     * Obtain an instance of BarCodeReader with ScanManager
//     * ScanManager.getScannerState
//     * ScanManager.openScanner
//     * ScanManager.enableAllSymbologies
//     *
//     * @return
//     */
//    private fun openScanner(): Boolean {
//        mScanManager = ScanManager()
//        var powerOn = mScanManager!!.scannerState
//        if (!powerOn) {
//            powerOn = mScanManager!!.openScanner()
//            if (!powerOn) {
//                val builder = AlertDialog.Builder(this)
//                builder.setMessage("Scanner cannot be turned on!")
//                builder.setPositiveButton("OK") { dialog, which -> dialog.dismiss() }
//                val mAlertDialog = builder.create()
//                mAlertDialog.show()
//            }
//        }
//        mScanManager!!.enableAllSymbologies(true) // or execute enableSymbologyDemo() || enableSymbologyDemo2() is the same.
//        setTrigger(triggerMode)
//        scanOutputMode = scanOutputMode
//        return powerOn
//    }
//
//    /**
//     * ScanManager.enableSymbology
//     *
//     * @param symbology
//     * @param enable
//     * @return
//     */
//    private fun enableSymbology(symbology: Symbology, enable: Boolean): Boolean {
//        var result = false
//        val isSupportBarcode = mScanManager!!.isSymbologySupported(symbology)
//        if (isSupportBarcode) {
//            val isEnableBarcode = mScanManager!!.isSymbologyEnabled(symbology)
//            if (!isEnableBarcode) {
//                mScanManager!!.enableSymbology(symbology, enable)
//                result = true
//            } else {
//                result = isEnableBarcode
//                LogI("enableSymbology , ignore $symbology barcode is enable.")
//            }
//        } else {
//            LogI("enableSymbology , ignore $symbology barcode not Support.")
//        }
//        return result
//    }
//
//    /**
//     * ScanManager.getParameterInts
//     *
//     * @param ids
//     * @return
//     */
//    private fun getParameterInts(ids: IntArray?): IntArray {
//        return mScanManager!!.getParameterInts(ids)
//    }
//
//    /**
//     * ScanManager.setParameterInts
//     *
//     * @param ids
//     * @param values
//     */
//    private fun setParameterInts(ids: IntArray, values: IntArray) {
//        mScanManager!!.setParameterInts(ids, values)
//    }
//
//    /**
//     * ScanManager.getParameterString
//     *
//     * @param ids
//     * @return
//     */
//    private fun getParameterString(ids: IntArray): Array<String> {
//        return mScanManager!!.getParameterString(ids)
//    }
//
//    /**
//     * ScanManager.setParameterString
//     *
//     * @param ids
//     * @param values
//     * @return
//     */
//    private fun setParameterString(ids: IntArray, values: Array<String>): Boolean {
//        return mScanManager!!.setParameterString(ids, values)
//    }
//
//    protected fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        val window: Window = netscape.javascript.JSObject.getWindow()
//        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
//        setContentView(R.layout.activity_scan_manager_demo)
//        initView()
//    }
//
//    fun onBackPressed() {
//        if (mScanBarcodeSettingsMenuBarcode) {
//            mScanBarcodeSettingsMenuBarcode = false
//            mHome!!.visibility = View.GONE
//            mFlagment!!.visibility = View.GONE
//            mScanSettingsMenuBarcode!!.visibility = View.GONE
//            mScanSettingsMenuBarcodeList!!.visibility = View.VISIBLE
//            if (settings != null) {
//                settings!!.isVisible = false
//            }
//        } else if (mScanBarcodeSettingsMenuBarcodeList) {
//            mScanBarcodeSettingsMenuBarcodeList = false
//            mHome!!.visibility = View.GONE
//            mFlagment!!.visibility = View.VISIBLE
//            mScanSettingsMenuBarcode!!.visibility = View.GONE
//            mScanSettingsMenuBarcodeList!!.visibility = View.GONE
//            if (settings != null) {
//                settings!!.isVisible = false
//            }
//        } else if (mScanSettingsView) {
//            mHome!!.visibility = View.VISIBLE
//            mFlagment!!.visibility = View.GONE
//            if (settings != null) {
//                settings!!.isVisible = true
//            }
//            mScanSettingsView = false
//        } else {
//            super.onBackPressed()
//        }
//        LogI("onBackPressed")
//    }
//
//    protected fun onPause() {
//        super.onPause()
//        registerReceiver(false)
//    }
//
//    protected fun onResume() {
//        super.onResume()
//        initScan()
//        registerReceiver(true)
//    }
//
//    protected fun onDestroy() {
//        super.onDestroy()
//    }
//
//    fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
//        LogD("onKeyUp, keyCode:$keyCode")
//        if (keyCode >= SCAN_KEYCODE[0] && keyCode <= SCAN_KEYCODE[SCAN_KEYCODE.size - 1]) {
//        }
//        return super.onKeyUp(keyCode, event)
//    }
//
//    fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
//        LogD("onKeyDown, keyCode:$keyCode")
//        if (keyCode >= SCAN_KEYCODE[0] && keyCode <= SCAN_KEYCODE[SCAN_KEYCODE.size - 1]) {
//        }
//        return super.onKeyDown(keyCode, event)
//    }
//
//    /**
//     * Top right corner setting button
//     *
//     * @param menu
//     * @return
//     */
//    fun onCreateOptionsMenu(menu: Menu): Boolean {
//        settings = menu.add(0, 1, 0, R.string.scan_settings).setIcon(R.drawable.ic_action_settings)
//        settings!!.setShowAsAction(1)
//        return super.onCreateOptionsMenu(menu)
//    }
//
//    /**
//     * Set the button monitor in the upper right corner
//     *
//     * @param item
//     * @return
//     */
//    fun onOptionsItemSelected(item: MenuItem): Boolean {
//        LogD("onOptionsItemSelected, item:" + item.itemId)
//        when (item.itemId) {
//            1 -> scanSettingsUpdate()
//        }
//        return super.onOptionsItemSelected(item)
//    }
//
//    private fun LogD(msg: String) {
//        if (DEBUG) {
//            Log.d(TAG, msg)
//        }
//    }
//
//    private fun LogI(msg: String) {
//        Log.i(TAG, msg)
//    }
//
//    /**
//     * Reset Auxiliary dialog
//     */
//    private fun showResetDialog() {
//        val builder = AlertDialog.Builder(this)
//        builder.setMessage(R.string.scan_reset_def_alert)
//        builder.setTitle(R.string.scan_reset_def)
//        builder.setPositiveButton(R.string.yes) { dialog, which ->
//            val task: ResetAsyncTask = ResetAsyncTask(this@ScanManagerDemo)
//            task.execute("reset")
//            dialog.dismiss()
//        }
//        builder.setNegativeButton(R.string.no) { dialog, which -> dialog.dismiss() }
//        builder.create().show()
//    }
//
//    /**
//     * Perform reset operation class
//     */
//    internal inner class ResetAsyncTask(private val mContext: Context) : AsyncTask<String?, String?, Int>() {
//        private var pdialog: ProgressDialog? = null
//        override fun onPreExecute() {
//            // TODO Auto-generated method stub
//            super.onPreExecute()
//            pdialog = ProgressDialog(mContext)
//            pdialog!!.setMessage(mContext.resources.getString(R.string.scan_reset_progress))
//            pdialog!!.setProgressStyle(ProgressDialog.STYLE_SPINNER)
//            pdialog!!.setCancelable(false)
//            pdialog!!.show()
//        }
//
//        /**
//         * ScanManager.resetScannerParameters
//         *
//         * @param params
//         * @return
//         */
//        protected override fun doInBackground(vararg params: String): Int {
//            // TODO Auto-generated method stub
//            try {
//                mScanManager!!.resetScannerParameters()
//                scanOutputMode = DECODE_OUTPUT_MODE_FOCUS
//                Thread.sleep(500)
//            } catch (e: Exception) {
//                e.printStackTrace()
//            }
//            return 1
//        }
//
//        override fun onPostExecute(result: Int) {
//            // TODO Auto-generated method stub
//            super.onPostExecute(result)
//            if (pdialog != null) pdialog!!.dismiss()
//            mScanSettingsFragment.resetScan()
//            Toast.makeText(mContext,
//                    R.string.scanner_toast, Toast.LENGTH_LONG).show()
//        }
//    }
//
//    /**
//     * mBarcodeMap helper
//     */
//    private fun initBarcodeParameters() {
//        mBarcodeMap.clear()
//        var holder = BarcodeHolder()
//        // Symbology.AZTEC
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.AZTEC_ENABLE)
//        holder.mParaKeys = arrayOf<String>("AZTEC_ENABLE")
//        mBarcodeMap[Symbology.AZTEC.toString() + ""] = holder
//        // Symbology.CHINESE25
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.C25_ENABLE)
//        holder.mParaKeys = arrayOf("C25_ENABLE")
//        mBarcodeMap[Symbology.CHINESE25.toString() + ""] = holder
//        // Symbology.CODABAR
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeLength1 = EditTextPreference(this)
//        holder.mBarcodeLength2 = EditTextPreference(this)
//        holder.mBarcodeNOTIS = CheckBoxPreference(this)
//        holder.mBarcodeCLSI = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.CODABAR_ENABLE, PropertyID.CODABAR_LENGTH1, PropertyID.CODABAR_LENGTH2, PropertyID.CODABAR_NOTIS, PropertyID.CODABAR_CLSI)
//        holder.mParaKeys = arrayOf("CODABAR_ENABLE", "CODABAR_LENGTH1", "CODABAR_LENGTH2", "CODABAR_NOTIS", "CODABAR_CLSI")
//        mBarcodeMap[Symbology.CODABAR.toString() + ""] = holder
//        // Symbology.CODE11
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeLength1 = EditTextPreference(this)
//        holder.mBarcodeLength2 = EditTextPreference(this)
//        holder.mBarcodeCheckDigit = ListPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.CODE11_ENABLE, PropertyID.CODE11_LENGTH1, PropertyID.CODE11_LENGTH2, PropertyID.CODE11_SEND_CHECK)
//        holder.mParaKeys = arrayOf("CODE11_ENABLE", "CODE11_LENGTH1", "CODE11_LENGTH2", "CODE11_SEND_CHECK")
//        mBarcodeMap[Symbology.CODE11.toString() + ""] = holder
//        // Symbology.CODE32
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.CODE32_ENABLE)
//        holder.mParaKeys = arrayOf("CODE32_ENABLE")
//        mBarcodeMap[Symbology.CODE32.toString() + ""] = holder
//        // Symbology.CODE39
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeLength1 = EditTextPreference(this)
//        holder.mBarcodeLength2 = EditTextPreference(this)
//        holder.mBarcodeChecksum = CheckBoxPreference(this)
//        holder.mBarcodeSendCheck = CheckBoxPreference(this)
//        holder.mBarcodeFullASCII = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.CODE39_ENABLE, PropertyID.CODE39_LENGTH1, PropertyID.CODE39_LENGTH2, PropertyID.CODE39_ENABLE_CHECK, PropertyID.CODE39_SEND_CHECK, PropertyID.CODE39_FULL_ASCII)
//        holder.mParaKeys = arrayOf("CODE39_ENABLE", "CODE39_LENGTH1", "CODE39_LENGTH2", "CODE39_ENABLE_CHECK", "CODE39_SEND_CHECK", "CODE39_FULL_ASCII")
//        mBarcodeMap[Symbology.CODE39.toString() + ""] = holder
//        // Symbology.CODE93
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeLength1 = EditTextPreference(this)
//        holder.mBarcodeLength2 = EditTextPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.CODE93_ENABLE, PropertyID.CODE93_LENGTH1, PropertyID.CODE93_LENGTH2)
//        holder.mParaKeys = arrayOf("CODE93_ENABLE", "CODE93_LENGTH1", "CODE93_LENGTH2")
//        mBarcodeMap[Symbology.CODE93.toString() + ""] = holder
//        // Symbology.CODE128
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeLength1 = EditTextPreference(this)
//        holder.mBarcodeLength2 = EditTextPreference(this)
//        holder.mBarcodeISBT = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.CODE128_ENABLE, PropertyID.CODE128_LENGTH1, PropertyID.CODE128_LENGTH2, PropertyID.CODE128_CHECK_ISBT_TABLE)
//        holder.mParaKeys = arrayOf("CODE128_ENABLE", "CODE128_LENGTH1", "CODE128_LENGTH2", "CODE128_CHECK_ISBT_TABLE")
//        mBarcodeMap[Symbology.CODE128.toString() + ""] = holder
//        // Symbology.COMPOSITE_CC_AB
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.COMPOSITE_CC_AB_ENABLE)
//        holder.mParaKeys = arrayOf("COMPOSITE_CC_AB_ENABLE")
//        mBarcodeMap[Symbology.COMPOSITE_CC_AB.toString() + ""] = holder
//        // Symbology.COMPOSITE_CC_C
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.COMPOSITE_CC_C_ENABLE)
//        holder.mParaKeys = arrayOf("COMPOSITE_CC_C_ENABLE")
//        mBarcodeMap[Symbology.COMPOSITE_CC_C.toString() + ""] = holder
//        // Symbology.DATAMATRIX
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.DATAMATRIX_ENABLE)
//        holder.mParaKeys = arrayOf("DATAMATRIX_ENABLE")
//        mBarcodeMap[Symbology.DATAMATRIX.toString() + ""] = holder
//        // Symbology.DISCRETE25
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.D25_ENABLE)
//        holder.mParaKeys = arrayOf("D25_ENABLE")
//        mBarcodeMap[Symbology.DISCRETE25.toString() + ""] = holder
//        // Symbology.EAN8
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.EAN8_ENABLE)
//        holder.mParaKeys = arrayOf("EAN8_ENABLE")
//        mBarcodeMap[Symbology.EAN8.toString() + ""] = holder
//        // Symbology.EAN13
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeBookland = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.EAN13_ENABLE, PropertyID.EAN13_BOOKLANDEAN)
//        holder.mParaKeys = arrayOf("EAN13_ENABLE", "EAN13_BOOKLANDEAN")
//        mBarcodeMap[Symbology.EAN13.toString() + ""] = holder
//        // Symbology.GS1_14
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.GS1_14_ENABLE)
//        holder.mParaKeys = arrayOf("GS1_14_ENABLE")
//        mBarcodeMap[Symbology.GS1_14.toString() + ""] = holder
//        // Symbology.GS1_128
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.CODE128_GS1_ENABLE)
//        holder.mParaKeys = arrayOf("CODE128_GS1_ENABLE")
//        mBarcodeMap[Symbology.GS1_128.toString() + ""] = holder
//        // Symbology.GS1_EXP
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeLength1 = EditTextPreference(this)
//        holder.mBarcodeLength2 = EditTextPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.GS1_EXP_ENABLE, PropertyID.GS1_EXP_LENGTH1, PropertyID.GS1_EXP_LENGTH2)
//        holder.mParaKeys = arrayOf("GS1_EXP_ENABLE", "GS1_EXP_LENGTH1", "GS1_EXP_LENGTH2")
//        mBarcodeMap[Symbology.GS1_EXP.toString() + ""] = holder
//        // Symbology.GS1_LIMIT
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.GS1_LIMIT_ENABLE)
//        holder.mParaKeys = arrayOf("GS1_LIMIT_ENABLE")
//        mBarcodeMap[Symbology.GS1_LIMIT.toString() + ""] = holder
//        // Symbology.INTERLEAVED25
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeLength1 = EditTextPreference(this)
//        holder.mBarcodeLength2 = EditTextPreference(this)
//        holder.mBarcodeChecksum = CheckBoxPreference(this)
//        holder.mBarcodeSendCheck = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.I25_ENABLE, PropertyID.I25_LENGTH1, PropertyID.I25_LENGTH2, PropertyID.I25_ENABLE_CHECK, PropertyID.I25_SEND_CHECK)
//        holder.mParaKeys = arrayOf("I25_ENABLE", "I25_LENGTH1", "I25_LENGTH2", "I25_ENABLE_CHECK", "I25_SEND_CHECK")
//        mBarcodeMap[Symbology.INTERLEAVED25.toString() + ""] = holder
//        // Symbology.MATRIX25
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.M25_ENABLE)
//        holder.mParaKeys = arrayOf("M25_ENABLE")
//        mBarcodeMap[Symbology.MATRIX25.toString() + ""] = holder
//        // Symbology.MAXICODE
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.MAXICODE_ENABLE)
//        holder.mParaKeys = arrayOf("MAXICODE_ENABLE")
//        mBarcodeMap[Symbology.MAXICODE.toString() + ""] = holder
//        // Symbology.MICROPDF417
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.MICROPDF417_ENABLE)
//        holder.mParaKeys = arrayOf("MICROPDF417_ENABLE")
//        mBarcodeMap[Symbology.MICROPDF417.toString() + ""] = holder
//        // Symbology.MSI
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeLength1 = EditTextPreference(this)
//        holder.mBarcodeLength2 = EditTextPreference(this)
//        holder.mBarcodeSecondChecksum = CheckBoxPreference(this)
//        holder.mBarcodeSendCheck = CheckBoxPreference(this)
//        holder.mBarcodeSecondChecksumMode = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.MSI_ENABLE, PropertyID.MSI_LENGTH1, PropertyID.MSI_LENGTH2, PropertyID.MSI_REQUIRE_2_CHECK, PropertyID.MSI_SEND_CHECK, PropertyID.MSI_CHECK_2_MOD_11)
//        holder.mParaKeys = arrayOf("MSI_ENABLE", "MSI_LENGTH1", "MSI_LENGTH2", "MSI_REQUIRE_2_CHECK", "MSI_SEND_CHECK", "MSI_CHECK_2_MOD_11")
//        mBarcodeMap[Symbology.MSI.toString() + ""] = holder
//        // Symbology.PDF417
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.PDF417_ENABLE)
//        holder.mParaKeys = arrayOf("PDF417_ENABLE")
//        mBarcodeMap[Symbology.PDF417.toString() + ""] = holder
//        // Symbology.QRCODE
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.QRCODE_ENABLE)
//        holder.mParaKeys = arrayOf("QRCODE_ENABLE")
//        mBarcodeMap[Symbology.QRCODE.toString() + ""] = holder
//        // Symbology.TRIOPTIC
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.TRIOPTIC_ENABLE)
//        holder.mParaKeys = arrayOf("TRIOPTIC_ENABLE")
//        mBarcodeMap[Symbology.TRIOPTIC.toString() + ""] = holder
//        // Symbology.UPCA
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeChecksum = CheckBoxPreference(this)
//        holder.mBarcodeSystemDigit = CheckBoxPreference(this)
//        holder.mBarcodeConvertEAN13 = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.UPCA_ENABLE, PropertyID.UPCA_SEND_CHECK, PropertyID.UPCA_SEND_SYS, PropertyID.UPCA_TO_EAN13)
//        holder.mParaKeys = arrayOf("UPCA_ENABLE", "UPCA_SEND_CHECK", "UPCA_SEND_SYS", "UPCA_TO_EAN13")
//        mBarcodeMap[Symbology.UPCA.toString() + ""] = holder
//        // Symbology.UPCE
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mBarcodeChecksum = CheckBoxPreference(this)
//        holder.mBarcodeSystemDigit = CheckBoxPreference(this)
//        holder.mBarcodeConvertUPCA = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.UPCE_ENABLE, PropertyID.UPCE_SEND_CHECK, PropertyID.UPCE_SEND_SYS, PropertyID.UPCE_TO_UPCA)
//        holder.mParaKeys = arrayOf("UPCE_ENABLE", "UPCE_SEND_CHECK", "UPCE_SEND_SYS", "UPCE_TO_UPCA")
//        mBarcodeMap[Symbology.UPCE.toString() + ""] = holder
//        // Symbology.UPCE1
//        holder = BarcodeHolder()
//        holder.mBarcodeEnable = CheckBoxPreference(this)
//        holder.mParaIds = intArrayOf(PropertyID.UPCE1_ENABLE)
//        holder.mParaKeys = arrayOf("UPCE1_ENABLE")
//        mBarcodeMap[Symbology.UPCE1.toString() + ""] = holder
//    }
//
//    /**
//     * ScanSettingsBarcode helper
//     */
//    class ScanSettingsBarcode : PreferenceFragment(), OnPreferenceChangeListener {
//        private var root: PreferenceScreen? = null
//        private var mScanDemo: ScanManagerDemo? = null
//        private var mBarcodeKey: String? = null
//        var entries = arrayOf<CharSequence>("Two check digits", "One check digits", "Two check digits and stripped", "One check digits and stripped")
//        var entryValues = arrayOf<CharSequence>("0", "1", "2", "3")
//        override fun onCreate(@Nullable savedInstanceState: Bundle?) {
//            super.onCreate(savedInstanceState)
//            addPreferencesFromResource(R.xml.scan_settings_pro)
//            Log.d(TAG, "onCreate , Barcode ,root:$root")
//        }
//
//        override fun onDestroyView() {
//            super.onDestroyView()
//            Log.d(TAG, "onDestroyView , Barcode ")
//        }
//
//        override fun onDestroy() {
//            super.onDestroy()
//            root = this.preferenceScreen
//            if (root != null) {
//                root!!.removeAll()
//            }
//            Log.d(TAG, "onDestroy , Barcode ,root:$root")
//        }
//
//        override fun onStart() {
//            super.onStart()
//            Log.d(TAG, "onStart , Barcode ")
//        }
//
//        override fun onResume() {
//            Log.d(TAG, "onResume , Barcode ")
//            super.onResume()
//            initSymbology()
//        }
//
//        override fun onStop() {
//            super.onStop()
//            Log.d(TAG, "onStop , Barcode ")
//        }
//
//        /**
//         * Use mBarcodeMap, key:Symbology enums toString , value:BarcodeHolder class
//         */
//        private fun initSymbology() {
//            Log.d(TAG, "initSymbology , Barcode mBarcodeKey:$mBarcodeKey")
//            if (mBarcodeKey != null) {
//                val barcodeHolder = mBarcodeMap[mBarcodeKey]
//                if (barcodeHolder != null) {
//                    // barcodeHolder.mParaIds are PropertyID Attributes , Example: PropertyID.QRCODE_ENABLE/PropertyID.EAN13_ENABLE/PropertyID.CODE128_ENABLE etc.
//                    val values = mScanDemo!!.getParameterInts(barcodeHolder.mParaIds)
//                    var valuesLength = 0
//                    if (values != null) {
//                        valuesLength = values.size
//                    }
//                    if (barcodeHolder.mBarcodeEnable == null || valuesLength <= 0) {
//                        Log.d(TAG, "initSymbology , ignore barcode enable:" + barcodeHolder.mBarcodeEnable + ",para value:" + valuesLength)
//                        return
//                    }
//                    var indexCount = valuesLength
//                    Log.d(TAG, "initSymbology , Barcode initSymbology ,indexCount:$indexCount")
//                    if (barcodeHolder.mBarcodeEnable != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeEnable!!.title = mBarcodeKey
//                        barcodeHolder.mBarcodeEnable!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeEnable!!.summary = mBarcodeKey
//                        barcodeHolder.mBarcodeEnable!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeEnable!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeEnable)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeLength1 != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeLength1!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeLength1!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeLength1!!.summary = values[valuesLength - indexCount].toString() + ""
//                        barcodeHolder.mBarcodeLength1!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeLength1)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeLength2 != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeLength2!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeLength2!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeLength2!!.summary = values[valuesLength - indexCount].toString() + ""
//                        barcodeHolder.mBarcodeLength2!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeLength2)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeNOTIS != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeNOTIS!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeNOTIS!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeNOTIS!!.summary = "$mBarcodeKey NOTIS"
//                        barcodeHolder.mBarcodeNOTIS!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeNOTIS!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeNOTIS)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeCLSI != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeCLSI!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeCLSI!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeCLSI!!.summary = "$mBarcodeKey CLSI"
//                        barcodeHolder.mBarcodeCLSI!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeCLSI!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeCLSI)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeISBT != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeISBT!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeISBT!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeISBT!!.summary = "$mBarcodeKey CLSI128"
//                        barcodeHolder.mBarcodeISBT!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeISBT!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeISBT)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeChecksum != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeChecksum!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeChecksum!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeChecksum!!.summary = "$mBarcodeKey Checksum"
//                        barcodeHolder.mBarcodeChecksum!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeChecksum!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeChecksum)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeSendCheck != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeSendCheck!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeSendCheck!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeSendCheck!!.summary = "$mBarcodeKey SendCheck"
//                        barcodeHolder.mBarcodeSendCheck!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeSendCheck!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeSendCheck)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeFullASCII != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeFullASCII!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeFullASCII!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeFullASCII!!.summary = "$mBarcodeKey Full ASCII"
//                        barcodeHolder.mBarcodeFullASCII!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeFullASCII!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeFullASCII)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeCheckDigit != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeCheckDigit!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeCheckDigit!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeCheckDigit!!.entries = entries
//                        barcodeHolder.mBarcodeCheckDigit!!.entryValues = entryValues
//                        barcodeHolder.mBarcodeCheckDigit!!.value = entryValues[values[valuesLength - indexCount]].toString()
//                        barcodeHolder.mBarcodeCheckDigit!!.summary = entries[values[valuesLength - indexCount]]
//                        barcodeHolder.mBarcodeCheckDigit!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeCheckDigit)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeBookland != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeBookland!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeBookland!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeBookland!!.summary = "$mBarcodeKey Bookland"
//                        barcodeHolder.mBarcodeBookland!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeBookland!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeBookland)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeSecondChecksum != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeSecondChecksum!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeSecondChecksum!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeSecondChecksum!!.summary = "$mBarcodeKey Second Checksum"
//                        barcodeHolder.mBarcodeSecondChecksum!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeSecondChecksum!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeSecondChecksum)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeSecondChecksumMode != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeSecondChecksumMode!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeSecondChecksumMode!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeSecondChecksumMode!!.summary = "$mBarcodeKey Second Checksum Mode 11"
//                        barcodeHolder.mBarcodeSecondChecksumMode!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeSecondChecksumMode!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeSecondChecksumMode)
//                        indexCount--
//                    }
//                    // PostalCode
//                    /*if(barcodeHolder.mBarcodePostalCode!=null && (indexCount > 0)) {
//                        barcodeHolder.mBarcodePostalCode.setTitle(barcodeHolder.mParaKeys[valuesLength - indexCount]);
//                        barcodeHolder.mBarcodePostalCode.setKey(barcodeHolder.mParaKeys[valuesLength - indexCount]);
//                        barcodeHolder.mBarcodePostalCode.setSummary(values[valuesLength - indexCount]);
//                        barcodeHolder.mBarcodePostalCode.setOnPreferenceChangeListener(this);
//                        this.getPreferenceScreen().addPreference(barcodeHolder.mBarcodePostalCode);
//                        indexCount--;
//                    }*/if (barcodeHolder.mBarcodeSystemDigit != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeSystemDigit!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeSystemDigit!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeSystemDigit!!.summary = "$mBarcodeKey System Digit"
//                        barcodeHolder.mBarcodeSystemDigit!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeSystemDigit!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeSystemDigit)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeConvertEAN13 != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeConvertEAN13!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeConvertEAN13!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeConvertEAN13!!.summary = "$mBarcodeKey Convert to EAN13"
//                        barcodeHolder.mBarcodeConvertEAN13!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeConvertEAN13!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeConvertEAN13)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeConvertUPCA != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeConvertUPCA!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeConvertUPCA!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeConvertUPCA!!.summary = "$mBarcodeKey Convert to UPCA"
//                        barcodeHolder.mBarcodeConvertUPCA!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeConvertUPCA!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeConvertUPCA)
//                        indexCount--
//                    }
//                    if (barcodeHolder.mBarcodeEanble25DigitExtensions != null && indexCount > 0) {
//                        barcodeHolder.mBarcodeEanble25DigitExtensions!!.title = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeEanble25DigitExtensions!!.key = barcodeHolder.mParaKeys!![valuesLength - indexCount]
//                        barcodeHolder.mBarcodeEanble25DigitExtensions!!.summary = "$mBarcodeKey Enable 2-5 Digit Extensions"
//                        barcodeHolder.mBarcodeEanble25DigitExtensions!!.isChecked = values[valuesLength - indexCount] == 1
//                        barcodeHolder.mBarcodeEanble25DigitExtensions!!.onPreferenceChangeListener = this
//                        this.preferenceScreen.addPreference(barcodeHolder.mBarcodeEanble25DigitExtensions)
//                        indexCount--
//                    }
//                }
//            }
//        }
//
//        fun setScanManagerDemo(demo: ScanManagerDemo?, key: String?) {
//            mScanDemo = demo
//            mBarcodeKey = key
//        }
//
//        /**
//         * helper
//         */
//        private fun updateParameter(key: String, obj: Any) {
//            if (mBarcodeKey != null) {
//                val barcodeHolder = mBarcodeMap[mBarcodeKey]
//                if (barcodeHolder != null) {
//                    if (barcodeHolder.mParaKeys != null && barcodeHolder.mParaKeys!!.size > 0) {
//                        var index = 0
//                        for (i in barcodeHolder.mParaKeys!!.indices) {
//                            if (key == barcodeHolder.mParaKeys!![i]) {
//                                Log.d(TAG, "onPreferenceChange , index:$index,key:$key")
//                                break
//                            }
//                            index++
//                        }
//                        val idBuff = intArrayOf(barcodeHolder.mParaIds!![index])
//                        val valueBuff = IntArray(1)
//                        if (obj is Boolean) {
//                            valueBuff[0] = if (obj) 1 else 0
//                        } else if (obj is String) {
//                            val value = Integer.valueOf(obj)
//                            valueBuff[0] = value
//                        }
//                        mScanDemo!!.setParameterInts(idBuff, valueBuff)
//                    }
//                }
//            }
//        }
//
//        override fun onPreferenceTreeClick(preferenceScreen: PreferenceScreen, preference: Preference): Boolean {
//            val key = preference.key
//            Log.d(TAG, "onPreferenceTreeClick preference:$preference,key:$key")
//            if (preference is EditTextPreference) {
//                val editTextPreference = findPreference(key) as EditTextPreference
//                editTextPreference?.editText?.setText(editTextPreference.summary)
//            }
//            return super.onPreferenceTreeClick(preferenceScreen, preference)
//        }
//
//        override fun onPreferenceChange(preference: Preference, newValue: Any): Boolean {
//            val key = preference.key
//            Log.d(TAG, "onPreferenceChange ,preference:$preference,key:$key,mBarcodeKey:$mBarcodeKey,newValue:$newValue")
//            if (preference is CheckBoxPreference) {
//                val value = newValue as Boolean
//                val checkBox = findPreference(key) as CheckBoxPreference
//                checkBox.isChecked = value
//                updateParameter(key, newValue)
//            } else if (preference is EditTextPreference) {
//                val value = newValue as String
//                val editTextPreference = findPreference(key) as EditTextPreference
//                if (editTextPreference != null) {
//                    editTextPreference.summary = value
//                }
//                updateParameter(key, newValue)
//            } else if (preference is ListPreference) {
//                val value = newValue as String
//                val `val` = value.toInt()
//                val listPreference = findPreference(key) as ListPreference
//                if (listPreference != null) {
//                    listPreference.value = value
//                    listPreference.summary = entries[`val`]
//                }
//                updateParameter(key, newValue)
//                Log.d(TAG, "onPreferenceChange ------------ preference:ListPreference")
//            }
//            return false
//        }
//    }
//
//    /**
//     * SettingsBarcodeList helper
//     */
//    class SettingsBarcodeList : PreferenceFragment(), OnPreferenceChangeListener {
//        private var root: PreferenceScreen? = null
//        private var mBarcode: Preference? = null
//        private var mScanDemo: ScanManagerDemo? = null
//        override fun onCreate(@Nullable savedInstanceState: Bundle?) {
//            super.onCreate(savedInstanceState)
//            root = this.preferenceScreen
//            if (root != null) {
//                root!!.removeAll()
//            }
//            addPreferencesFromResource(R.xml.scan_settings_pro)
//            Log.d(TAG, "onCreate , ,root:$root") //Symbology s = BARCODE_SUPPORT_SYMBOLOGY[9];
//            initSymbology()
//        }
//
//        /**
//         * Use Symbology enumeration
//         */
//        private fun initSymbology() {
//            if (mScanDemo != null) {
//                val length = BARCODE_SUPPORT_SYMBOLOGY.size
//                Log.d(TAG, "initSymbology  length : $length")
//                for (i in 0 until length) {
//                    if (mScanDemo != null && mScanDemo!!.isSymbologySupported(BARCODE_SUPPORT_SYMBOLOGY[i])) {
//                        mBarcode = Preference(mScanDemo)
//                        mBarcode!!.title = BARCODE_SUPPORT_SYMBOLOGY[i].toString() + ""
//                        mBarcode!!.key = BARCODE_SUPPORT_SYMBOLOGY[i].toString() + ""
//                        this.preferenceScreen.addPreference(mBarcode)
//                    } else {
//                        Log.d(TAG, "initSymbology , Not Support Barcode " + BARCODE_SUPPORT_SYMBOLOGY[i])
//                    }
//                }
//            }
//        }
//
//        fun setScanManagerDemo(demo: ScanManagerDemo?) {
//            mScanDemo = demo
//        }
//
//        override fun onPreferenceTreeClick(preferenceScreen: PreferenceScreen, preference: Preference): Boolean {
//            Log.d(TAG, "onPreferenceTreeClick preference:$preference")
//            val key = preference.key
//            if (key != null) {
//                mScanDemo!!.updateScanSettingsBarcode(key)
//            }
//            return super.onPreferenceTreeClick(preferenceScreen, preference)
//        }
//
//        override fun onPreferenceChange(preference: Preference, newValue: Any): Boolean {
//            return false
//        }
//    }
//
//    private fun isSymbologySupported(symbology: Symbology): Boolean {
//        var isSupport = false
//        if (mScanManager != null) {
//            isSupport = mScanManager!!.isSymbologySupported(symbology)
//        }
//        return isSupport
//    }
//
//    /**
//     * Menu helper
//     */
//    class ScanSettingsFragment : PreferenceFragment(), OnPreferenceChangeListener {
//        private var root: PreferenceScreen? = null
//        private var mScanServiceOnOff: SwitchPreference? = null
//        private var mCheckBoxScanTriggerLock: CheckBoxPreference? = null
//        private var mCheckBoxScanCaptureImage: CheckBoxPreference? = null
//        private var mScanTriggerMode: ListPreference? = null
//        private var mScanOutputMode: ListPreference? = null
//        private var mScanKeyboardOutputType: ListPreference? = null
//        private var mScanReset: Preference? = null
//        private var mScanSendSounds: ListPreference? = null
//        private var mIntentAction: EditTextPreference? = null
//        private var mIntentLabel: EditTextPreference? = null
//        private var mIntentBarcodeType: EditTextPreference? = null
//        private var mBarcodeSymbologyList: Preference? = null
//        private var mScanDemo: ScanManagerDemo? = null
//        fun setScanManagerDemo(demo: ScanManagerDemo?) {
//            mScanDemo = demo
//        }
//
//        fun resetScan() {
//            mScanServiceOnOff!!.isChecked = true
//            mScanEnable = true
//            Log.d(TAG, "resetScan , :")
//            mScanDemo!!.updateScanShared(DECODE_ENABLE, true)
//            mScanDemo!!.openScanner()
//            mCheckBoxScanTriggerLock!!.isChecked = false
//            mScanDemo!!.updateLockTriggerState(false)
//            mScanTriggerMode!!.value = SCAN_HOST
//            mScanTriggerMode!!.summary = mScanTriggerMode!!.entry
//            mScanDemo!!.setTrigger(Triggering.HOST)
//            mScanOutputMode!!.value = DECODE_OUTPUT_MODE_FOCUS.toString() + ""
//            mScanOutputMode!!.summary = mScanOutputMode!!.entry
//            mScanDemo!!.scanOutputMode = DECODE_OUTPUT_MODE_FOCUS
//            var id = intArrayOf(PropertyID.WEDGE_KEYBOARD_TYPE)
//            val value = mScanDemo!!.getParameterInts(id)
//            mScanKeyboardOutputType!!.value = value[0].toString() + ""
//            mScanKeyboardOutputType!!.summary = mScanKeyboardOutputType!!.entry
//            id = intArrayOf(PropertyID.GOOD_READ_BEEP_ENABLE)
//            val valueBuff = intArrayOf(1)
//            mScanDemo!!.setParameterInts(id, valueBuff)
//            mScanSendSounds!!.value = valueBuff[0].toString() + ""
//            mScanSendSounds!!.summary = mScanSendSounds!!.entry
//            id = intArrayOf(PropertyID.WEDGE_INTENT_ACTION_NAME, PropertyID.WEDGE_INTENT_DATA_STRING_TAG, PropertyID.WEDGE_INTENT_LABEL_TYPE_TAG)
//            val valueBuffStr = arrayOf("android.intent.ACTION_DECODE_DATA", "barcode_string", "barcodeType")
//            mIntentAction!!.summary = valueBuffStr[0]
//            mIntentLabel!!.summary = valueBuffStr[1]
//            mIntentBarcodeType!!.summary = valueBuffStr[2]
//            mScanDemo!!.setParameterString(id, valueBuffStr)
//            mScanCaptureImageShow = false
//            mCheckBoxScanCaptureImage!!.isChecked = false
//            mScanDemo!!.updateScanShared(DECODE_CAPTURE_IMAGE_SHOW, false)
//            mScanDemo!!.updateCaptureImage()
//        }
//
//        override fun onCreate(savedInstanceState: Bundle?) {
//            super.onCreate(savedInstanceState)
//            root = this.preferenceScreen
//            if (root != null) {
//                root!!.removeAll()
//            }
//            addPreferencesFromResource(R.xml.scan_settings)
//            mScanServiceOnOff = findPreference(SCAN_SERVICE_ONOFF) as SwitchPreference
//            mScanServiceOnOff!!.onPreferenceChangeListener = this
//            mCheckBoxScanTriggerLock = findPreference(SCAN_TRIGGER_LOCK) as CheckBoxPreference
//            mCheckBoxScanTriggerLock!!.onPreferenceChangeListener = this
//            mScanTriggerMode = findPreference(SCAN_TRIGGER_MODE) as ListPreference
//            mScanTriggerMode!!.onPreferenceChangeListener = this
//            mScanOutputMode = findPreference(SCAN_OUTPUT_MODE) as ListPreference
//            mScanOutputMode!!.onPreferenceChangeListener = this
//            mScanKeyboardOutputType = findPreference(SCAN_KEYBOARD_OUTPUT_TYPE) as ListPreference
//            mScanKeyboardOutputType!!.onPreferenceChangeListener = this
//            mScanSendSounds = findPreference(SCAN_SOUND_MODE) as ListPreference
//            mScanSendSounds!!.onPreferenceChangeListener = this
//            mIntentAction = findPreference(SCAN_INTENT_ACTION) as EditTextPreference
//            mIntentAction!!.onPreferenceChangeListener = this
//            mIntentLabel = findPreference(SCAN_INTENT_LABEL) as EditTextPreference
//            mIntentLabel!!.onPreferenceChangeListener = this
//            mIntentBarcodeType = findPreference(SCAN_INTENT_BARCODE_TYPE) as EditTextPreference
//            mIntentBarcodeType!!.onPreferenceChangeListener = this
//            mCheckBoxScanCaptureImage = findPreference(SCAN_CAPTURE_IMAGE) as CheckBoxPreference
//            mCheckBoxScanCaptureImage!!.onPreferenceChangeListener = this
//            mBarcodeSymbologyList = findPreference(SCAN_BARCODE_SYMBOLOGY_LIST_KEY) as Preference
//            mBarcodeSymbologyList!!.onPreferenceChangeListener = this
//            mScanReset = findPreference(SCAN_RESET) as Preference
//            initFlagment()
//        }
//
//        override fun onPreferenceTreeClick(preferenceScreen: PreferenceScreen, preference: Preference): Boolean {
//            Log.d(TAG, "onPreferenceTreeClick preference:$preference")
//            if (mScanReset === preference) {
//                Log.d(TAG, "onPreferenceTreeClick mScanReset:$mScanReset")
//                mScanDemo!!.resetScanner()
//            } else if (preference === mIntentAction) {
//                mIntentAction!!.editText.setText(mIntentAction!!.summary)
//            } else if (preference === mIntentLabel) {
//                mIntentLabel!!.editText.setText(mIntentLabel!!.summary)
//            } else if (preference === mBarcodeSymbologyList) {
//                Log.d(TAG, "onPreferenceChange scanSettingsBarcodeList()")
//                mScanDemo!!.scanSettingsBarcodeList()
//            }
//            return super.onPreferenceTreeClick(preferenceScreen, preference)
//        }
//
//        override fun onPreferenceChange(preference: Preference, newValue: Any): Boolean {
//            val key = preference.key
//            Log.d(TAG, "onPreferenceChange preference:$preference,newValue$newValue,key:$key")
//            if (SCAN_SERVICE_ONOFF == key) {
//                val value = newValue as Boolean
//                if (mScanServiceOnOff!!.isChecked != value) {
//                    mScanServiceOnOff!!.isChecked = value
//                    mScanEnable = value
//                    Log.d(TAG, "initView , Switch:$value")
//                    mScanDemo!!.updateScanShared(DECODE_ENABLE, value)
//                    if (value) {
//                        mScanDemo!!.openScanner()
//                    } else {
//                        mScanDemo!!.closeScanner()
//                    }
//                }
//                Log.d(TAG, "onPreferenceChange mScanServiceOnOff preference:$preference,newValue:$newValue,value:$value")
//            } else if (SCAN_TRIGGER_LOCK == key) {
//                val value = newValue as Boolean
//                Log.d(TAG, "onPreferenceChange mScanServiceOnOff preference:$preference,newValue:$newValue")
//                mCheckBoxScanTriggerLock!!.isChecked = value
//                mScanDemo!!.updateLockTriggerState(value)
//            } else if (SCAN_TRIGGER_MODE == key) {
//                val mode = newValue as String
//                Log.d(TAG, "onPreferenceChange mScanServiceOnOff2 preference:$preference,newValue:$newValue")
//                if (SCAN_HOST == mode) {
//                    mScanTriggerMode!!.value = SCAN_HOST
//                    mScanTriggerMode!!.summary = mScanTriggerMode!!.entry
//                    mScanDemo!!.setTrigger(Triggering.HOST)
//                } else if (SCAN_CONTINUOUS == mode) {
//                    mScanTriggerMode!!.value = SCAN_CONTINUOUS
//                    mScanTriggerMode!!.summary = mScanTriggerMode!!.entry
//                    mScanDemo!!.setTrigger(Triggering.CONTINUOUS)
//                } else if (SCAN_PULSE == mode) {
//                    mScanTriggerMode!!.value = SCAN_PULSE
//                    mScanTriggerMode!!.summary = mScanTriggerMode!!.entry
//                    mScanDemo!!.setTrigger(Triggering.PULSE)
//                }
//            } else if (SCAN_OUTPUT_MODE == key) {
//                val mode = newValue as String
//                val outputMode = if (mode != null) Integer.valueOf(mode) else DECODE_OUTPUT_MODE_FOCUS
//                Log.d(TAG, "onPreferenceChange SCAN_OUTPUT_MODE preference:$preference,mode:$mode")
//                mScanOutputMode!!.value = mode
//                mScanOutputMode!!.summary = mScanOutputMode!!.entry
//                mScanDemo!!.scanOutputMode = outputMode
//            } else if (SCAN_KEYBOARD_OUTPUT_TYPE == key) {
//                val value = Integer.valueOf(newValue as String)
//                val id = intArrayOf(PropertyID.WEDGE_KEYBOARD_TYPE)
//                val values = mScanDemo!!.getParameterInts(id)
//                if (values[0] != value) {
//                    mScanKeyboardOutputType!!.value = value.toString() + ""
//                    mScanKeyboardOutputType!!.summary = mScanKeyboardOutputType!!.entry
//                    val valueBuff = intArrayOf(value)
//                    mScanDemo!!.setParameterInts(id, valueBuff)
//                }
//                Log.d(TAG, "onPreferenceChange SCAN_KEYBOARD_OUTPUT_TYPE value:" + value + ",values[0]:" + values[0])
//            } else if (SCAN_SOUND_MODE == key) {
//                val value = Integer.valueOf(newValue as String)
//                val id = intArrayOf(PropertyID.GOOD_READ_BEEP_ENABLE)
//                val values = mScanDemo!!.getParameterInts(id)
//                if (values[0] != value) {
//                    mScanSendSounds!!.value = value.toString() + ""
//                    mScanSendSounds!!.summary = mScanSendSounds!!.entry
//                    val valueBuff = intArrayOf(value)
//                    mScanDemo!!.setParameterInts(id, valueBuff)
//                }
//                Log.d(TAG, "onPreferenceChange SCAN_SOUND_MODE preference:$preference,newValue:$newValue")
//            } else if (SCAN_INTENT_ACTION == key) {
//                val newAction = newValue as String
//                val id = intArrayOf(PropertyID.WEDGE_INTENT_ACTION_NAME)
//                val value = mScanDemo!!.getParameterString(id)
//                if (newAction != null && newAction != value[0]) {
//                    mIntentAction!!.summary = newAction
//                    val valueBuff = arrayOf(newAction)
//                    mScanDemo!!.setParameterString(id, valueBuff)
//                }
//            } else if (SCAN_INTENT_LABEL == key) {
//                val newAction = newValue as String
//                val id = intArrayOf(PropertyID.WEDGE_INTENT_DATA_STRING_TAG)
//                val value = mScanDemo!!.getParameterString(id)
//                if (newAction != null && newAction != value[0]) {
//                    mIntentLabel!!.summary = newAction
//                    val valueBuff = arrayOf(newAction)
//                    mScanDemo!!.setParameterString(id, valueBuff)
//                }
//            } else if (SCAN_INTENT_BARCODE_TYPE == key) {
//                val newAction = newValue as String
//                val id = intArrayOf(PropertyID.WEDGE_INTENT_LABEL_TYPE_TAG)
//                val value = mScanDemo!!.getParameterString(id)
//                if (newAction != null && newAction != value[0]) {
//                    mIntentLabel!!.summary = newAction
//                    val valueBuff = arrayOf(newAction)
//                    mScanDemo!!.setParameterString(id, valueBuff)
//                }
//            } else if (SCAN_CAPTURE_IMAGE == key) {
//                val value = newValue as Boolean
//                val outputMode = mScanDemo!!.scanOutputMode
//                if (value && outputMode != DECODE_OUTPUT_MODE_INTENT) {
//                    Toast.makeText(mScanDemo,
//                            R.string.scan_cupture_image_prompt, Toast.LENGTH_LONG).show()
//                }
//                mScanCaptureImageShow = value
//                Log.d(TAG, "onPreferenceChange SCAN_CAPTURE_IMAGE preference:$preference,newValue:$newValue")
//                mCheckBoxScanCaptureImage!!.isChecked = value
//                mScanDemo!!.updateScanShared(DECODE_CAPTURE_IMAGE_SHOW, value)
//                mScanDemo!!.updateCaptureImage()
//            }
//            return false
//        }
//
//        private fun initFlagment() {
//            val mode = mScanDemo!!.triggerMode
//            if (mode == Triggering.HOST) {
//                mScanTriggerMode!!.value = SCAN_HOST
//            } else if (mode == Triggering.CONTINUOUS) {
//                mScanTriggerMode!!.value = SCAN_CONTINUOUS
//            } else if (mode == Triggering.PULSE) {
//                mScanTriggerMode!!.value = SCAN_PULSE
//            }
//            mScanTriggerMode!!.summary = mScanTriggerMode!!.entry
//            val outputMode = mScanDemo!!.scanOutputMode
//            mScanOutputMode!!.value = outputMode.toString() + ""
//            mScanOutputMode!!.summary = mScanOutputMode!!.entry
//            var id = intArrayOf(PropertyID.WEDGE_KEYBOARD_TYPE)
//            val valueType = mScanDemo!!.getParameterInts(id)
//            mScanKeyboardOutputType!!.value = valueType[0].toString() + ""
//            mScanKeyboardOutputType!!.summary = mScanKeyboardOutputType!!.entry
//            id = intArrayOf(PropertyID.GOOD_READ_BEEP_ENABLE)
//            val values = mScanDemo!!.getParameterInts(id)
//            mScanSendSounds!!.value = values[0].toString() + ""
//            mScanSendSounds!!.summary = mScanSendSounds!!.entry
//            id = intArrayOf(PropertyID.WEDGE_INTENT_ACTION_NAME, PropertyID.WEDGE_INTENT_DATA_STRING_TAG, PropertyID.WEDGE_INTENT_LABEL_TYPE_TAG)
//            val value = mScanDemo!!.getParameterString(id)
//            mIntentAction!!.summary = value[0]
//            mIntentLabel!!.summary = value[1]
//            mIntentBarcodeType!!.summary = value[2]
//            mCheckBoxScanCaptureImage!!.isChecked = mScanDemo!!.getDecodeScanShared(DECODE_CAPTURE_IMAGE_SHOW)
//        }
//
//        companion object {
//            private const val SCAN_SERVICE_ONOFF = "scan_turnon_switch"
//            private const val SCAN_TRIGGER_LOCK = "scan_trigger_lock"
//            private const val SCAN_TRIGGER_MODE = "scan_trigger_mode"
//            private const val SCAN_RESET = "scan_reset_def"
//            private const val SCAN_OUTPUT_MODE = "scan_output_mode"
//            private const val SCAN_KEYBOARD_OUTPUT_TYPE = "scan_keyboard_output_type"
//            private const val SCAN_SOUND_MODE = "scan_sound_mode"
//            private const val SCAN_INTENT_ACTION = "scan_intent_action"
//            private const val SCAN_INTENT_LABEL = "scan_intent_stringlabel"
//            private const val SCAN_INTENT_BARCODE_TYPE = "scan_intent_barcode_type"
//            private const val SCAN_CAPTURE_IMAGE = "scan_cupture_image"
//            private const val SCAN_BARCODE_SYMBOLOGY_LIST_KEY = "scan_barcode_symbology_list"
//            private const val SCAN_PULSE = "0"
//            private const val SCAN_CONTINUOUS = "1"
//            private const val SCAN_HOST = "2"
//        }
//    }
//
//    /**
//     * BarcodeHolder helper
//     */
//    internal class BarcodeHolder {
//        var mBarcodeEnable: CheckBoxPreference? = null
//        var mBarcodeLength1: EditTextPreference? = null
//        var mBarcodeLength2: EditTextPreference? = null
//        var mBarcodeNOTIS: CheckBoxPreference? = null
//        var mBarcodeCLSI: CheckBoxPreference? = null
//        var mBarcodeISBT: CheckBoxPreference? = null
//        var mBarcodeChecksum: CheckBoxPreference? = null
//        var mBarcodeSendCheck: CheckBoxPreference? = null
//        var mBarcodeFullASCII: CheckBoxPreference? = null
//        var mBarcodeCheckDigit: ListPreference? = null
//        var mBarcodeBookland: CheckBoxPreference? = null
//        var mBarcodeSecondChecksum: CheckBoxPreference? = null
//        var mBarcodeSecondChecksumMode: CheckBoxPreference? = null
//        var mBarcodePostalCode: ListPreference? = null
//        var mBarcodeSystemDigit: CheckBoxPreference? = null
//        var mBarcodeConvertEAN13: CheckBoxPreference? = null
//        var mBarcodeConvertUPCA: CheckBoxPreference? = null
//        var mBarcodeEanble25DigitExtensions: CheckBoxPreference? = null
//        var mBarcodeDPM: CheckBoxPreference? = null
//        var mParaIds: IntArray? = null
//        var mParaKeys: Array<String>? = null
//    }
//
//    /**
//     * Use of android.device.scanner.configuration.Constants.Symbology Class
//     */
//    private val BARCODE_SYMBOLOGY = intArrayOf(
//            Constants.Symbology.AZTEC,
//            Constants.Symbology.CHINESE25,
//            Constants.Symbology.CODABAR,
//            Constants.Symbology.CODE11,
//            Constants.Symbology.CODE32,
//            Constants.Symbology.CODE39,
//            Constants.Symbology.CODE93,
//            Constants.Symbology.CODE128,
//            Constants.Symbology.COMPOSITE_CC_AB,
//            Constants.Symbology.COMPOSITE_CC_C,
//            Constants.Symbology.COMPOSITE_TLC39,
//            Constants.Symbology.DATAMATRIX,
//            Constants.Symbology.DISCRETE25,
//            Constants.Symbology.EAN8,
//            Constants.Symbology.EAN13,
//            Constants.Symbology.GS1_14,
//            Constants.Symbology.GS1_128,
//            Constants.Symbology.GS1_EXP,
//            Constants.Symbology.GS1_LIMIT,
//            Constants.Symbology.HANXIN,
//            Constants.Symbology.INTERLEAVED25,
//            Constants.Symbology.MATRIX25,
//            Constants.Symbology.MAXICODE,
//            Constants.Symbology.MICROPDF417,
//            Constants.Symbology.MSI,
//            Constants.Symbology.PDF417,
//            Constants.Symbology.POSTAL_4STATE,
//            Constants.Symbology.POSTAL_AUSTRALIAN,
//            Constants.Symbology.POSTAL_JAPAN,
//            Constants.Symbology.POSTAL_KIX,
//            Constants.Symbology.POSTAL_PLANET,
//            Constants.Symbology.POSTAL_POSTNET,
//            Constants.Symbology.POSTAL_ROYALMAIL,
//            Constants.Symbology.POSTAL_UPUFICS,
//            Constants.Symbology.QRCODE,
//            Constants.Symbology.TRIOPTIC,
//            Constants.Symbology.UPCA,
//            Constants.Symbology.UPCE,
//            Constants.Symbology.UPCE1,
//            Constants.Symbology.NONE,
//            Constants.Symbology.RESERVED_6,
//            Constants.Symbology.RESERVED_13,
//            Constants.Symbology.RESERVED_15,
//            Constants.Symbology.RESERVED_16,
//            Constants.Symbology.RESERVED_20,
//            Constants.Symbology.RESERVED_21,
//            Constants.Symbology.RESERVED_27,
//            Constants.Symbology.RESERVED_28,
//            Constants.Symbology.RESERVED_30,
//            Constants.Symbology.RESERVED_33
//    )
//
//    companion object {
//        private const val TAG = "ScanManagerDemo"
//        private const val DEBUG = true
//        private const val ACTION_DECODE = ScanManager.ACTION_DECODE // default action
//        private const val ACTION_DECODE_IMAGE_REQUEST = "action.scanner_capture_image"
//        const val ACTION_CAPTURE_IMAGE = "scanner_capture_image_result"
//        private const val BARCODE_STRING_TAG = ScanManager.BARCODE_STRING_TAG
//        private const val BARCODE_TYPE_TAG = ScanManager.BARCODE_TYPE_TAG
//        private const val BARCODE_LENGTH_TAG = ScanManager.BARCODE_LENGTH_TAG
//        private const val DECODE_DATA_TAG = ScanManager.DECODE_DATA_TAG
//        private const val DECODE_ENABLE = "decode_enable"
//        private const val DECODE_TRIGGER_MODE = "decode_trigger_mode"
//        private const val DECODE_TRIGGER_MODE_HOST = "HOST"
//        private const val DECODE_TRIGGER_MODE_CONTINUOUS = "CONTINUOUS"
//        private const val DECODE_TRIGGER_MODE_PAUSE = "PAUSE"
//        private var DECODE_TRIGGER_MODE_CURRENT = DECODE_TRIGGER_MODE_HOST
//        private const val DECODE_OUTPUT_MODE_INTENT = 0
//        private const val DECODE_OUTPUT_MODE_FOCUS = 1
//        private var DECODE_OUTPUT_MODE_CURRENT = DECODE_OUTPUT_MODE_FOCUS
//        private const val DECODE_OUTPUT_MODE = "decode_output_mode"
//        private const val DECODE_CAPTURE_IMAGE_KEY = "bitmapBytes"
//        private const val DECODE_CAPTURE_IMAGE_SHOW = "scan_capture_image"
//        private var mScanEnable = true
//        private var mScanSettingsView = false
//        private var mScanCaptureImageShow = false
//        private var mScanBarcodeSettingsMenuBarcodeList = false
//        private var mScanBarcodeSettingsMenuBarcode = false
//        private val mBarcodeMap: MutableMap<String, BarcodeHolder> = HashMap()
//        private const val MSG_SHOW_SCAN_RESULT = 1
//        private const val MSG_SHOW_SCAN_IMAGE = 2
//        private val SCAN_KEYCODE = intArrayOf(520, 521, 522, 523)
//
//        /**
//         * byte[] toHex String
//         *
//         * @param src
//         * @return String
//         */
//        fun bytesToHexString(src: ByteArray?): String? {
//            val stringBuilder = StringBuilder("")
//            if (src == null || src.size <= 0) {
//                return null
//            }
//            for (i in src.indices) {
//                val v = src[i].toInt() and 0xFF
//                val hv = Integer.toHexString(v)
//                if (hv.length < 2) {
//                    stringBuilder.append(0)
//                }
//                stringBuilder.append(hv)
//            }
//            return stringBuilder.toString()
//        }
//
//        /**
//         * Use of android.device.scanner.configuration.Symbology enums
//         */
//        private val BARCODE_SUPPORT_SYMBOLOGY = arrayOf(
//                Symbology.AZTEC,
//                Symbology.CHINESE25,
//                Symbology.CODABAR,
//                Symbology.CODE11,
//                Symbology.CODE32,
//                Symbology.CODE39,
//                Symbology.CODE93,
//                Symbology.CODE128,
//                Symbology.COMPOSITE_CC_AB,
//                Symbology.COMPOSITE_CC_C,
//                Symbology.DATAMATRIX,
//                Symbology.DISCRETE25,
//                Symbology.EAN8,
//                Symbology.EAN13,
//                Symbology.GS1_14,
//                Symbology.GS1_128,
//                Symbology.GS1_EXP,
//                Symbology.GS1_LIMIT,
//                Symbology.INTERLEAVED25,
//                Symbology.MATRIX25,
//                Symbology.MAXICODE,
//                Symbology.MICROPDF417,
//                Symbology.MSI,
//                Symbology.PDF417,
//                Symbology.POSTAL_4STATE,
//                Symbology.POSTAL_AUSTRALIAN,
//                Symbology.POSTAL_JAPAN,
//                Symbology.POSTAL_KIX,
//                Symbology.POSTAL_PLANET,
//                Symbology.POSTAL_POSTNET,
//                Symbology.POSTAL_ROYALMAIL,
//                Symbology.POSTAL_UPUFICS,
//                Symbology.QRCODE,
//                Symbology.TRIOPTIC,
//                Symbology.UPCA,
//                Symbology.UPCE,
//                Symbology.UPCE1,
//                Symbology.NONE
//        )
//    }
//}