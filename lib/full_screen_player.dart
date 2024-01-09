import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends HookWidget {
  const FullScreenPlayer({super.key});

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
      body: Stack(
        children: [
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              child: VideoPlayer(videoController),
            ),
            // 動画を表示
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            height: 20,
            child:
                Center(child: Text(' ${position.value} / ${duration.value}')),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 120,
            height: 8,
            child: VideoProgressIndicator(
              videoController,
              allowScrubbing: true,
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 16,
            height: 64,
            child: Row(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
