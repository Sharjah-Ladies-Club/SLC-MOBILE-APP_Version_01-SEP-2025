interface UpdateRequestListener {
    fun onRequestCompleted(responseObject: Any?)

    fun onRequestFailed(responseObject: Any?)
}