import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isthisgame/Providers/country_flags_provider.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IsThisGame extends ConsumerStatefulWidget {
  @override
  _IsThisGameState createState() => _IsThisGameState();
}

class _IsThisGameState extends ConsumerState<IsThisGame> {
  int currentIndex = 0;
  int score = 0;
  int wrongAttempts = 0;
  List<Map<String, String>> countryData = [];
  List<String> options = [];

  @override
  Widget build(BuildContext context) {
    final countryFlagsAndNamesAsyncValue = ref.watch(countryFlagsAndNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Is This Game?'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red), // Hata ikonu
                SizedBox(width: 4),
                Text(
                  '$wrongAttempts/5',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
      body: countryFlagsAndNamesAsyncValue.when(
        data: (data) {
          countryData = data;
          generateQuestion();
          return buildGameUI();
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void generateQuestion() {
    if (currentIndex >= countryData.length || wrongAttempts >= 5) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Oyun bitimi işlemlerini build tamamlandıktan sonra yap
        await updateHighScore(score); // Skoru güncelle

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Game Over'),
            content: Text('Your score: $score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('Back to Menu'),
              ),
            ],
          ),
        );
      });
      return;
    }

    options.clear();
    options.add(countryData[currentIndex]['name']!);

    // Random 2 additional options
    Random random = Random();
    while (options.length < 3) {
      String option = countryData[random.nextInt(countryData.length)]['name']!;
      if (!options.contains(option)) {
        options.add(option);
      }
    }

    options.shuffle();
  }

  Future<void> updateHighScore(int newScore) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final userSnapshot = await transaction.get(userDoc);

          if (userSnapshot.exists) {
            final data = userSnapshot.data() as Map<String, dynamic>;
            final currentHighScore = data['highScore'] ?? 0;

            if (newScore > currentHighScore) {
              transaction.update(userDoc, {'highScore': newScore});
            }
          } else {
            transaction.set(userDoc, {'highScore': newScore});
          }
        });
      } catch (e) {
        print(e);
        throw Exception('Failed to update high score');
      }
    }
  }

  void showIncorrectAnswerDialog(String correctAnswer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Incorrect'),
        content: Text('No, this is $correctAnswer.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Uyarıyı kapat
              setState(() {
                wrongAttempts++;
                if (wrongAttempts >= 5) {
                  // Oyun bitiminde sadece oyun bitişi işlemini çağır
                  generateQuestion();
                } else {
                  // Bir sonraki bayrağa geç
                  currentIndex++;
                  generateQuestion();
                }
              });
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildGameUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Genel padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.network(
              countryData[currentIndex]['flag']!,
              height: 150, // Resim yüksekliğini ayarlayın
              width: 300, // Resim genişliğini ayarlayın
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Which country\'s flag is this?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // Butonları aynı satırda göster
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: options.map((option) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (option == countryData[currentIndex]['name']) {
                        setState(() {
                          score++;
                          currentIndex++;
                          generateQuestion();
                        });
                      } else {
                        showIncorrectAnswerDialog(countryData[currentIndex]['name']!);
                      }
                    },
                    child: Text(option),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Text(
            'Score: $score',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
