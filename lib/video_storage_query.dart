import 'dart:typed_data';

import 'video_storage_query_platform_interface.dart';

/// A utility class for querying video information and retrieving video thumbnails
/// from the phone storage in Flutter.
///
/// Use the [VideoStorageQuery] class to perform video-related operations such as
/// querying and retrieving video objects, as well as obtaining video thumbnails.
///
/// Example usage:
/// ```dart
/// VideoStorageQuery videoQuery = VideoStorageQuery();
/// List<VideoItem> videos = await videoQuery.queryVideos();
/// Uint8List thumbnail = await videoQuery.getVideoThumbnail('/storage/emulated/0/Download/sample.mp4');
/// ```

///
/// Note: Ensure that the necessary permissions are granted to access the phone's
/// storage before invoking methods in this class.
class VideoStorageQuery {
  /// Queries and retrieves a list of video objects from the phone storage in Flutter.
  ///
  /// This asynchronous function utilizes the [VideoStorageQueryPlatform] instance to
  /// perform the video query operation. It returns a [Future] that resolves to a
  /// [List] of [VideoItem] objects representing the videos found in the phone storage.
  ///]
  ///
  /// Example usage:
  /// ```dart
  /// List<VideoItem> videos = await videoQuery.queryVideos();
  /// ```
  ///
  /// Throws an error if the video query operation encounters any issues, and the
  /// error is rethrown for further handling.
  ///
  /// Returns: A [Future] containing a [List] of [VideoItem] objects representing the
  /// videos in the phone storage.
  Future<List<VideoItem>> queryVideos() async {
    try {
      final data = await VideoStorageQueryPlatform.instance.queryVideos();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves the thumbnail of a video located at the specified [path] in Flutter.
  ///
  /// This asynchronous function uses the [VideoStorageQueryPlatform] instance to
  /// obtain the thumbnail as a [Uint8List]. The [path] parameter should represent
  /// the file path of the target video.
  ///
  /// Example usage:
  /// ```dart
  /// Uint8List thumbnail = await videoQuery.getVideoThumbnail('/storage/emulated/0/Download/sample.mp4');
  /// ```
  /// You can then use it in your image widget:
  /// ```dart
  /// Image.memory(thumbnail)
  /// ```
  ///
  /// Throws an error if there are issues obtaining the video thumbnail, and the error
  /// is rethrown for further handling.
  ///
  /// Returns: A [Future] containing a [Uint8List] representing the thumbnail of the
  /// video located at the specified [path].
  Future<Uint8List> getVideoThumbnail(String path) async {
    try {
      final bytes =
          await VideoStorageQueryPlatform.instance.getVideoThumbnail(path);
      return bytes;
    } catch (e) {
      rethrow;
    }
  }
}

/// Represents a video item with metadata information such as name, duration, path,
/// date added, date modified, description, and size.
///
/// Use this class to encapsulate details about a video file when working with video
/// data in your Flutter application.
///```
/// String name
/// ```
///```
/// String duration
/// ```
///```
/// String path
/// ```
///```
/// String dateAdded
/// ```
///```
/// String dateModified
/// ```
///```
/// String size
/// ```
class VideoItem {
  /// The name of the video file.
  final String name;

  /// The duration of the video in milliseconds.
  final String duration;

  /// The file path to the video.
  final String path;

  /// The date when the video was added to storage.
  final String dateAdded;

  /// The date when the video was last modified.
  final String dateModified;

  /// The size of the video file in bytes.
  /// You might want to convert it to kilobytes, megabytes or gigabytes
  final String size;

  /// Creates a [VideoItem] instance with the provided details.
  ///
  /// All parameters are required.
  VideoItem({
    required this.name,
    required this.duration,
    required this.path,
    required this.dateAdded,
    required this.dateModified,
    required this.size,
  });

  /// Creates a new [VideoItem] instance with updated properties.
  ///
  /// Parameters marked as nullable allow for updating specific properties while
  /// keeping the existing values for others.
  ///
  /// Example usage:
  /// ```dart
  /// VideoItem updatedVideo = originalVideo.copyWith(name: 'New Name', size: '2 GB');
  /// ```
  VideoItem copyWith({
    String? name,
    String? duration,
    String? path,
    String? dateAdded,
    String? dateModified,
    String? description,
    String? size,
  }) {
    return VideoItem(
      name: name ?? this.name,
      duration: duration ?? this.duration,
      path: path ?? this.path,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      size: size ?? this.size,
    );
  }

  /// Creates a [VideoItem] instance from a map of data.
  ///
  /// The provided data map should contain keys corresponding to the properties
  /// of the [VideoItem] class.
  factory VideoItem.fromMap(Object? data) {
    final map = data as Map<Object?, Object?>;
    return VideoItem(
      name: map['name'].toString(),
      duration: map['duration'].toString(),
      path: map['path'].toString(),
      dateAdded: map['dateAdded'].toString(),
      dateModified: map['dateModified'].toString(),
      size: map['size'].toString(),
    );
  }

  /// Returns a string representation of the [VideoItem] instance.
  @override
  String toString() {
    return """
VideoItem(name: $name, duration: $duration, path: $path, dateAdded: $dateAdded, dateModified: $dateModified, size: $size)""";
  }

  /// Checks if two [VideoItem] instances are equal by comparing their properties.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoItem &&
        other.name == name &&
        other.duration == duration &&
        other.path == path &&
        other.dateAdded == dateAdded &&
        other.dateModified == dateModified &&
        other.size == size;
  }

  /// Generates a hash code based on the [VideoItem] instance's properties.
  @override
  int get hashCode {
    return name.hashCode ^
        duration.hashCode ^
        path.hashCode ^
        dateAdded.hashCode ^
        dateModified.hashCode ^
        size.hashCode;
  }
}
