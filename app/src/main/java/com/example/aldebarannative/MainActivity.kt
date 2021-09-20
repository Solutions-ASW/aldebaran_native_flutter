package com.example.aldebarannative

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity : AppCompatActivity() {
    private val CHANNEL = "samples.flutter.dev/module"
    private val ID_USER = "17";
    private val ENGINE_ID = "flutter_module_id";
    lateinit var flutterEngine : FlutterEngine

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        flutterEngine = FlutterEngine(this)

        //configs to navigate flutter module
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        FlutterEngineCache
            .getInstance()
            .put(ENGINE_ID, flutterEngine)
        flutterEngine.navigationChannel.setInitialRoute("/")

        //configs MethodChannel: Communication with flutter module
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
                call, result ->
            if (call.method == "getUser") {
                result.success(ID_USER)//return infos to flutter module
            } else {
                result.notImplemented()
            }
        }

        findViewById<Button>(R.id.module_flutter).setOnClickListener {
            //navigate flutter module
            startActivity(
                FlutterActivity
                    .withCachedEngine(ENGINE_ID)
                    .build(this)
            )
        }
    }
}