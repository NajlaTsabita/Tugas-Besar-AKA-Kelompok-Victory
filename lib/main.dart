import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 
import 'logic_algoritma.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rod Cutting Optimizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 125, 15, 193)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Rod Cutting Optimizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _inputController = TextEditingController();

  String _hasilIteratif = "-";
  String _waktuIteratif = "-";
  String _hasilRekursif = "-";
  String _waktuRekursif = "-";
  String _detailPotongan = "-";
  
  bool _sedangMenghitung = false;

  void hitungWaktu() async {
    if (_inputController.text.isEmpty) return;
    int n = int.tryParse(_inputController.text) ?? 0;
    
    if (n <= 0 || n > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan panjang 1 - 50 meter"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _sedangMenghitung = true; 
      _hasilIteratif = "..."; _waktuIteratif = "...";
      _hasilRekursif = "..."; _waktuRekursif = "...";
      _detailPotongan = "...";
    });

    String strategiLengkap = getFormattedStrategy(n);

    final stopwatch1 = Stopwatch()..start();
    int hasilIter = hargaMaxIteratif(n); 
    stopwatch1.stop();

    final stopwatch2 = Stopwatch()..start();

    int hasilRekur = await compute(startRekursif, {
      'n': n,
      'i': 1 
    });
    
    stopwatch2.stop();

    setState(() {
      _sedangMenghitung = false;
      _hasilIteratif = "Rp $hasilIter";
      _waktuIteratif = "${stopwatch1.elapsedMicroseconds} µs"; 
      _hasilRekursif = "Rp $hasilRekur";
      _waktuRekursif = "${stopwatch2.elapsedMicroseconds} µs";
      _detailPotongan = strategiLengkap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color.fromARGB(255, 109, 165, 193), borderRadius: BorderRadius.circular(10)),
              child: const Text("Aplikasi Optimasi Pemotongan Batang", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),
            const Text("Panjang Batang (n):", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "masukkan panjang batang", suffixText: "meter"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _sedangMenghitung ? null : hitungWaktu,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.indigo, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: _sedangMenghitung 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.play_arrow),
              label: Text(_sedangMenghitung ? "SEDANG MENGHITUNG..." : "MULAI KOMPUTASI"),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            _buildResultCard(title: "Metode Iteratif", result: _hasilIteratif, time: _waktuIteratif, strategy: _detailPotongan, color: Colors.green, icon: Icons.flash_on),
            const SizedBox(height: 15),
            _buildResultCard(title: "Metode Rekursif", result: _hasilRekursif, time: _waktuRekursif, strategy: _detailPotongan, color: Colors.orange, icon: Icons.loop),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({required String title, required String result, required String time, required String strategy, required Color color, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(side: BorderSide(color: color, width: 2), borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(children: [Icon(icon, color: color), const SizedBox(width: 10), Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)))]),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Profit Maksimal:"), Text(result, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Waktu Eksekusi:"), Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))]),
            const SizedBox(height: 12),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Strategi Potongan:", style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(strategy, style: TextStyle(fontWeight: FontWeight.w600, color: color.withOpacity(0.8))),
              ]),
            )
          ],
        ),
      ),
    );
  }
}