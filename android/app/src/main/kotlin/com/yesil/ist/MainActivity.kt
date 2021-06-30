package com.yesil.ist

 import android.content.Intent
 import android.net.Uri
 import io.flutter.embedding.android.FlutterActivity


  class MainActivity2: FlutterActivity() {

   private fun Intent.handleIntent() {
    when (action) {
     // When the action is triggered by a deep-link, Intent.Action_VIEW will be used
     Intent.ACTION_VIEW -> handleDeepLink(data)
     // Otherwise start the app as you would normally do.
     }
   }

   /**
    * Use the URI provided by the intent to handle the different deep-links
    */
   private fun handleDeepLink(data: Uri?) {

    startActivity(
            FlutterActivity.createDefaultIntent(this)
    )

   }

   /**
    * Log a success or failure of the received action based on if your app could handle the action
    *
    * Required to help giving Assistant visibility over success or failure of an action sent to the app.
    * Otherwise, it can’t confidently send user’s to your app for fulfillment.
    */

}



