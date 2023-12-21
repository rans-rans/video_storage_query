# video_storage_query

This plugin is used to return a list of all videos from your phone's storage and also used for generating video thumbnails.

**\*This package works on only android for now**

## Getting Started

To make sure this package works properly, must make sure these permissons are granted

- Read Media video
- Read External storage

And adding these tags in your AndroidManifest.xml

```
<manifest>
    <!-- Android 13 or greater  -->
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />

    <!-- Android 12 or below  -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
</manifest>
```

You can use the [PermissionHandler](https://pub.dev/packages/permission_handler) package for requesting permission

## Methods

- queryVideos
  This method returns a list of `List<VideoItem>` which is a list of object containing data about all videos on your phone's storage

```
List<VideoItem> videos = await VideoQuery().queryVideos();
```

##### VideoItem

```
class VideoItem {
  VideoItem({
    required this.name,
    required this.duration,
    required this.path,
    required this.dateAdded,
    required this.dateModified,
    required this.size,
  });
}

```

```
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
```

- getVideoThumbnail

This method is used to generate thumbnail of a video when given the video file path. It returns `Uint8List` which you can then use it in a Memory image or convert it to a file.

```
final bytes = await VideoStorage().getVideoThumbnail(filePath);

// You can display the image like this
Image.memory(bytes)
or
Image(image:MemoryImage(bytes))
```

## Contributions and support

- Contributions are welcome!
- If you want to contribute code please create a PR
- If you find a bug or want a feature, please fill an issue
