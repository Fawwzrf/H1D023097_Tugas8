import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    List<Produk> produks = [];
    for (int i = 0; i < listProduk.length; i++) {
      produks.add(Produk.fromJson(listProduk[i]));
    }
    return produks;
  }

  static Future addProduk({Produk? produk}) async {
    String apiUrl = ApiUrl.createProduk;
    var body = {
      "kode_produk": produk!.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.updateProduk(int.parse(produk.id!));
    print(apiUrl);
    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteProduk({int? id}) async {
    String apiUrl = ApiUrl.deleteProduk(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    // Debug print untuk melihat response
    print("Delete Response: $jsonObj");

    // Cek jika response memiliki 'status' seperti method lainnya
    if (jsonObj.containsKey('status')) {
      return jsonObj['status'] == true;
    }

    // Fallback: cek 'data' field jika tidak ada 'status'
    if (jsonObj.containsKey('data')) {
      var data = jsonObj['data'];
      // Jika data adalah boolean, return langsung
      if (data is bool) return data;
      // Jika data adalah string, cek jika isinya "true" atau tidak null
      if (data is String) return data.toLowerCase() == 'true';
      // Jika data adalah objek lain, anggap sukses jika tidak null
      return data != null;
    }

    // Default fallback: anggap berhasil jika tidak ada error yang di-throw
    return true;
  }
}
