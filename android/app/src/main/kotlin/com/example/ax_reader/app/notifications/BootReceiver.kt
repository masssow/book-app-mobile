package com.khouratoul.app.notifications

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (action == Intent.ACTION_BOOT_COMPLETED || action == Intent.ACTION_LOCKED_BOOT_COMPLETED) {
            try {
                // Initialise l’infrastructure Flutter
                val loader = FlutterInjector.instance().flutterLoader()
                loader.startInitialization(context)
                loader.ensureInitializationComplete(context, null)

                val engine = FlutterEngine(context.applicationContext)

                // Exécute la fonction Dart marquée @pragma('vm:entry-point')
                val appBundlePath = loader.findAppBundlePath()
                val entrypoint = DartExecutor.DartEntrypoint(appBundlePath, "rescheduleReminders")
                engine.dartExecutor.executeDartEntrypoint(entrypoint)

                Log.i("BootReceiver", "Reschedule triggered.")
                // NB: pas besoin de retenir l’engine, il s'arrêtera une fois la tâche finie.
            } catch (e: Exception) {
                Log.e("BootReceiver", "Failed to reschedule on boot", e)
            }
        }
    }
}
