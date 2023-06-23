// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:music_by_mood/cubit/song_cubit.dart';
import 'package:music_by_mood/view/recommend_songs_view.dart';
import 'package:music_by_mood/view/song_selection_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentPage == 0 ? 'Müzik Öneri Sistemi' : 'Önerilen Şarkılar',
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: currentPage == 1
            ? IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  context.read<SongCubit>().initialize();
                  setState(() {
                    currentPage = 0;
                  });
                },
              )
            : null,
      ),
      body: BlocConsumer<SongCubit, SongState>(listener: (context, state) {
        if (state is SongError) {
          showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Error'),
              content: Text(state.error),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        } else if (state is SongLoaded) {
          // Navigate to recommended songs screen
          pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
          setState(() {
            currentPage = 1;
          });
        } else if (state is SelectedSongLoading) {
          context.read<SongCubit>().loadRecommendedSongs(context.read<SongCubit>().selectedSongs.map((song) => song.songCluster).toList());
        }
      }, builder: (context, state) {
        if (state is SongInitial) {
          context.read<SongCubit>().initialize();
        }

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // if (state is SongSelection)
              SongSelectionView(state: state, selectedSongs: context.read<SongCubit>().selectedSongs),
              const RecommendedSongsView()
            ],
          ),
        );
      },),
    );
  }
}
