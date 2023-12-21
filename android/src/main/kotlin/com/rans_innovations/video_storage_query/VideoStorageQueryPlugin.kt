@file:Suppress("DEPRECATION")

package com.rans_innovations.video_storage_query

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.media.ThumbnailUtils
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream
import java.io.File


/** VideoStorageQueryPlugin */
class VideoStorageQueryPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var ctx: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "video_storage_query")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        when (call.method) {
            "query_videos" -> {
                val videos = VideoQuery().getVideoFiles(ctx)
                result.success(videos)
            }

            "get_thumbnail" -> {
                val path = call.arguments as String
                val bytes = VideoQuery().getImageThumbnail(path)
                result.success(bytes)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        ctx = binding.activity.applicationContext
    }

    override fun onDetachedFromActivityForConfigChanges() {
        return
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        return
    }

    override fun onDetachedFromActivity() {
        return
    }

    inner class VideoQuery {

        fun getVideoFiles(context: Context): List<Map<*, *>> {
            val contentResolver = context.contentResolver
            val cursor = contentResolver.query(
                MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                arrayOf(
                    MediaStore.Video.Media.DATA,
                    MediaStore.Video.Media.DURATION,
                    MediaStore.Video.Media.DISPLAY_NAME,
                    MediaStore.Video.Media.DATE_ADDED,
                    MediaStore.Video.Media.DATE_MODIFIED,
                    MediaStore.Video.Media.SIZE,
                ),
                null,
                null,
                MediaStore.Video.Media.DEFAULT_SORT_ORDER
            )
            val videoFiles = mutableListOf<Map<*, *>>()
            if (cursor != null) {
                while (cursor.moveToNext()) {

                    val filePath =
                        cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATA))
                            ?: ""
                    val name =
                        cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DISPLAY_NAME))
                            ?: ""
                    val duration =
                        cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DURATION))
                            ?: ""
                    val dateAdded =
                        cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_ADDED))
                            ?: ""
                    val dateModified =
                        cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_MODIFIED))
                            ?: ""
                    val size =
                        cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.SIZE))
                            ?: ""



                    videoFiles.add(
                        mapOf(
                            "name" to name,
                            "path" to filePath,
                            "duration" to duration,
                            "dateAdded" to dateAdded,
                            "dateModified" to dateModified,
                            "size" to size,
                        )
                    )
                }
                cursor.close()
            }
            return videoFiles
        }

        fun getImageThumbnail(path: String): ByteArray {
            val retriever = MediaMetadataRetriever()
            val file = File(path)
            retriever.setDataSource(file.path)
            val bitmap =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    retriever.frameAtTime
                } else {
                    ThumbnailUtils.createVideoThumbnail(path, 1)
                }

            return convertIntoByteArray(bitmap!!)
        }

        private fun convertIntoByteArray(bitmap: Bitmap): ByteArray {
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)

            return stream.toByteArray()
        }

    }

}
