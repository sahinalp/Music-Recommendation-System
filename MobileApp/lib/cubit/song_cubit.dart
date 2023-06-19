import 'dart:convert';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_by_mood/constant/constants.dart';
import '../model/song_model.dart';
import '../service/song_repository.dart';

part 'song_state.dart';

class SongCubit extends Cubit<SongState> {
  final SongRepository _songRepository = SongRepository.instance;

  List<SongModel> randomSongs = [];

  SongCubit() : super(SongInitial());

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    await _songRepository.connection.open();
    final tables = await _songRepository.connection.query("select * from \"MusicRecommendation\".\"database\" d \n");
    List<String>? tasteProfile = prefs.getStringList('tasteProfile');
    if (tasteProfile != null && tasteProfile.length == 5) {
      loadRecommendedSongs(tasteProfile.toList());
    } else {
      randomSongs = await getRandomSong();
      emit(const SongSelection(selectedSongs: []));
    }
  }

  @override
  Future<void> close() async {
    await _songRepository.connection.close();
    super.close();
  }

  void selectSong(SongModel song) async {
    if (state is SongSelection) {
      List<SongModel> selectedSongs =
          (state as SongSelection).selectedSongs.toList();
      selectedSongs.add(song);

      if (selectedSongs.length < 5) {
        emit(RandomSongLoading());

        randomSongs = await getRandomSong();
        emit(SongSelection(selectedSongs: selectedSongs));
      } else {
        emit(SelectedSongLoading(selectedSongs: selectedSongs));
      }
    }
  }



  Future<void> loadRecommendedSongs(List<String> clusterLabels) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasteProfile = prefs.getStringList('tasteProfile');

    if (tasteProfile == null) {
      prefs.setStringList(
          'tasteProfile', clusterLabels.toList());
    }

    try {
      final recommendedSongs =
          await _songRepository.getRecommendedSongs(clusterLabels);

      emit(SongLoaded(recommendedSongs: recommendedSongs));
    } catch (error) {
      emit(const SongError(error: 'Failed to load recommended songs.'));
    }
  }

  void recommendNewSongs() {
    if (state is SongLoaded) {
      final recommendedSongs = (state as SongLoaded).recommendedSongs;
      final List<SongModel> newSongs = [];

      for (var i = 0; i < 10; i++) {
        final randomIndex = Random().nextInt(recommendedSongs.length);
        newSongs.add(recommendedSongs[randomIndex]);
      }

      emit(SongLoaded(recommendedSongs: newSongs));
    }
  }

  Future<List<SongModel>> getRandomSong() async {
    List<SongModel> songs = [];
    for (var i = 0; i < 5; i++) {
      final random = Random();
      final songIndex = random.nextInt(ConstantNumbers.firabaseDatabaseSize);
      songIndex == 0 ? 1 : songIndex;
      final randomSong = await _songRepository.getRandomSong(songIndex);
      songs.add(randomSong);
    }
    return songs;
  }

  Future<List<SongModel>> search(String query) async {
    emit(SongSearch());
    final songs = <SongModel>[];
      await _songRepository.search(query);
    emit(SongSearchComplete(songs: songs));
    return songs;
  }

}
