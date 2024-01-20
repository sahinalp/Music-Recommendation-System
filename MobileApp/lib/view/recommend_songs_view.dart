// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:music_by_mood/cubit/song_cubit.dart';

class RecommendedSongsView extends StatefulWidget {
  const RecommendedSongsView({super.key});

  @override
  State<RecommendedSongsView> createState() => _RecommendedSongsViewState();
}

class _RecommendedSongsViewState extends State<RecommendedSongsView> {
  Future<void> _launchUrl(Uri url) async {
    if (await launchUrl(url)) {
      await _launchUrl(url);
    }
  }

  /*
  str(x.content).split('by')[1].split('|')[0].strip()
  * */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SongCubit, SongState>(
        builder: (context, state) {
          if (state is SongLoaded) {
            final recommendedSongs = state.recommendedSongs.toList();
            return recommendedSongs.isEmpty
                ? const Center(child: Text('Önce şarkı seçiniz.'))
                : ListView.builder(
                    itemCount: recommendedSongs.length,
                    itemBuilder: (ctx, index) {
                      final song = recommendedSongs[index];
                      return ListTile(
                        title: Text(song.songName),
                        subtitle: Text(song.songId),
                        onTap: () async {
                          Uri url = Uri.parse(song.uri);
                          String uri = url.path;
                          String spotifyUrl=uri.replaceAll("track:", "https://open.spotify.com/track/");
                          url =Uri.parse(spotifyUrl);
                          if (await launchUrl(url)) {
                            await _launchUrl(url);
                          }

                          // Handle song selection if needed
                        },
                      );
                    },
                  );
          } else if (state is SongInitial) {
            return const Center(child: Text('Önce şarkı seçiniz.'));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          context.read<SongCubit>().recommendNewSongs();
        },
      ),
    );
  }
}
