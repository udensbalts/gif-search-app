import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'gif_detail_screen.dart';
import '../application/search_provider.dart';

class GifSearchScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gifState = ref.watch(gifSearchProvider);
    final searchNotifier = ref.read(gifSearchProvider.notifier);
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text(
          'GIF Search',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.redAccent),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[600],
                hintText: 'Search GIFs...',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.redAccent),
                        onPressed: () {
                          searchController.clear();
                          searchNotifier.updateSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: (query) => searchNotifier.updateSearchQuery(query),
            ),
          ),
          Expanded(
            child: gifState.when(
              data: (gifs) => gifs.isEmpty
                  ? Center(
                      child: Text('No GIFs found',
                          style: TextStyle(color: Colors.redAccent)))
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo is ScrollEndNotification &&
                            scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 100) {
                          searchNotifier.loadMoreGifs();
                        }
                        return false;
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: gifs.length + 1, // +1 for loading indicator
                        itemBuilder: (context, index) {
                          if (index == gifs.length) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Colors.redAccent));
                          }
                          final gif = gifs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GifDetailScreen(gif: gif),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                gif.previewUrl,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[900]!,
                                    highlightColor: Colors.redAccent,
                                    child: Container(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              loading: () => Center(
                  child: CircularProgressIndicator(color: Colors.redAccent)),
              error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }
}
