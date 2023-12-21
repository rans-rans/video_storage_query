package com.rans_innovations.video_storage_query_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "channel")


        methodChannel.setMethodCallHandler { call, _ ->
            when (call.method) {
                "initialize_permissions" -> {
                    PermissionHandler(this).requestPermissions()
                }
            }
        }
    }
}
