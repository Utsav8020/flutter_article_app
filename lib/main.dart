import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/article_provider.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

void main() async {
  // Ensure widgets are initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the storage service
  final storageService = StorageService();
  await storageService.init();
  
  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  
  const MyApp({Key? key, required this.storageService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArticleProvider(storageService),
      child: MaterialApp(
        title: 'Flutter Article App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
