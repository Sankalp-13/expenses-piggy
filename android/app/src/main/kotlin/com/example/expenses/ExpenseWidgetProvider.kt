package com.example.expenses

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews

class ExpenseWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d("ExpenseWidgetProvider", "onUpdate called")
        for (appWidgetId in appWidgetIds) {
            try {
                updateAppWidget(context, appWidgetManager, appWidgetId)
            } catch (e: Exception) {
                Log.e("ExpenseWidgetProvider", "Error updating widget $appWidgetId", e)
            }
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        Log.d("ExpenseWidgetProvider", "Updating widget $appWidgetId")
        val views = RemoteViews(context.packageName, R.layout.expense_widget)

        // Set up the intent to handle the "Add Expense" button click
        val intent = Intent(context, ExpenseWidgetService::class.java)
        intent.action = "ADD_EXPENSE"

        // Add sample data to the intent (for testing)
        intent.putExtra("amount", "100") // Replace with actual amount
        intent.putExtra("reason", "Food") // Replace with actual reason

        // Use FLAG_IMMUTABLE for Android 12 and above
        val pendingIntent = PendingIntent.getService(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        views.setOnClickPendingIntent(R.id.add_expense_button, pendingIntent)

        // Update the widget with sample data
        views.setTextViewText(R.id.amount_text, "Amount: 100")
        views.setTextViewText(R.id.reason_text, "Reason: Food")

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
        Log.d("ExpenseWidgetProvider", "Widget $appWidgetId updated successfully")
    }
}