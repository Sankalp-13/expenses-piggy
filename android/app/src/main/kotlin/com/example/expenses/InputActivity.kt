package com.example.expenses

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText

class InputActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_input)

        val amountInput = findViewById<EditText>(R.id.amount_input)
        val reasonInput = findViewById<EditText>(R.id.reason_input)
        val submitButton = findViewById<Button>(R.id.submit_button)

        submitButton.setOnClickListener {
            val amount = amountInput.text.toString()
            val reason = reasonInput.text.toString()

            // Send a broadcast with the data
            val broadcastIntent = Intent("com.example.expensetracker.ACTION_ADD_EXPENSE").apply {
                putExtra("amount", amount)
                putExtra("reason", reason)
            }
            sendBroadcast(broadcastIntent)

            // Close the activity
            finish()
        }
    }
}