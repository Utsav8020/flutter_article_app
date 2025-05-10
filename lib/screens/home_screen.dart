import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/search_bar.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Article App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Articles'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            onSearch: (query) {
              Provider.of<ArticleProvider>(context, listen: false)
                  .searchArticles(query);
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildArticleList(),
                _buildFavoritesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleList() {
    return Consumer<ArticleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.state == ArticleProviderState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${provider.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchArticles(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final articles = provider.articles;
        
        if (articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.article_outlined, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No articles found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchArticles(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleCard(
                article: article,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(articleId: article.id),
                    ),
                  );
                },
                onFavoriteToggle: () {
                  provider.toggleFavorite(article.id);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoritesList() {
    return Consumer<ArticleProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favoriteArticles;

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No favorite articles yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final article = favorites[index];
            return ArticleCard(
              article: article,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(articleId: article.id),
                  ),
                );
              },
              onFavoriteToggle: () {
                provider.toggleFavorite(article.id);
              },
            );
          },
        );
      },
    );
  }
}
