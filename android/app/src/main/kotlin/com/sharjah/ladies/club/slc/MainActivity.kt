package com.sharjah.ladies.club.slc

import io.flutter.embedding.android.FlutterActivity
import UpdateRequestListener
import android.app.Activity
import android.content.Context
import android.content.Intent
//import android.widget.Toast
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.ActivityResult
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.AppUpdateType.IMMEDIATE
import com.google.android.play.core.install.model.UpdateAvailability
import com.google.android.gms.tasks.Task
import com.google.gson.Gson
import com.sharjah.ladies.club.slc.model.AppBaseInfo
import com.sharjah.ladies.club.slc.network_check.GetDataService
import com.sharjah.ladies.club.slc.network_check.RetrofitClientInstance.retrofitInstance
import com.sharjah.ladies.club.slc.utils.Constants
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*
import androidx.annotation.NonNull
import android.os.Bundle
import com.google.firebase.ktx.Firebase
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.ktx.get
import com.google.firebase.remoteconfig.ktx.remoteConfig
import com.google.firebase.remoteconfig.ktx.remoteConfigSettings
//import android.R.attr.data




class MainActivity: FlutterActivity() {

    private val CHANNEL = "app_data"
    private val APP_UPDATE_TYPE_SUPPORTED = IMMEDIATE
    private val REQUEST_UPDATE = 100

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
//        println("=====> onCreate called")



//
//        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
////            println("=====> " + call.method)
//
//        }
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method.equals("appForceUpdate")) {
//                result.success(checkAppUpdate())
                checkForAppUpdates(object : UpdateRequestListener {
                    override fun onRequestCompleted(responseObject: Any?) {
                        result.success(responseObject)
                    }

                    override fun onRequestFailed(responseObject: Any?) {
                        result.success(responseObject)
                    }
                })
            } else if (call.method.equals("getBaseData")) {
                val mFirebaseRemoteConfig = Firebase.remoteConfig
                val configSettings = remoteConfigSettings {
                    minimumFetchIntervalInSeconds = 3600
                }
                mFirebaseRemoteConfig.setConfigSettingsAsync(configSettings)
//                val configSettings = RemoteConfigSettings.Builder()
//                    .setMinimumFetchIntervalInSeconds(3600)
//                    .build()
//                mFirebaseRemoteConfig.setConfigSettingsAsync(configSettings)

                mFirebaseRemoteConfig.fetchAndActivate()
                    .addOnCompleteListener(this) { task ->
                        if (task.isSuccessful) {
                            val updated = task.result
//                                Toast.makeText(this, "Fetch and activate succeeded",
//                                        Toast.LENGTH_SHORT).show()

                        } else {
//                                Toast.makeText(this, "Fetch failed",
//                                        Toast.LENGTH_SHORT).show()
                        }

                        var netSpeed = 0.0
                        getNetSpeed(context, object : UpdateRequestListener {
                            override fun onRequestCompleted(responseObject: Any?) {
                                netSpeed = responseObject as Double
                                if (call.argument("checkVersion")!!) {
                                    checkForAppUpdates(object : UpdateRequestListener {
                                        override fun onRequestCompleted(responseObject: Any?) {
                                            val appBaseInfo = AppBaseInfo(
                                                responseObject as Int,
                                                mFirebaseRemoteConfig.getString(Constants.VectorKey),
                                                mFirebaseRemoteConfig.getString(Constants.SecretKey),
                                                mFirebaseRemoteConfig.getString(Constants.EventRegistrationCount).toInt(),
                                                mFirebaseRemoteConfig.getString(Constants.AppKey), netSpeed)
//                                                println("json ===> "+Gson().toJson(appBaseInfo))
                                            result.success(Gson().toJson(appBaseInfo))
                                        }

                                        override fun onRequestFailed(responseObject: Any?) {
                                            val appBaseInfo = AppBaseInfo(
                                                0,
                                                mFirebaseRemoteConfig.getString(Constants.VectorKey),
                                                mFirebaseRemoteConfig.getString(Constants.SecretKey),
                                                mFirebaseRemoteConfig.getString(Constants.EventRegistrationCount).toInt(),
                                                mFirebaseRemoteConfig.getString(Constants.AppKey), netSpeed)
//                                                println("json ===> "+Gson().toJson(appBaseInfo))
                                            result.success(Gson().toJson(appBaseInfo))
                                        }
                                    })
                                } else {
                                    val appBaseInfo = AppBaseInfo(
                                        0,
                                        mFirebaseRemoteConfig.getString(Constants.VectorKey),
                                        mFirebaseRemoteConfig.getString(Constants.SecretKey),
                                        mFirebaseRemoteConfig.getString(Constants.EventRegistrationCount).toInt(),
                                        mFirebaseRemoteConfig.getString(Constants.AppKey), netSpeed)
//                                        println("json ===> "+Gson().toJson(appBaseInfo))
                                    result.success(Gson().toJson(appBaseInfo))
                                }


                            }

                            override fun onRequestFailed(responseObject: Any?) {
                                netSpeed = responseObject as Double
                                val appBaseInfo = AppBaseInfo(
                                    mFirebaseRemoteConfig.getString(Constants.AndroidVersionCode).toInt(),
                                    mFirebaseRemoteConfig.getString(Constants.VectorKey),
                                    mFirebaseRemoteConfig.getString(Constants.SecretKey),
                                    mFirebaseRemoteConfig.getString(Constants.EventRegistrationCount).toInt(),
                                    mFirebaseRemoteConfig.getString(Constants.AppKey), netSpeed)
//                                    println("json ===> "+Gson().toJson(appBaseInfo))
                                result.success(Gson().toJson(appBaseInfo))
                            }
                        })

                    }
            }
        }
    }
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//        println("=====> configureFlutterEngine called")
//    }

    private fun handleUpdate(manager: AppUpdateManager, info: Task<AppUpdateInfo>) {
//        println("====> handling update")
        if (APP_UPDATE_TYPE_SUPPORTED == AppUpdateType.IMMEDIATE) {
            handleImmediateUpdate(manager, info)
        }
//        else if (APP_UPDATE_TYPE_SUPPORTED == AppUpdateType.FLEXIBLE) {
//            handleFlexibleUpdate(manager, info)
//        }
    }


    private fun checkForAppUpdates(listener: UpdateRequestListener) {
        //1
        val appUpdateManager = AppUpdateManagerFactory.create(this)
        //for testing purpose only
//        val appUpdateManager = FakeAppUpdateManager(this)
//        appUpdateManager.setUpdateAvailable(16)
        val appUpdateInfo = appUpdateManager.appUpdateInfo
        appUpdateInfo.addOnSuccessListener {
            //2
   //         println("it.availableVersionCode()---> " + it.availableVersionCode())
  //          println("appUpdateInfo.availableVersionCode()---> " + appUpdateInfo.result.availableVersionCode())
            if (appUpdateInfo.result.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE) {
 //               println("app update available")
                listener.onRequestCompleted(it.availableVersionCode())
//                handleUpdate(appUpdateManager, appUpdateInfo)
            } else {
                println("app update not available")
                listener.onRequestCompleted(it.availableVersionCode())
            }
        }
    }


    private fun handleImmediateUpdate(manager: AppUpdateManager, info: Task<AppUpdateInfo>) {
        println("====> handling update 1")
        //1
        if ((info.result.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE ||
                        //2
                        info.result.updateAvailability() == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) &&
                //3
                info.result.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
            //4
            println("====> handling update if 1")
            manager.startUpdateFlowForResult(info.result, AppUpdateType.IMMEDIATE, this, REQUEST_UPDATE)
        } else {
            println("====> handling update else 1")
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        println("====> onActivityResult " + requestCode)
        //1
        if (REQUEST_UPDATE == requestCode) {
            when (resultCode) {
                //2
                Activity.RESULT_OK -> {
                    if (APP_UPDATE_TYPE_SUPPORTED == AppUpdateType.IMMEDIATE) {
//                        Toast.makeText(this, "App Updated", Toast.LENGTH_SHORT).show()
                    } else {
//                        Toast.makeText(this, "Update Started", Toast.LENGTH_SHORT).show()
                    }
                }
                //3
                Activity.RESULT_CANCELED -> {
//                    Toast.makeText(this, "Update Cancelled", Toast.LENGTH_SHORT).show()
                }
                //4
                ActivityResult.RESULT_IN_APP_UPDATE_FAILED -> {
//                    Toast.makeText(this, "Update Failed", Toast.LENGTH_SHORT).show()
                }
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    fun getNetSpeed(context: Context, listener: UpdateRequestListener) {
        val startTime = Date().time;

        /*Create handle for the RetrofitInstance interface*/
        val service: GetDataService = retrofitInstance!!.create(GetDataService::class.java)
        val call: Call<ResponseBody> = service.getNetSpeed()
        call.enqueue(object : Callback<ResponseBody?> {
            override fun onResponse(call: Call<ResponseBody?>?, response: Response<ResponseBody?>) {
                val endTime = Date().time;
                val totalTime = (endTime - startTime) / 1000.0

                val contentLength = if (!response.headers().get("content-length").isNullOrEmpty())
                    (response.headers().get("content-length"))!!.toInt()
                else 0

                val kbs = contentLength / 1024
                val finalResult = kbs / totalTime
                listener.onRequestCompleted(finalResult)
            }

            override fun onFailure(call: Call<ResponseBody?>?, t: Throwable?) {
                listener.onRequestFailed(0.0)
            }
        })
    }

}

