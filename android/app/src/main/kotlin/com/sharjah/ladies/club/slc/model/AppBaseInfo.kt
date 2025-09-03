package com.sharjah.ladies.club.slc.model

import com.google.gson.annotations.SerializedName

data class AppBaseInfo(@SerializedName("appVersionNum")
                       val appVersionNum: Int,
                       @SerializedName("vectorKey")
                       val vectorKey: String,
                       @SerializedName("secretKey")
                       val secretKey: String,
                       @SerializedName("eventRegistrationCount")
                       val eventRegistrationCount: Int,
                       @SerializedName("appKey")
                       val appKey: String,
                       @SerializedName("netSpeed")
                       val netSpeed: Double) {

}