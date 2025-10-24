class Wallpaper {
  final String id;
  final String photographer;
  final String thumbnail;
  final String fullImage;

  Wallpaper({
    required this.id,
    required this.photographer,
    required this.thumbnail,
    required this.fullImage,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'].toString(),
      photographer: json['photographer'] ?? '',
      thumbnail: json['src']['medium'],
      fullImage: json['src']['original'],
    );
  }
}
