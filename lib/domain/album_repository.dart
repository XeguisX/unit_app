import 'package:unit_app/data/album_data_source.dart';

import 'album.dart';

class AlbumRepository {
  final AlbumDataSource dataSource;

  AlbumRepository({required this.dataSource});

  Future<Album> getAlbum() async {
    return await dataSource.fetchAlbum();
  }
}
