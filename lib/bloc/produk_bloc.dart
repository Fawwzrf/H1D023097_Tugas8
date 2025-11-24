import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static const String baseUrl = "https://contoh-api.com/api/produk";

  // Get All Produk
  static Future<List<Produk>> getProduks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List list = json.decode(response.body);
      return list.map((e) => Produk.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  // Create Produk
  static Future<bool> addProduk(Produk produk) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        "kode_produk": produk.kodeProduk,
        "nama_produk": produk.namaProduk,
        "harga": produk.hargaProduk.toString(),
      },
    );

    return response.statusCode == 200;
  }

  // Update Produk
  static Future<bool> updateProduk(Produk produk) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${produk.id}"),
      body: {
        "kode_produk": produk.kodeProduk,
        "nama_produk": produk.namaProduk,
        "harga": produk.hargaProduk.toString(),
      },
    );

    return response.statusCode == 200;
  }

  // Delete Produk
  static Future<bool> deleteProduk({required int id}) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    return response.statusCode == 200;
  }
}
