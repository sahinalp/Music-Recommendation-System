// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../cubit/song_cubit.dart';
import '../model/song_model.dart';
import 'recommend_songs_view.dart';

class SongSelectionView extends StatelessWidget {
  const SongSelectionView({
    super.key,
    required this.state,
    required this.selectedSongs,
  });

  final List<SongModel> selectedSongs;
  final SongState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SelectFromRandomSongsTitle(state: state),
          if (state is SongInitial)
            const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          if (state is! SongInitial)
            RandomSongList(state: state, selectedSongs: selectedSongs),
        ],
      ),
    );
  }
}

class SelectFromRandomSongsTitle extends StatelessWidget {
  const SelectFromRandomSongsTitle({
    super.key,
    required this.state,
  });

  final SongState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      crossFadeState: state is! SelectedSongLoading
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Lets Create Your Taste Profile',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'Select 5 songs from the song lists below',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      secondChild: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please wait...\nWe are creating suggestions based on your taste',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RandomSongList extends StatelessWidget {
  const RandomSongList({
    super.key,
    required this.state,
    required this.selectedSongs,
  });

  final List selectedSongs;
  final SongState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      crossFadeState: state is SongSelection
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Container(
        height: 480,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                        'Selected songs: ${selectedSongs.length}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 16),
                      ),
                    ),
                    Divider(color: Theme.of(context).primaryColor),
                  ],
                );
              }
              SongModel randomSong =
                  context.read<SongCubit>().randomSongs[index - 1];
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    title: Text(
                      randomSong.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 20),
                    ),
                    subtitle: Text(
                      randomSong.artistsId,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 12),
                    ),
                    onTap: () {
                      context.read<SongCubit>().selectSong(randomSong);
                      if (selectedSongs.length >= 5) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const RecommendedSongsView(),
                          ),
                        );
                      }
                    },
                  ),
                  Divider(color: Theme.of(context).primaryColor),
                ],
              );
            },
          ),
        ),
      ),
      secondChild: const SizedBox(
        height: 150,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
