import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High Scores'),
        backgroundColor: Color.fromARGB(255, 17, 159, 199), // AppBar arka plan rengi
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getHighScores(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No scores available.'));
          } else {
            final scores = snapshot.data!;
            return ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Icon(Icons.account_circle, color: Color.fromARGB(255, 126, 175, 166)),
                    title: Text(
                      score['username'] ?? 'Unknown',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      'Score: ${score['highScore'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getHighScores() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('highScore', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'username': data['username'],
          'highScore': data['highScore'],
        };
      }).toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to load high scores');
    }
  }
}
