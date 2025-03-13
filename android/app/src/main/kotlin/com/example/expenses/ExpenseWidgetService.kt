package com.example.expenses

import android.app.IntentService
import android.content.Intent
import android.util.Log
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

            // Add the expense to your storage (e.g., Hive)
            addExpense(amount, reason, date)
        }
    }

    private fun addExpense(amount: String?, reason: String?, date: String) {
        // Implement the logic to add the expense to your storage (e.g., Hive)
        // This is just a placeholder
        Log.d("ExpenseWidgetService", "Expense added to storage: $amount, $reason, $date")
    }
}