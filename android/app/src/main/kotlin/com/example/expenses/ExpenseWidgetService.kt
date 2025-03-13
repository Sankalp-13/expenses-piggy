package com.example.expenses

import android.app.IntentService
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

class ExpenseWidgetService : IntentService("ExpenseWidgetService") {

    override fun onHandleIntent(intent: Intent?) {
        if (intent?.action == "ADD_EXPENSE") {
            // Retrieve data from the intent
            val amount = intent.getStringExtra("amount")
            val reason = intent.getStringExtra("reason")
            val date = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())

            // Log the data
            Log.d("ExpenseWidgetService", "Expense added: $amount, $reason, $date")

            // Call the Flutter method to add the expense to Hive
            addExpenseToFlutter(amount, reason, date)
        }
    }

    private fun addExpenseToFlutter(amount: String?, reason: String?, date: String) {
        // Initialize the Flutter engine (if not already initialized)
        val flutterEngine = FlutterEngineCache.getInstance().get("expense_engine")
            ?: FlutterEngine(this).also {
                it.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                )
                FlutterEngineCache.getInstance().put("expense_engine", it)
            }

        // Set up the method channel
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.expenses/expense")

        // Post the invokeMethod call to the main thread
        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod("addExpense", mapOf(
                "amount" to amount,
                "reason" to reason,
                "date" to date
            ), object : MethodChannel.Result {
                override fun success(result: Any?) {
                    Log.d("ExpenseWidgetService", "Expense added successfully")
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e("ExpenseWidgetService", "Error adding expense: $errorMessage")
                }

                override fun notImplemented() {
                    Log.e("ExpenseWidgetService", "Method not implemented")
                }
            })
        }
    }
}