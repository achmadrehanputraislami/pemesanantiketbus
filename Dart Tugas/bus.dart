import 'dart:io';

class Penumpang {
  String nama;
  String tujuan;
  int id;

  Penumpang(this.nama, this.tujuan, this.id);

  String toString() {
    return 'ID: $id, Nama: $nama, Tujuan: $tujuan';
  }
}

class CustomQueue<T> {
  List<T> _list = [];

  void enqueue(T element) {
    _list.add(element);
  }

  T? dequeue() {
    if (_list.isEmpty) return null;
    return _list.removeAt(0);
  }

  bool remove(T element) {
    return _list.remove(element);
  }

  bool get isEmpty => _list.isEmpty;

  List<T> get elements => List.unmodifiable(_list);
}

class Bus {
  String jurusan;
  int kapasitas;
  int tersedia;
  CustomQueue<Penumpang> penumpangQueue = CustomQueue<Penumpang>();

  Bus(this.jurusan, this.kapasitas) : tersedia = kapasitas;

  @override
  String toString() {
    return 'Jurusan: $jurusan, Kapasitas: $kapasitas, Tersedia: $tersedia';
  }
}

class SistemPemesanan {
  List<Bus> jadwalBus = [];
  int idCounter = 1;

  SistemPemesanan() {
    tambahBus('Jakarta - Bandung', 40);
    tambahBus('Bandung - Surabaya', 35);
    tambahBus('Surabaya - Banyuwangi', 30);
  }

  //5
  void tambahBus(String jurusan, int kapasitas) {
    jadwalBus.add(Bus(jurusan, kapasitas));
  }

  //1
  void lihatJadwalBus() {
    if (jadwalBus.isEmpty) {
      print('Tidak ada jadwal bus yang tersedia.');
      return;
    }
    for (var bus in jadwalBus) {
      print(bus);
    }
  }

  //2
  void pesanTiket(String nama, String tujuan) {
    var bus = jadwalBus.firstWhere(
        (b) => b.jurusan.toLowerCase() == tujuan.toLowerCase(),
        orElse: () => Bus('', 0));
    if (bus.jurusan.isEmpty) {
      print('Jurusan tidak ditemukan.');
      return;
    }
    if (bus.tersedia > 0) {
      var penumpang = Penumpang(nama, tujuan, idCounter++);
      bus.penumpangQueue.enqueue(penumpang);
      bus.tersedia--;
      print(
          'Tiket berhasil dipesan! ID pemesanan Anda adalah ${penumpang.id}.');
    } else {
      print('Kapasitas bus penuh.');
    }
  }

  //3
  void batalkanTiket(int id) {
    bool found = false;
    for (var bus in jadwalBus) {
      for (var penumpang in bus.penumpangQueue.elements) {
        if (penumpang.id == id) {
          bus.penumpangQueue.remove(penumpang);
          bus.tersedia++;
          print('Tiket berhasil dibatalkan.');
          found = true;
          break;
        }
      }
      if (found) break;
    }
    if (!found) {
      print('ID pemesanan tidak ditemukan.');
    }
  }

  //4
  void lihatDaftarPenumpang() {
    bool anyPenumpang = false;
    for (var bus in jadwalBus) {
      if (bus.penumpangQueue.isEmpty) continue;

      anyPenumpang = true;
      print('Penumpang di bus ${bus.jurusan}:');
      for (var penumpang in bus.penumpangQueue.elements) {
        print(penumpang);
      }
    }
    if (!anyPenumpang) {
      print('Tidak ada penumpang yang terdaftar.');
    }
  }
}

void main() {
  var sistem = SistemPemesanan();
  while (true) {
    print('\nMenu Utama:');
    print('1. Lihat Jadwal Bus');
    print('2. Pesan Tiket');
    print('3. Batalkan Tiket');
    print('4. Lihat Daftar Penumpang');
    print('5. Tambah Bus Baru');
    print('6. Keluar');
    stdout.write('Pilih menu: ');
    var pilihan = stdin.readLineSync();

    if (pilihan == '1') {
      sistem.lihatJadwalBus();
    } else if (pilihan == '2') {
      stdout.write('Masukkan Nama Penumpang: ');
      var nama = stdin.readLineSync();
      stdout.write('Masukkan Tujuan (misal: Jakarta - Bandung): ');
      var tujuan = stdin.readLineSync();
      if (nama != null && tujuan != null) {
        sistem.pesanTiket(nama, tujuan);
      } else {
        print('Input tidak valid.');
      }
    } else if (pilihan == '3') {
      stdout.write('Masukkan ID Pemesanan: ');
      var idInput = stdin.readLineSync();
      if (idInput != null && int.tryParse(idInput) != null) {
        var id = int.parse(idInput);
        sistem.batalkanTiket(id);
      } else {
        print('Input tidak valid.');
      }
    } else if (pilihan == '4') {
      sistem.lihatDaftarPenumpang();
    } else if (pilihan == '5') {
      stdout.write('Masukkan Jurusan Baru: ');
      var jurusan = stdin.readLineSync();
      stdout.write('Masukkan Kapasitas: ');
      var kapasitasInput = stdin.readLineSync();
      if (jurusan != null &&
          kapasitasInput != null &&
          int.tryParse(kapasitasInput) != null) {
        var kapasitas = int.parse(kapasitasInput);
        sistem.tambahBus(jurusan, kapasitas);
        print('Bus baru berhasil ditambahkan.');
      } else {
        print('Input tidak valid.');
      }
    } else if (pilihan == '6') {
      break;
    } else {
      print('Pilihan tidak valid!');
    }
  }
}
