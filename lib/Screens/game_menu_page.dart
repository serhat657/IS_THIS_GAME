import 'package:flutter/material.dart';
import 'package:isthisgame/Screens/score_page.dart';
import 'package:isthisgame/Screens/is_this_game.dart';
import 'package:isthisgame/Screens/login_page.dart'; // Giriş sayfasını içe aktarın

class GameMenuPage extends StatelessWidget {
  const GameMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 159, 199), // AppBar arka plan rengi
        elevation: 0, // AppBar gölge miktarı
        centerTitle: true, // Başlık merkezde mi?
        title: const Text(
          'Guess The Country ',
           style: TextStyle(color: Colors.white), // Text rengi beyaz
          ),

      ),
      backgroundColor: const Color.fromARGB(255, 124, 224, 244),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Resim widget'ı ile padding
            Padding(
              padding: const EdgeInsets.all(16.0), // Burada padding miktarını ayarlayabilirsiniz 
              child: Image.network(
                'https://l24.im/gDlQm', // Resminizin URL'si
                height: 225, // Resmin yüksekliği
                width: 480, // Resmin genişliği
                fit: BoxFit.cover, // Resmin nasıl sığacağını belirler
              ),
            ),
            const SizedBox(height: 20), // Resim ile butonlar arasında boşluk
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                foregroundColor: Colors.white, // Buton üzerindeki yazı rengi
                backgroundColor: Colors.blue, // Butonun arka plan rengi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32), // Butonun kenar yuvarlama miktarı
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IsThisGame()),
                );
              },
              icon: Icon(Icons.play_arrow), // Oyun başlatma simgesi
              label: Text('Start New Game'),
            ),
            SizedBox(height: 20), // Butonlar arasına boşluk ekleyin
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                foregroundColor: Colors.white, // Buton üzerindeki yazı rengi
                backgroundColor: Colors.blue, // Butonun arka plan rengi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32), // Butonun kenar yuvarlama miktarı
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScorePage()),
                );
              },
              icon: const Icon(Icons.score), // Skor sayfası simgesi
              label: Text('Scores'),
            ),
            SizedBox(height: 20), // Butonlar arasına boşluk ekleyin
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                foregroundColor: Colors.white, // Buton üzerindeki yazı rengi
                backgroundColor: Colors.blue, // Butonun arka plan rengi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32), // Butonun kenar yuvarlama miktarı
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Giriş sayfasına yönlendirin
                );
              },
              icon: Icon(Icons.exit_to_app), // Çıkış simgesi
              label: Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
