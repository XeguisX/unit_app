import 'package:unit_app/domain/album.dart';

class AlbumBuilder {
  int id = 0;
  String title = 'Title';

  Album build() => Album(id: id, title: title);
}
