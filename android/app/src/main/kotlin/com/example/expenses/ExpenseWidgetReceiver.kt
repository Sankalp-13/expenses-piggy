package com.example.expenses

import android.appwidget.AppWidgetManager // Add this import
import android.content.BroadcastReceiver
import android.content.ComponentName // Add this import
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews // Add this import

class ExpenseWidgetReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "com.example.expensetracker.ACTION_ADD_EXPENSE") {
            val amount = intent.getStringExtra("amount")
            val reason = intent.getStringExtra("reason")

            Log.d("ExpenseWidgetReceiver", "Received data: Amount=$amount, Reason=$reason")

            // Update the widget with the new data
            updateWidget(context, amount, reason)
        }
    }

    private fun updateWidget(context: Context, amount: String?, reason: String?) {
        val views = RemoteViews(context.packageName, R.layout.expense_widget)
        views.setTextViewText(R.id.amount_text, "Amount: $amount")
        views.setTextViewText(R.id.reason_text, "Reason: $reason")

        // Update all instances of the widget
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(
            ComponentName(context, ExpenseWidgetProvider::class.java)
        )
        appWidgetManager.updateAppWidget(appWidgetIds, views)
    }
}