package com.example.uboyniy_cex

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.uboyniy_cex/scanner"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setStreamHandler(ScannerStreamHandler(this))
    }
}

