import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_storage_query/video_storage_query.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final query = VideoStorageQuery();
  @override
  void initState() {
    super.initState();
    // asking user for storage for missing
    const MethodChannel("channel").invokeMethod("initialize_permissions");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: StreamBuilder(
          stream: query.queryVideos().asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null) {
              return const Center(
                child: Text(
                  "Error returning data",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            final videos = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: videos.length > 10 ? 10 : videos.length,
              itemBuilder: (context, index) {
                final item = videos[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.duration,
                      style: const TextStyle(color: Colors.white),
                    ),
                    FutureBuilder<Uint8List>(
                      future: query.getVideoThumbnail(item.path),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return Image.memory(
                          snap.data!,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
