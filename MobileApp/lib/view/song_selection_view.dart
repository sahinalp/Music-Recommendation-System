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
    required this.selectedSongs,
  });

  final List<SongModel> selectedSongs;
  final SongState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      crossFadeState: state is! SelectedSongLoading
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Container(
        height: 200.0,
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
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text('Önerileri Listele',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  onPressed: () {
                    BlocProvider.of<SongCubit>(context).emit(
                        SelectedSongLoading(selectedSongs: selectedSongs));
                    List<String> clusterLabels=[];
                    for(var item in selectedSongs){
                      clusterLabels.add(item.songCluster);
                    }
                    BlocProvider.of<SongCubit>(context).loadRecommendedSongs(clusterLabels);
                    Navigator.of(context).push(
                      MaterialPageRoute<SongCubit>(
                        builder: (context) => BlocProvider<SongCubit>(
                          create: (context) => SongCubit(),
                          child: const RecommendedSongsView(),
                        ),
                      ),
                    );
                  }),
              Text(
                'Ekrandaki rastgele yansıyan şarkılardan veya arama yaparak çıkan şarkılardan seçim yapabilirsiniz',
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
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      crossFadeState: widget.state is SongSelection
          ? CrossFadeState.showFirst
          : CrossFadeState.showFirst,
      firstChild: Container(
        height: 440,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Seçilen random şarkı sayısı: ${widget.selectedSongs.length}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 16),
                    ),
                  ),
                  Divider(color: Theme.of(context).primaryColor),
                  Container(
                    color: Colors.white60,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        value.length > 2
                            ? context.read<SongCubit>().search(value)
                            : value.isEmpty
                            ? BlocProvider.of<SongCubit>(context)
                            .emit(RandomSongLoading())
                            : null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (widget.state is SongSearchComplete) {
                    final songs = (widget.state as SongSearchComplete).songs;
                    return  SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return Column(
                            children: [
                              ListTile(
                                // dense: true,
                                title: Text(
                                  song.songName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontSize: 20),
                                ),
                                subtitle: Text(
                                  song.songId,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontSize: 12),
                                ),
                                onTap: () {
                                  //BlocProvider.of<SongCubit>(context).selectedSongs.add(song);
                                  widget.selectedSongs.add(song);
                                  songs.removeWhere((element) => element.id == song.id);
                                  setState(() {});
                                },
                              ),
                              Divider(color: Theme.of(context).primaryColor),
                            ],
                          );
                        },
                      ),
                    );
                  }

                  SongModel randomSong = index!=0?
                       context.read<SongCubit>().randomSongs[index - 1]:context.read<SongCubit>().randomSongs[index];

                  return Column(
                    children: [
                      ListTile(
                        dense: true,
                        title: Text(
                          randomSong.songName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 20),
                        ),
                        subtitle: Text(
                          randomSong.songId,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 12),
                        ),
                        onTap: () {
                          BlocProvider.of<SongCubit>(context)
                              .selectSong(randomSong);
                          if (widget.selectedSongs.length >= 5) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const RecommendedSongsView(),
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
