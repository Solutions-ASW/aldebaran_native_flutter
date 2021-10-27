package com.example.myapplication

import android.os.Bundle
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.snackbar.Snackbar
import androidx.appcompat.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity : AppCompatActivity() {
    private val CHANNEL = "mobills.com.br/aldebaran"
    private val VALUE = 2.0;
    private val ENGINE_ID = "flutter_module_id";
    lateinit var flutterEngine : FlutterEngine

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(findViewById(R.id.toolbar))

        flutterEngine = FlutterEngine(this)

        //configs to navigate flutter module
        flutterEngine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        )
        FlutterEngineCache
                .getInstance()
                .put(ENGINE_ID, flutterEngine)
        flutterEngine.navigationChannel.setInitialRoute("/")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{
            call, result ->
            if (call.method == "getValue") {
                result.success(VALUE)//return infos to flutter module
            } else {
                result.notImplemented()
            }
        }

        findViewById<FloatingActionButton>(R.id.fab).setOnClickListener {
            //navigate flutter module
            startActivity(
                    FlutterActivity
                            .withCachedEngine(ENGINE_ID)
                            .build(this)
            )
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        return when (item.itemId) {
            R.id.action_settings -> true
            else -> super.onOptionsItemSelected(item)
        }
    }
}