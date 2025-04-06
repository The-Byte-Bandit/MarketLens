import 'package:intl/intl.dart';

class News {
  final String headline;
  final String source;
  final String url;
  final String image;
  final String datetime;
  final String? category;
  final String? summary;
  final int? id;

  News({
    required this.headline,
    required this.source,
    required this.url,
    required this.image,
    required this.datetime,
    this.category,
    this.summary,
    this.id,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      headline: json['headline'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      datetime: json['datetime']?.toString() ?? '',
      category: json['category'],
      summary: json['summary'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headline': headline,
      'source': source,
      'url': url,
      'image': image,
      'datetime': datetime,
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (id != null) 'id': id,
    };
  }

  String get formattedDate {
    try {
      // Try parsing as Unix timestamp first
      final timestamp = int.tryParse(datetime);
      if (timestamp != null) {
        return DateFormat('MMM dd, yyyy - hh:mm a')
            .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
      }

      // Try parsing as ISO string
      final dateTime = DateTime.tryParse(datetime);
      if (dateTime != null) {
        return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
      }

      // Fallback to original string if parsing fails
      return datetime;
    } catch (e) {
      return datetime;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is News && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}
