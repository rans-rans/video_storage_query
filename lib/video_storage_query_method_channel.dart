import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:video_storage_query/video_storage_query.dart';

import 'video_storage_query_platform_interface.dart';

/// An implementation of [VideoStorageQueryPlatform] that uses method channels.
class MethodChannelVideoStorageQuery extends VideoStorageQueryPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('video_storage_query');

  @override
  Future<List<VideoItem>> queryVideos() async {
    final response =
        await methodChannel.invokeMethod("query_videos") as List<Object?>;
    final videos = response.map(VideoItem.fromMap).toList();
    return videos;
  }

  @override
  Future<Uint8List> getVideoThumbnail(String path) async {
    final response =
        await methodChannel.invokeMethod("get_thumbnail", path) as Uint8List;
    return response;
  }
}
