package com.hipster.hipsterassignment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "chime_sdk"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      when (call.method) {
        "joinMeeting" -> {
          // For now, mock
          result.success(true)
        }
        "leaveMeeting" -> {
          result.success(true)
        }
        else -> result.notImplemented()
      }
    }
  }
}
