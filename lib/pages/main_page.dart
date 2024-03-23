import 'package:flutter/material.dart';
import 'package:oneplayer/ui/widgets/play_list.dart';
import 'package:oneplayer/ui/widgets/player.dart';
import 'package:oneplayer/controller/audio_player_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AudioPlayerProvider()),
      ],
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Playlist(),
            Player(),
          ],
        ),
      ),
    );
  }
}
