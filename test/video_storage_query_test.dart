import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:video_storage_query/video_storage_query.dart';
import 'package:video_storage_query/video_storage_query_platform_interface.dart';
import 'package:video_storage_query/video_storage_query_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVideoStorageQueryPlatform
    with MockPlatformInterfaceMixin
    implements VideoStorageQueryPlatform {
  @override
  Future<List<VideoItem>> queryVideos() {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> getVideoThumbnail(String path) {
    throw UnimplementedError();
  }
}

void main() {
  final VideoStorageQueryPlatform initialPlatform =
      VideoStorageQueryPlatform.instance;

  test('$MethodChannelVideoStorageQuery is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVideoStorageQuery>());
  });

  test('getPlatformVersion', () async {
    MockVideoStorageQueryPlatform fakePlatform =
        MockVideoStorageQueryPlatform();
    VideoStorageQueryPlatform.instance = fakePlatform;
  });
}
