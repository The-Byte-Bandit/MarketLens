import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Articles')),
      body: newsProvider.savedArticles.isEmpty
          ? const Center(child: Text('No saved articles'))
          : ListView.builder(
              itemCount: newsProvider.savedArticles.length,
              itemBuilder: (ctx, index) {
                final article = newsProvider.savedArticles[index];
                return Dismissible(
                  key: Key(article.url),
                  onDismissed: (_) => newsProvider.toggleSaveArticle(article),
                  background: Container(color: Colors.red),
                  child: NewsCard(
                    news: article,
                    isSaved: true,
                    onSave: () => newsProvider.toggleSaveArticle(article),
                  ),
                );
              },
            ),
    );
  }
}
