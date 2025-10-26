// ================ lib/features/getstarted/get_started_screen.dart ================
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../core/theme_controller.dart';
import '../home/home_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late final VideoPlayerController _controller;
  final ThemeController _theme = ThemeController.instance;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/background/click_pakar.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const SizedBox.shrink(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withValues(alpha: 0.5), Colors.black.withValues(alpha: 0.2)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      tooltip: 'Ubah Tema',
                      onPressed: _theme.toggle,
                      icon: Icon(_theme.mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                    ),
                  ),
                  const Spacer(),
                  Image.asset('assets/logo/logo.png', width: 140, height: 140),
                  const SizedBox(height: 80),
                  Text(
                    'Sistem Pakar Medis',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Diagnosa awal penyakit pada Anak & Kehamilan',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text('Get Started'),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
