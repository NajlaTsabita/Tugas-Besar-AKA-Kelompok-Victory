const List<int> hargaBatang = [
  0, 1000, 5000, 5500, 9000, 10000, 17000, 17500, 20000, 24000, 30000, 
  31000, 32000, 33000, 34000, 35000, 36000, 37000, 38000, 39000, 40000, 
  41000, 42000, 43000, 44000, 45000, 46000, 47000, 48000, 49000, 50000, 
  51000, 52000, 53000, 54000, 55000, 56000, 57000, 58000, 59000, 60000, 
  61000, 62000, 63000, 64000, 65000, 66000, 67000, 68000, 69000, 100000 
];

int startRekursif(Map<String, int> paket) {
  return hargaMaxRekursif(paket['n']!, paket['i']!);
}

int hargaMaxRekursif(int n, int i) {
  if (n == 0) {
    return 0;
  }

  if (i > n) {
    return -999; 
  }

  int harga1 = hargaBatang[i] + hargaMaxRekursif(n - i, 1);
  int harga2 = hargaMaxRekursif(n, i + 1);

  if (harga1 > harga2) {
    return harga1;
  } else {
    return harga2;
  }
}

int hargaMaxIteratif(int n) {
  List<int> harga = [0]; 
  for (int j = 1; j <= n; j++) {
    int hargaMax = -999;
    for (int i = 1; i <= j; i++) {
      int hargaJual = hargaBatang[i] + harga[j - i];
      if (hargaJual > hargaMax) hargaMax = hargaJual;
    }
    harga.add(hargaMax);
  }
  return harga[n];
}

List<int> getDetailPotongan(int n) {
  List<int> r = List.filled(n + 1, 0); 
  List<int> s = List.filled(n + 1, 0); 
  for (int j = 1; j <= n; j++) {
    int maxRevenue = -999;
    for (int i = 1; i <= j; i++) {
      int revenue = hargaBatang[i] + r[j - i];
      if (revenue > maxRevenue) {
        maxRevenue = revenue;
        s[j] = i; 
      }
    }
    r[j] = maxRevenue;
  }
  List<int> hasilPotongan = [];
  int sisaPanjang = n;
  while (sisaPanjang > 0) {
    int potong = s[sisaPanjang];
    if (potong == 0) break;
    hasilPotongan.add(potong);
    sisaPanjang = sisaPanjang - potong;
  }
  return hasilPotongan;
}

String getFormattedStrategy(int n) {
  List<int> potongan = getDetailPotongan(n);
  if (potongan.isEmpty) return "Tidak dipotong";
  return potongan.map((p) => "${p}m (Rp ${hargaBatang[p]})").join(" + ");
}