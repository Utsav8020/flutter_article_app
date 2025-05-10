import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';

class ArticleDetailScreen extends StatelessWidget {
  final int articleId;

  const ArticleDetailScreen({
    Key? key,
    required this.articleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(
      builder: (context, provider, child) {
        final article = provider.getArticleById(articleId);

        if (article == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Article Not Found'),
            ),
            body: const Center(
              child: Text('The requested article could not be found.'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Article Details'),
            actions: [
              IconButton(
                icon: Icon(
                  article.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: article.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  provider.toggleFavorite(article.id);
                },
              ),
            ],
          ),
          body: _buildArticleDetails(context, article),
        );
      },
    );
  }

  Widget _buildArticleDetails(BuildContext context, Article article) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'User ID: ${article.userId}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade800,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          Text(
            article.body,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                icon: Icon(
                  article.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: article.isFavorite ? Colors.red : null,
                ),
                label: Text(
                  article.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                ),
                onPressed: () {
                  Provider.of<ArticleProvider>(context, listen: false)
                      .toggleFavorite(article.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
