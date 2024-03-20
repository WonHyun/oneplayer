import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:oneplayer/controller/audio_player_provider.dart';
import 'package:provider/provider.dart';

class Player extends StatefulWidget {
  const Player({
    super.key,
  });

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AudioPlayerProvider>(context);

    return Center(
      child: Column(
        children: [
          Slider(
            value: ap.currentPosition,
            min: 0,
            max: ap.totalDuration,
            onChanged: (value) {
              ap.setCurrentPostition(value);
            },
            onChangeEnd: (value) {
              ap.seek(value.toInt());
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => ap.seekToPrevious(),
                icon: const Icon(
                  Icons.skip_previous,
                  size: 50,
                ),
              ),
              ap.isPlaying()
                  ? IconButton(
                      onPressed: () {
                        ap.pause();
                      },
                      icon: const Icon(
                        Icons.pause,
                        size: 50,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        ap.play();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        size: 50,
                      ),
                    ),
              IconButton(
                onPressed: () {
                  ap.stop();
                },
                icon: const Icon(
                  Icons.stop,
                  size: 50,
                ),
              ),
              IconButton(
                onPressed: () => ap.seekToNext(),
                icon: const Icon(
                  Icons.skip_next,
                  size: 50,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => ap.toggleShuffleMode(),
                icon: Icon(
                  Icons.shuffle,
                  size: 40,
                  color: ap.isShuffleEnabled() ? Colors.black : Colors.grey,
                ),
              ),
              LoopButton(provider: ap),
              ap.isMute
                  ? IconButton(
                      onPressed: () => ap.toggleMute(),
                      icon: const Icon(
                        Icons.volume_off,
                        size: 40,
                        color: Colors.grey,
                      ),
                    )
                  : IconButton(
                      onPressed: () => ap.toggleMute(),
                      icon: const Icon(
                        Icons.volume_up,
                        size: 40,
                      ),
                    ),
              SizedBox(
                width: 150,
                child: Slider(
                  value: ap.volume,
                  min: 0,
                  max: 1.0,
                  onChanged: (value) {
                    ap.setVolume(value);
                  },
                ),
              ),
            ],
          ),
          Text("x${ap.speed}"),
          SizedBox(
            width: 200,
            child: Slider(
              value: ap.speed,
              min: 0,
              max: 2.0,
              onChanged: (value) {
                ap.setSpeed(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Provider.of<AudioPlayerProvider>(context, listen: false).dispose();
    super.dispose();
  }
}

class LoopButton extends StatelessWidget {
  const LoopButton({
    super.key,
    required this.provider,
  });

  final AudioPlayerProvider provider;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (provider.getLoopMode() == LoopMode.all) {
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => provider.setLoopMode(LoopMode.one),
                icon: const Icon(
                  Icons.loop,
                  size: 40,
                ),
              ),
              const Text(
                "A",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          );
        } else if (provider.getLoopMode() == LoopMode.one) {
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => provider.setLoopMode(LoopMode.off),
                icon: const Icon(
                  Icons.loop,
                  size: 40,
                ),
              ),
              const Text(
                "1",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          );
        } else {
          return IconButton(
            onPressed: () => provider.setLoopMode(LoopMode.all),
            icon: const Icon(
              Icons.loop,
              size: 40,
              color: Colors.grey,
            ),
          );
        }
      },
    );
  }
}
