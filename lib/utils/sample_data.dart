import 'package:cloud_firestore/cloud_firestore.dart';

class SampleDataHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addSampleBooks() async {
    final books = [
      {
        'title': 'Gamperaliya',
        'author': 'Martin Wickramasinghe',
        'description': 'A landmark Sinhala novel depicting the changing village life in colonial Sri Lanka. The first part of a trilogy exploring social transformation.',
        'price': 850.00,
        'coverImage': '',
        'category': 'Sinhala Classic',
        'rating': 4.9,
      },
      {
        'title': 'Kaliyugaya',
        'author': 'Martin Wickramasinghe',
        'description': 'The second part of the trilogy, exploring the age of darkness and moral decline in Sri Lankan society.',
        'price': 900.00,
        'coverImage': '',
        'category': 'Sinhala Classic',
        'rating': 4.8,
      },
      {
        'title': 'Yuganthaya',
        'author': 'Martin Wickramasinghe',
        'description': 'The final part of the trilogy, depicting the end of an era and the birth of a new social order in Sri Lanka.',
        'price': 900.00,
        'coverImage': '',
        'category': 'Sinhala Classic',
        'rating': 4.8,
      },
      {
        'title': 'Madol Duwa',
        'author': 'Martin Wickramasinghe',
        'description': 'A beloved children\'s adventure story about a boy who runs away to an island, considered a classic of Sinhala literature.',
        'price': 750.00,
        'coverImage': '',
        'category': 'Sinhala Fiction',
        'rating': 4.9,
      },
      {
        'title': 'Viragaya',
        'author': 'Martin Wickramasinghe',
        'description': 'A philosophical novel exploring Buddhist concepts of detachment and the journey towards spiritual liberation.',
        'price': 800.00,
        'coverImage': '',
        'category': 'Sinhala Classic',
        'rating': 4.7,
      },
      {
        'title': 'Chinigura Mal',
        'author': 'G.B. Senanayake',
        'description': 'A classic Sinhala novel depicting rural life and traditional values in Sri Lankan society.',
        'price': 650.00,
        'coverImage': '',
        'category': 'Sinhala Fiction',
        'rating': 4.5,
      },
      {
        'title': 'Arachchi Mahaththaya',
        'author': 'Kumaratunga Munidasa',
        'description': 'A satirical work critiquing colonial-era social attitudes and the obsession with Western culture.',
        'price': 700.00,
        'coverImage': '',
        'category': 'Sinhala Classic',
        'rating': 4.6,
      },
      {
        'title': 'Hath Pana',
        'author': 'Kumaratunga Munidasa',
        'description': 'A collection of essays and writings by the renowned Sinhala language reformer and literary giant.',
        'price': 600.00,
        'coverImage': '',
        'category': 'Sinhala Essays',
        'rating': 4.7,
      },
      {
        'title': 'The Village in the Jungle',
        'author': 'Leonard Woolf',
        'description': 'A powerful English novel about village life in colonial Ceylon, depicting the harsh realities of rural existence.',
        'price': 950.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.6,
      },
      {
        'title': 'Gratiaen Prize Stories',
        'author': 'Various Authors',
        'description': 'A collection of award-winning short stories by Sri Lankan writers in English.',
        'price': 1200.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.5,
      },
      {
        'title': 'Cinnamon Gardens',
        'author': 'Shyam Selvadurai',
        'description': 'A novel set in 1920s Colombo, exploring themes of gender, sexuality, and colonial society.',
        'price': 1100.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.6,
      },
      {
        'title': 'Anil\'s Ghost',
        'author': 'Michael Ondaatje',
        'description': 'A compelling novel about a forensic anthropologist returning to Sri Lanka during the civil war.',
        'price': 1250.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.7,
      },
      {
        'title': 'The Road from Elephant Pass',
        'author': 'Nihal de Silva',
        'description': 'A gripping war novel set during the Sri Lankan civil conflict, exploring humanity in times of violence.',
        'price': 1050.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.6,
      },
      {
        'title': 'Funny Boy',
        'author': 'Shyam Selvadurai',
        'description': 'A coming-of-age story set in 1970s-80s Sri Lanka, exploring identity and cultural tensions.',
        'price': 1150.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.7,
      },
      {
        'title': 'Island of a Thousand Mirrors',
        'author': 'Nayomi Munaweera',
        'description': 'An epic novel spanning generations, chronicling the Sri Lankan civil war through two families.',
        'price': 1300.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.8,
      },
      {
        'title': 'Reef',
        'author': 'Romesh Gunesekera',
        'description': 'A beautifully crafted novel about a chef and his employer set against Sri Lanka\'s political turmoil.',
        'price': 1100.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.5,
      },
      {
        'title': 'Chinaman',
        'author': 'Shehan Karunatilaka',
        'description': 'A humorous and poignant novel about cricket, searching for a legendary bowler in war-torn Sri Lanka.',
        'price': 1400.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.8,
      },
      {
        'title': 'The Seven Moons of Maali Almeida',
        'author': 'Shehan Karunatilaka',
        'description': 'Booker Prize winning novel - a darkly comic supernatural thriller set in 1990s Sri Lanka.',
        'price': 1500.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.9,
      },
      {
        'title': 'Running in the Family',
        'author': 'Michael Ondaatje',
        'description': 'A magical and poetic memoir exploring the author\'s Sri Lankan heritage and family history.',
        'price': 1200.00,
        'coverImage': '',
        'category': 'Memoir',
        'rating': 4.7,
      },
      {
        'title': 'Mosquito',
        'author': 'Roma Tearne',
        'description': 'A haunting love story set during the early years of Sri Lanka\'s civil war.',
        'price': 1050.00,
        'coverImage': '',
        'category': 'Sri Lankan Fiction',
        'rating': 4.5,
      },
    ];

    try {
      final existingBooks = await _firestore.collection('books').get();
      if (existingBooks.docs.isEmpty) {
        for (var book in books) {
          await _firestore.collection('books').add(book);
        }
        print('Sample books added successfully');
      } else {
        print('Books already exist in database');
      }
    } catch (e) {
      print('Error adding sample books: $e');
    }
  }
}
