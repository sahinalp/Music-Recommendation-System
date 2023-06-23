// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
// Project imports:
import 'package:music_by_mood/cubit/song_cubit.dart';
import 'package:music_by_mood/model/song_model.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          SelectFromRandomSongsTitle(
            state: state,
            selectedSongs: selectedSongs,
          ),
          if (state is SongInitial)
            const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          if (state is! SongInitial) RandomSongList(state: state, selectedSongs: selectedSongs),
          const SizedBox(height: 10),
          ElevatedButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Önerileri Listele',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: () {
              List<String> clusterLabels = [];
              for (var item in selectedSongs) {
                clusterLabels.add(item.songCluster);
                context.read<SongCubit>().selectSong(item);
              }
              context.read<SongCubit>().loadRecommendedSongs(clusterLabels);
            },
          ),
        ],
      ),
    );
  }
}

class SelectFromRandomSongsTitle extends StatelessWidget {
  const SelectFromRandomSongsTitle({
    super.key,
    required this.state,
    required this.selectedSongs,
  });

  final List<SongModel> selectedSongs;
  final SongState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      crossFadeState: state is! SelectedSongLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Aşağıda görüntüleyebileceğiniz rastgele şarkılardan veya arama yaparak seçim(ler) yapın',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      secondChild: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.orange,
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RandomSongList extends StatefulWidget {
  const RandomSongList({
    super.key,
    required this.state,
    required this.selectedSongs,
  });

  final List selectedSongs;
  final SongState state;

  @override
  State<RandomSongList> createState() => _RandomSongListState();
}

class _RandomSongListState extends State<RandomSongList> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      crossFadeState: widget.state is SongSelection ? CrossFadeState.showFirst : CrossFadeState.showFirst,
      firstChild: Container(
        height: 540,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (widget.state is! SelectedSongLoading)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Seçilen rastgele şarkı sayısı: ${widget.selectedSongs.length}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
                      ),
                    ),
                    Divider(color: Theme.of(context).primaryColor),
                    TextField(
                      controller: controller,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Search',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onChanged: (value) async {
                        if (context.read<SongCubit>().selectedSongs.length == 5) {
                          controller.clear();
                          return;
                        }
                        if (value.length > 2) {
                          await context.read<SongCubit>().search(value);
                        } else {
                          if (value.isEmpty) await context.read<SongCubit>().refreshRandomSongs();
                        }
                      },
                    ),
                  ],
                ),
              ),
            if (widget.state is RandomSongLoading || widget.state is SongSearch || widget.state is SelectedSongLoading)
              const Expanded(
                flex: 4,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            if (widget.state is SongSearchComplete)
              Expanded(
                flex: 4,
                child: ListView.builder(
                  itemCount: (widget.state as SongSearchComplete).songs.length,
                  itemBuilder: (context, index) {
                    final song = (widget.state as SongSearchComplete).songs[index];
                    return Column(
                      children: [
                        ListTile(
                          dense: true,
                          title: Text(
                            song.songName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                          ),
                          subtitle: Text(
                            song.songId,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 12),
                          ),
                          onTap: () {
                            context.read<SongCubit>().selectSong(song);
                          },
                        ),
                        Divider(color: Theme.of(context).primaryColor),
                      ],
                    );
                  },
                ),
              ),
            if (widget.state is SongSelection)
              Expanded(
                flex: 4,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    SongModel randomSong = context.read<SongCubit>().randomSongs[index];

                    return Column(
                      children: [
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0.0,
                          title: Text(
                            randomSong.songName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                          ),
                          subtitle: Text(
                            randomSong.songId,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 12),
                          ),
                          onTap: () {
                            context.read<SongCubit>().selectSong(randomSong);
                          },
                        ),
                        Divider(color: Theme.of(context).primaryColor),
                      ],
                    );
                  },
                ),
              ),
          ],
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
