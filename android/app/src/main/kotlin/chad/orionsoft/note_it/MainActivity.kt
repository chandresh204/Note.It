package chad.orionsoft.note_it

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.random.Random

class MainActivity : FlutterActivity() {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Constants.methodChannelName)
            .setMethodCallHandler { call, _ ->
                if(call.method == Constants.methodShowNotification) {
                    val title = call.argument<String>(Constants.var_title) ?: "NA"
                    val desc = call.argument<String>(Constants.var_desc) ?: "NA"
                    val importance = call.argument<Int>(Constants.var_importance) ?: 0
                    showNotification(title, desc, importance)
                }
            }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun showNotification(title: String, descr: String, importance: Int) {
        val channelId = "notification"
        val nManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        nManager.createNotificationChannel(
            NotificationChannel(channelId, "notification",
            when(importance) {
                Constants.notificationLow -> NotificationManager.IMPORTANCE_LOW
                Constants.notificationDefault -> NotificationManager.IMPORTANCE_DEFAULT
                Constants.notificationHigh -> NotificationManager.IMPORTANCE_HIGH
                else -> NotificationManager.IMPORTANCE_LOW
            })
        )
        val notification = Notification.Builder(this, channelId)
            .setSmallIcon(R.drawable.launch_background)
            .setContentTitle(title)
            .setContentText(descr)
            .build()
        nManager.notify(Random.nextInt(1000), notification)
    }
}
