package com.example.vehicle_tracking_system

import android.app.Application
import android.util.Log
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory

class VehicleTrackingApplication : Application() {
  override fun onCreate() {
    super.onCreate()

    FirebaseApp.initializeApp(this)
    val appCheck = FirebaseAppCheck.getInstance()
    appCheck.installAppCheckProviderFactory(
      DebugAppCheckProviderFactory.getInstance(),
    )
    appCheck.setTokenAutoRefreshEnabled(true)
    Log.i("VehicleTrackingAppCheck", "App Check debug provider installed")
  }
}
