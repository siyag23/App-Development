import '../models/wallpaper.dart';
import '../repository/wallpaper_repository.dart';

enum WallpaperState { loading, loaded, empty, error }

class WallpaperViewModel {
  final WallpaperRepository _repository = WallpaperRepository();

  WallpaperState state = WallpaperState.loading;
  List<Wallpaper> wallpapers = [];
  String? errorMessage;

  Future<void> loadWallpapers() async {
    try {
      state = WallpaperState.loading;
      final data = await _repository.getWallpapers();
      if (data.isEmpty) {
        state = WallpaperState.empty;
      } else {
        wallpapers = data;
        state = WallpaperState.loaded;
      }
    } catch (e) {
      state = WallpaperState.error;
      errorMessage = e.toString();
    }
  }
}
