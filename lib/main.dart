import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_practice/full_screen_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'video player demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VideoPlayerPage(),
    );
  }
}

class VideoPlayerPage extends HookWidget {
  const VideoPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useState<VideoPlayerController?>(null);
    final position = useState<String>('');
    final duration = useState<String>('');

    useEffect(
      () {
        controller.value = VideoPlayerController.networkUrl(
          Uri.parse(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
        )..initialize().then(
            (_) {
              // controller.value!.play();
              // controller.value!.setLooping(true);
              // final listener = useListenable(videoController);
            },
          );

        controller.value!.addListener(() {
          // position.value = controller.value!.value.position.toString();
          position.value =
              controller.value!.value.position.inSeconds.toStringAsFixed(0);
          // duration.value = controller.value!.value.duration.toString();
          duration.value =
              controller.value!.value.duration.inSeconds.toStringAsFixed(0);
        });
        return () {
          controller.value!.dispose();
        };
      },
      [],
    );

    final videoController = controller.value;
    if (videoController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            // 動画を表示
            child: VideoPlayer(videoController),
          ),
          VideoProgressIndicator(
            videoController,
            allowScrubbing: true,
          ),
          Text(' ${position.value} / ${duration.value}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () async {
                  await videoController.seekTo(Duration.zero);
                  await videoController.play();
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () async {
                  await videoController.play();
                },
                icon: const Icon(Icons.play_arrow),
              ),
              IconButton(
                onPressed: () async {
                  await videoController.pause();
                },
                icon: const Icon(Icons.pause),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const FullScreenPlayer();
                      },
                    ),
                  );
                },
                child: const Text('全画面'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
