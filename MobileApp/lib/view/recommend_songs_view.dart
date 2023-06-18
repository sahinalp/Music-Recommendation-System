// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../cubit/song_cubit.dart';

class RecommendedSongsView extends StatelessWidget {
  const RecommendedSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('Recommended Songs'),
      ),
      body: BlocBuilder<SongCubit, SongState>(
        builder: (context, state) {
          if (state is SongLoaded) {
            final recommendedSongs = state.recommendedSongs;

            return ListView.builder(
              itemCount: recommendedSongs.length,
              itemBuilder: (ctx, index) {
                final song = recommendedSongs[index];
                return ListTile(
                  title: Text(song.name),
                  subtitle: Text(song.artistsId),
                  onTap: () {
                    // Handle song selection if needed
                  },
                );
              },
            );
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
