import 'package:flutter/material.dart';
import 'package:kasir_kuliner/layouts/bottom_navigation.dart';
import 'package:kasir_kuliner/widgets/custom_drawer.dart';

class ListMenuPage extends StatefulWidget {
  const ListMenuPage({super.key});

  @override
  State<ListMenuPage> createState() => _ListMenuPageState();
}

class _ListMenuPageState extends State<ListMenuPage> {
  List<Map<String, dynamic>> daftarMenu = [
    {
      'no': 1,
      'nama': 'Etong',
      'hargaBeli': 40000,
      'hargaJual': 70000,
      'stok': 30,
      'kategori': 'makanan',
    },
    {
      'no': 2,
      'nama': 'Nasi Goreng',
      'hargaBeli': 20000,
      'hargaJual': 40000,
      'stok': 50,
      'kategori': 'makanan',
    },
    {
      'no': 3,
      'nama': 'Es Teh',
      'hargaBeli': 10000,
      'hargaJual': 15000,
      'stok': 100,
      'kategori': 'minuman',
    },
    {
      'no': 4,
      'nama': 'Kopi Susu',
      'hargaBeli': 12000,
      'hargaJual': 25000,
      'stok': 40,
      'kategori': 'kopi',
    },
    {
      'no': 5,
      'nama': 'Keripik Kentang',
      'hargaBeli': 15000,
      'hargaJual': 30000,
      'stok': 20,
      'kategori': 'snack',
    },
  ];

  // Variabel untuk fitur
  String _searchQuery = '';
  String _selectedCategory = 'semua';
  String _sortBy = 'no';
  bool _ascending = true;

  // Format Rupiah
  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Filter + Search + Sort
  List<Map<String, dynamic>> get filteredMenu {
    List<Map<String, dynamic>> result =
        daftarMenu.where((menu) {
          final namaMatch = menu['nama'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
          final kategoriMatch =
              _selectedCategory == 'semua' ||
              menu['kategori'] == _selectedCategory;
          return namaMatch && kategoriMatch;
        }).toList();

    // Sorting
    result.sort((a, b) {
      switch (_sortBy) {
        case 'nama':
          return _ascending
              ? a['nama'].toString().compareTo(b['nama'].toString())
              : b['nama'].toString().compareTo(a['nama'].toString());
        case 'hargaJual':
          return _ascending
              ? a['hargaJual'].compareTo(b['hargaJual'])
              : b['hargaJual'].compareTo(a['hargaJual']);
        case 'stok':
          return _ascending
              ? a['stok'].compareTo(b['stok'])
              : b['stok'].compareTo(a['stok']);
        default: // 'no'
          return _ascending
              ? a['no'].compareTo(b['no'])
              : b['no'].compareTo(a['no']);
      }
    });

    return result;
  }

  // Dialog Edit (sama seperti sebelumnya)
  void _showEditDialog(BuildContext context, int index) {
    final menu = filteredMenu[index];
    TextEditingController namaController = TextEditingController(
      text: menu['nama'],
    );
    TextEditingController hargaBeliController = TextEditingController(
      text: menu['hargaBeli'].toString(),
    );
    TextEditingController hargaJualController = TextEditingController(
      text: menu['hargaJual'].toString(),
    );
    TextEditingController stokController = TextEditingController(
      text: menu['stok'].toString(),
    );
    String? selectedKategori = menu['kategori'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Menu"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: "Nama Menu"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedKategori,
                    items:
                        ['makanan', 'minuman', 'snack', 'kopi']
                            .map(
                              (kategori) => DropdownMenuItem(
                                value: kategori,
                                child: Text(kategori.toUpperCase()),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => selectedKategori = value,
                    decoration: const InputDecoration(labelText: "Kategori"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hargaBeliController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Harga Beli"),
                  ),
                  TextField(
                    controller: hargaJualController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Harga Jual"),
                  ),
                  TextField(
                    controller: stokController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Stok"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    daftarMenu[daftarMenu.indexWhere(
                      (m) => m['no'] == menu['no'],
                    )] = {
                      ...menu,
                      'nama': namaController.text,
                      'kategori': selectedKategori!,
                      'hargaBeli': int.tryParse(hargaBeliController.text) ?? 0,
                      'hargaJual': int.tryParse(hargaJualController.text) ?? 0,
                      'stok': int.tryParse(stokController.text) ?? 0,
                    };
                    _reindexMenu();
                  });
                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
    );
  }

  void _hapusMenu(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Menu?"),
            content: const Text("Yakin mau hapus menu ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    daftarMenu.removeWhere(
                      (m) => m['no'] == filteredMenu[index]['no'],
                    );
                    _reindexMenu();
                  });
                  Navigator.pop(context);
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _reindexMenu(); // Jalankan sekali di awal
  }

  void _reindexMenu() {
    for (int i = 0; i < daftarMenu.length; i++) {
      daftarMenu[i]['no'] = i + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Menu + Kategori"),
        backgroundColor: Colors.blue,
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 2),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari menu...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // Filter & Sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Dropdown Kategori
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    items:
                        ['semua', 'makanan', 'minuman', 'snack', 'kopi']
                            .map(
                              (kategori) => DropdownMenuItem(
                                value: kategori,
                                child: Text(kategori.toUpperCase()),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => _selectedCategory = value!),
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Dropdown Sort
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _sortBy,
                    items:
                        ['no', 'nama', 'hargaJual', 'stok']
                            .map(
                              (sort) => DropdownMenuItem(
                                value: sort,
                                child: Text("Sort by ${sort.toUpperCase()}"),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => _sortBy = value!),
                    decoration: const InputDecoration(
                      labelText: "Urutkan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Icon Button
                SizedBox(
                  width: 48, // atau 40 kalau mau lebih ramping
                  height: 48,
                  child: IconButton(
                    icon: Icon(
                      _ascending ? Icons.arrow_upward : Icons.arrow_downward,
                    ),
                    onPressed: () => setState(() => _ascending = !_ascending),
                  ),
                ),
              ],
            ),
          ),
          // List Menu
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMenu.length,
              itemBuilder: (context, index) {
                final menu = filteredMenu[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${menu['no']}. ${menu['nama']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              label: Text(
                                menu['kategori'].toString().toUpperCase(),
                              ),
                              backgroundColor: Colors.blue[100],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Beli: ${formatRupiah(menu['hargaBeli'])}",
                                ),
                                Text(
                                  "Jual: ${formatRupiah(menu['hargaJual'])}",
                                ),
                              ],
                            ),
                            Text(
                              "Stok: ${menu['stok']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                  onPressed:
                                      () => _showEditDialog(context, index),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _hapusMenu(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
