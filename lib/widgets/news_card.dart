import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final bool isSaved;
  final VoidCallback onSave;

  const NewsCard({
    super.key,
    required this.news,
    required this.isSaved,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizing
    final isSmallScreen = screenWidth < 400;
    final imageHeight = isSmallScreen ? 160.0 : 200.0;
    final padding = screenWidth * 0.03; // ~12 on 400px
    final fontSizeTitle = isSmallScreen ? 16.0 : 18.0;
    final fontSizeMeta = isSmallScreen ? 12.0 : 14.0;

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: padding),
      child: InkWell(
        onTap: () => _launchURL(news.url),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: news.image,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: imageHeight,
                      color: Theme.of(context).cardColor.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: imageHeight,
                      color: Theme.of(context)
                          .colorScheme
                          .errorContainer
                          .withOpacity(0.1),
                      child: Icon(
                        Icons.error,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: padding),
              Text(
                news.headline,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: padding * 0.6),
              Row(
                children: [
                  Text(
                    news.source,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: fontSizeMeta,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    news.formattedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: fontSizeMeta,
                        ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).iconTheme.color?.withOpacity(0.6),
                  ),
                  onPressed: onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
