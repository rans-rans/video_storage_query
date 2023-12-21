import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_storage_query/video_storage_query.dart';

import 'video_storage_query_method_channel.dart';

abstract class VideoStorageQueryPlatform extends PlatformInterface {
  /// Constructs a VideoStorageQueryPlatform.
  VideoStorageQueryPlatform() : super(token: _token);

  static final Object _token = Object();

  static VideoStorageQueryPlatform _instance = MethodChannelVideoStorageQuery();

  /// The default instance of [VideoStorageQueryPlatform] to use.
  ///
  /// Defaults to [MethodChannelVideoStorageQuery].
  static VideoStorageQueryPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VideoStorageQueryPlatform] when
  /// they register themselves.
  static set instance(VideoStorageQueryPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<VideoItem>> queryVideos();
  Future<Uint8List> getVideoThumbnail(String path);
}
