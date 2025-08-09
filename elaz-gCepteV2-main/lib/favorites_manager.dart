class FavoritesManager {
  static final List<Map<String, String>> _favorites = [];

  static List<Map<String, String>> get favorites => _favorites;

  static void add(Map<String, String> hospital) {
    _favorites.add(hospital);
  }

  static void remove(String hospitalName) {
    _favorites.removeWhere((item) => item['name'] == hospitalName);
  }

  static bool isFavorite(String hospitalName) {
    return _favorites.any((item) => item['name'] == hospitalName);
  }
}