class BannerEntity {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final String? image;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.image,
  });

  static const empty = BannerEntity(
    id: '',
    title: '',
    subtitle: '',
    tag: '',
    image: '',
  );

  factory BannerEntity.fromJson(Map<String, dynamic> json) {
    return BannerEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      tag: json['tag'] as String,
      image: json['image'] as String,
    );
  }
}
