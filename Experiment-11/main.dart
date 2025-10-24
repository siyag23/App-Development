import 'package:flutter/material.dart';
import 'viewmodel/wallpaper_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(WallpaperApp());

class WallpaperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WallpaperScreen(),
    );
  }
}

class WallpaperScreen extends StatefulWidget {
  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final viewModel = WallpaperViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadWallpapers().then((_) => setState(() {}));
  }

  void refreshWallpapers() async {
    await viewModel.loadWallpapers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    switch (viewModel.state) {
      case WallpaperState.loading:
        return Scaffold(
          appBar: AppBar(title: Text('🖼 Wallpaper Explorer')),
          body: Center(child: CircularProgressIndicator()),
        );

      case WallpaperState.error:
        return Scaffold(
          appBar: AppBar(title: Text('🖼 Wallpaper Explorer')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${viewModel.errorMessage}', style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
                ElevatedButton(onPressed: refreshWallpapers, child: Text('Retry')),
              ],
            ),
          ),
        );

      case WallpaperState.empty:
        return Scaffold(
          appBar: AppBar(title: Text('🖼 Wallpaper Explorer')),
          body: Center(child: Text('No wallpapers found 😕')),
        );

      case WallpaperState.loaded:
        return Scaffold(
          appBar: AppBar(title: Text('🖼 Wallpaper Explorer')),
          body: RefreshIndicator(
            onRefresh: () async => refreshWallpapers(),
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: viewModel.wallpapers.length,
              itemBuilder: (context, index) {
                final wallpaper = viewModel.wallpapers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenWallpaper(imageUrl: wallpaper.fullImage),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: wallpaper.thumbnail,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[300]),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              },
            ),
          ),
        );
    }
  }
}

class FullScreenWallpaper extends StatelessWidget {
  final String imageUrl;
  const FullScreenWallpaper({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallpaper')),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
