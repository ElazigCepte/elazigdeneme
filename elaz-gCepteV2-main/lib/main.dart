import 'package:flutter/material.dart';
import 'package:tasarim_ornekleri/favorites.dart';
import 'denemeSayfa.dart';
import 'favorites_manager.dart';

void main() {
  runApp(const tasarim_ornekleri());
}

class AppColors {
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color secondaryRed = Color(0xFFB71C1C);
  static const Color lightRed = Color(0xFFFFCDD2);
  static const Color white = Colors.white;
  static const Color background = Colors.white;
  static const Color text = Colors.black;
}

class tasarim_ornekleri extends StatelessWidget {
  const tasarim_ornekleri({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elazığ Cepte',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryRed,
          secondary: AppColors.secondaryRed,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  String searchQuery = "";

  final List<Map<String, dynamic>> categories = [
    {'title': 'Hastaneler', 'page': HospitalListPage()},
    {'title': 'Kafeler', 'page': deneme()},
    {'title': 'Restoranlar', 'page': deneme()},
    {'title': 'eczane', 'page': deneme()},
    {'title': 'fitness', 'page': deneme()},
    {'title': 'spor', 'page': deneme()},
    {'title': 'acil', 'page': deneme()},
  ];

  List<Map<String, dynamic>> get filteredCategories {
    if (searchQuery.isEmpty) return categories;
    return categories
        .where(
          (cat) =>
              cat['title'].toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  Widget buildCategoryCard(
    BuildContext context,
    String title,
    String imagePath,
    page,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        height: screenHeight * 0.25,
        decoration: BoxDecoration(
          color: AppColors.lightRed,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(5, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.image_not_supported_rounded, size: 100),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.3333,
                  top: screenHeight * 0.04,
                ),
                child: Text(
                  "Elazığ'ı keşfet!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children:
                    filteredCategories
                        .map(
                          (cat) => buildCategoryCard(
                            context,
                            cat['title'],
                            'assets/hastane.jpg',
                            cat['page'],
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryRed,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.secondaryRed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: AppColors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  isSearching ? Icons.close : Icons.search,
                  color: AppColors.white,
                ),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    searchQuery = "";
                  });
                },
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.star_border, color: AppColors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      bottomSheet:
          isSearching
              ? Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Kategori ara...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
              : null,
    );
  }
}

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detay Sayfası")),
      body: const Center(child: Text("Bu sayfa henüz hazır değil")),
    );
  }
}

class deneme extends StatelessWidget {
  const deneme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("deneme Sayfası")),
      body: const Center(child: Text("Bu sayfa henüz  yok")),
    );
  }
}
