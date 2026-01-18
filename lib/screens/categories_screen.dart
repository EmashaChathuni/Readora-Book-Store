import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'books_by_category_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'සිංහල සාහිත්‍යය',
      'englishName': 'Sinhala Literature',
      'icon': Icons.menu_book,
      'color': Color(0xFFE67E22),
      'gradient': [Color(0xFFE67E22), Color(0xFFD35400)],
    },
    {
      'name': 'ප්‍රේම කතා',
      'englishName': 'Love Stories',
      'icon': Icons.favorite,
      'color': Color(0xFFE91E63),
      'gradient': [Color(0xFFE91E63), Color(0xFFC2185B)],
    },
    {
      'name': 'නවීන සාහිත්‍යය',
      'englishName': 'Modern Literature',
      'icon': Icons.auto_stories,
      'color': Color(0xFF9C27B0),
      'gradient': [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
    },
    {
      'name': 'ළමා සාහිත්‍යය',
      'englishName': 'Children Literature',
      'icon': Icons.child_care,
      'color': Color(0xFF3498DB),
      'gradient': [Color(0xFF3498DB), Color(0xFF2980B9)],
    },
    {
      'name': 'කාව්‍ය',
      'englishName': 'Poetry',
      'icon': Icons.format_quote,
      'color': Color(0xFFFF5722),
      'gradient': [Color(0xFFFF5722), Color(0xFFE64A19)],
    },
    {
      'name': 'නාට්‍ය',
      'englishName': 'Drama',
      'icon': Icons.theater_comedy,
      'color': Color(0xFF00BCD4),
      'gradient': [Color(0xFF00BCD4), Color(0xFF0097A7)],
    },
    {
      'name': 'බෞද්ධ සාහිත්‍යය',
      'englishName': 'Buddhist Literature',
      'icon': Icons.temple_buddhist,
      'color': Color(0xFFFF9800),
      'gradient': [Color(0xFFFF9800), Color(0xFFF57C00)],
    },
    {
      'name': 'සංස්කෘතික',
      'englishName': 'Cultural',
      'icon': Icons.museum,
      'color': Color(0xFF795548),
      'gradient': [Color(0xFF795548), Color(0xFF5D4037)],
    },
    {
      'name': 'ඉතිහාසය',
      'englishName': 'History',
      'icon': Icons.history_edu,
      'color': Color(0xFF607D8B),
      'gradient': [Color(0xFF607D8B), Color(0xFF455A64)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBrown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Categories',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(context, category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BooksByCategoryScreen(
              categoryName: category['name'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: category['gradient'],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: category['color'].withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category['icon'],
                size: 45,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (category.containsKey('englishName')) ...[
                    SizedBox(height: 4),
                    Text(
                      category['englishName'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
