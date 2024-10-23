import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unit_app/domain/album.dart';

class AlbumDataSource {
  final http.Client client;

  AlbumDataSource({required this.client});

  Future<Album> fetchAlbum() async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
