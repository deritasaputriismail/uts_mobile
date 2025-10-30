import 'dart:math';

abstract class Transportasi {
  String id;
  String nama;
  double _tarifDasar;
  int kapasitas;

  Transportasi(this.id, this.nama, this._tarifDasar, this.kapasitas);
  double get tarifDasar => _tarifDasar;
  double hitungTarif(int jumlahPenumpang);
  void tampilInfo() {
    print('ID Transportasi: $id');
    print('Nama: $nama');
    print('Tarif Dasar: Rp${_tarifDasar.toStringAsFixed(0)}');
    print('Kapasitas: $kapasitas penumpang');
  }
}

class Taksi extends Transportasi {
  double jarak;
  Taksi(String id, String nama, double tarifDasar, int kapasitas, this.jarak)
      : super(id, nama, tarifDasar, kapasitas);
  @override
  double hitungTarif(int jumlahPenumpang) {
    if (jumlahPenumpang > kapasitas) {
      print(
          'Maaf, jumlah penumpang melebihi kapasitas taksi ini ($kapasitas).');
      return 0.0;
    }
    return tarifDasar * jarak;
  }

  @override
  void tampilInfo() {
    super.tampilInfo();
    print('Jarak Perjalanan: ${jarak.toStringAsFixed(1)} km');
  }
}

class Bus extends Transportasi {
  bool adaWifi;
  Bus(String id, String nama, double tarifDasar, int kapasitas, this.adaWifi)
      : super(id, nama, tarifDasar, kapasitas);

  @override
  double hitungTarif(int jumlahPenumpang) {
    if (jumlahPenumpang > kapasitas) {
      print('Maaf, jumlah penumpang melebihi kapasitas bus ini (Kapasitas).');
      return 0.0;
    }
    double total = tarifDasar * jumlahPenumpang;
    if (adaWifi) {
      total += 5000;
    }
    return total;
  }

  @override
  void tampilInfo() {
    super.tampilInfo();
    print('Fasilitas Wi-fi: ${adaWifi ? 'Tersedia' : 'Tidak Tersedia'}');
  }
}

class Pesawat extends Transportasi {
  String kelas;
  Pesawat(String id, String nama, double tarifDasar, int kapasitas, this.kelas)
      : super(id, nama, tarifDasar, kapasitas);
  @override
  double hitungTarif(int jumlahPenumpang) {
    if (jumlahPenumpang > kapasitas) {
      print(
          'Maaf, jumlah penumpang melebihi kapasitas pesawat ini ($kapasitas).');
      return 0.0;
    }
    double total = tarifDasar * jumlahPenumpang;
    if (kelas == "Bisnis") {
      total *= 1.5;
    }
    return total;
  }

  @override
  void tampilInfo() {
    super.tampilInfo();
    print('kelas penerbangan: $kelas');
  }
}

class Pemesanan {
  String idPemesanan;
  String namaPelanggan;
  Transportasi transportasi;
  int jumlahPenumpang;
  double totalTarif;

  Pemesanan(this.idPemesanan, this.namaPelanggan, this.transportasi,
      this.jumlahPenumpang, this.totalTarif);
  void cetakStruk() {
    print('\n====TRUK PEMESANAN SMART RIDE ====');
    print('ID pemesanan: $idPemesanan');
    print('Nama Pelanggan: $namaPelanggan');
    print('--------');
    transportasi.tampilInfo();
    print('Jumlah Penumpang: $jumlahPenumpang');
    print('Total Tarif: Rp${totalTarif.toStringAsFixed(0)}');
  }

  Map<String, dynamic> toMap() {
    return {
      'idPemesanan': idPemesanan,
      'namaPelanggan': namaPelanggan,
      'namaTransportasi': transportasi.id,
      'jumlahPenumpang': jumlahPenumpang,
      'totalTarif': totalTarif,
    };
  }
}

Pemesanan buatPemesanan(
    Transportasi t, String namaPelanggan, int jumlahPenumpang) {
  double tarif = t.hitungTarif(jumlahPenumpang);
  if (tarif == 0.0 && jumlahPenumpang > t.kapasitas) {
    print('Pemesanan dibatalkan karena melebihi kapasitas. ');
    return Pemesanan('GAGAL', namaPelanggan, t, jumlahPenumpang, 0.0);
  }
  String idPemesanan =
      'SR' + Random().nextInt(100000).toString().padLeft(5, '0');
  return Pemesanan(idPemesanan, namaPelanggan, t, jumlahPenumpang, tarif);
}

void tampilSemuaPemesanan(List<Pemesanan> daftarPemesanan) {
  print('\n====== RIWAYAT SEMUA PEMESANAN ======');
  if (daftarPemesanan.isEmpty) {
    print('Belum ada pemesanan yang tercatat. ');
    return;
  }
  for (var pemesanan in daftarPemesanan) {
    pemesanan.cetakStruk();
  }
  print('==========\n');
}

void main() {
  print('---Inisialisasi transportasi ---');
  Taksi taksi1 = Taksi('TX001', 'Taksi Online A', 7000, 4, 15.5);
  Bus bus1 = Bus('BS001', 'Bus TransJ B', 35000, 60, true);
  Pesawat pesawat1 =
      Pesawat('PW001', 'garuda Indonesia C', 500000, 150, 'Ekonomi');
  Pesawat pesawat2 = Pesawat('PW002', 'Lion Air D', 750000, 100, 'Bisnis');

  taksi1.tampilInfo();
  bus1.tampilInfo();
  pesawat1.tampilInfo();
  pesawat2.tampilInfo();
  print('---------------------------------------');

  List<Pemesanan> daftarPemesananPelanggan = [];
  print('\n--- Proses Pemesanan ---');
  Pemesanan p1 = buatPemesanan(taksi1, 'Putri', 2);
  if (p1.totalTarif > 0) daftarPemesananPelanggan.add(p1);
  Pemesanan p2 = buatPemesanan(bus1, 'fajar', 10);
  if (p2.totalTarif > 0) daftarPemesananPelanggan.add(p2);
  Pemesanan p3 = buatPemesanan(pesawat1, 'Ikal', 1);
  if (p3.totalTarif > 0) daftarPemesananPelanggan.add(p3);
  Pemesanan p4 = buatPemesanan(pesawat2, 'Aura', 2);
  if (p4.totalTarif > 0) daftarPemesananPelanggan.add(p4);
  Pemesanan p5 = buatPemesanan(taksi1, 'Tia', 5);
  if (p5.totalTarif > 0) daftarPemesananPelanggan.add(p5);

  tampilSemuaPemesanan(daftarPemesananPelanggan);
  if (daftarPemesananPelanggan.isNotEmpty) {
    print('---Contoh Data pemesanan dalam Format Map (imulasi DB) ---');
    print(daftarPemesananPelanggan[0].toMap());
  }
}