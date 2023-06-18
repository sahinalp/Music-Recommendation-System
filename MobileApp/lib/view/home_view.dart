// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../cubit/song_cubit.dart';
import '../model/song_model.dart';
import 'recommend_songs_view.dart';
import 'song_selection_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<SongModel> selectedSongs = [];
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          'Song Recommender',
          style: CupertinoTheme.of(context)
              .textTheme
              .navTitleTextStyle
              .copyWith(
                color: CupertinoTheme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
        ),
        brightness: Theme.of(context).brightness,
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
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
          pageController.animateToPage(1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        } else if (state is SelectedSongLoading) {
          context.read<SongCubit>().loadRecommendedSongs(
              state.selectedSongs.map((song) => song.clusterLabel).toList());
        }
      }, builder: (context, state) {
        if (state is SongInitial) {
          context.read<SongCubit>().initialize();
        }
        selectedSongs = state is SongSelection
            ? state.selectedSongs.toList()
            : selectedSongs;

        return PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            if (state is SongSelection)
              SongSelectionView(state: state, selectedSongs: selectedSongs),
            const RecommendedSongsView()
          ],
        );
      }),
    );
  }
}
