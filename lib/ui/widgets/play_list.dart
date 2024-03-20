import 'package:flutter/material.dart';
import 'package:oneplayer/controller/audio_player_provider.dart';
import 'package:provider/provider.dart';

class Playlist extends StatefulWidget {
  const Playlist({
    super.key,
  });

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final ScrollController _scrollController = ScrollController();
  int _lastIndex = -1;

  Future _scrollToCurrentTrack(int index) async {
    double itemSize = 50.0;
    double targetOffset = itemSize * (index.toDouble() - 1);
    double maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (targetOffset < 0) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (targetOffset > maxScrollExtent) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      await _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AudioPlayerProvider>(context);

    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: ap.getAudioFilesFromDirectory,
              child: const Icon(Icons.folder),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                ap.currentDirectory == ""
                    ? "Select Directory"
                    : ap.currentDirectory,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 200,
          child: Builder(builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (_lastIndex != ap.getCurrentPlayIndex()) {
                _lastIndex = ap.getCurrentPlayIndex();
                _scrollToCurrentTrack(ap.getCurrentPlayIndex());
              }
            });
            return ListView.builder(
              controller: _scrollController,
              itemCount: ap.getSongCount(),
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      ap.setPlaySong(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == ap.getCurrentPlayIndex()
                            ? Colors.deepPurpleAccent
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.square,
                            size: 50,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ap.getSongInfo(index).fileName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
