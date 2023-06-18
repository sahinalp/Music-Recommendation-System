part of 'song_cubit.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object?> get props => [];
}

class SongInitial extends SongState {}

class RandomSongLoading extends SongState {}

class SongSelection extends SongState {
  final List<SongModel> selectedSongs;

  const SongSelection({this.selectedSongs = const []});

  @override
  List<Object?> get props => [selectedSongs];
}

class SelectedSongLoading extends SongState {
  final List<SongModel> selectedSongs;

  const SelectedSongLoading({required this.selectedSongs});

  @override
  List<Object?> get props => [selectedSongs];
}

class SongLoaded extends SongState {
  final List<SongModel> recommendedSongs;

  const SongLoaded({required this.recommendedSongs});

  @override
  List<Object?> get props => [recommendedSongs];
}

class SongError extends SongState {
  final String error;

  const SongError({required this.error});

  @override
  List<Object?> get props => [error];
}
