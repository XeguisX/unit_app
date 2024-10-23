import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:unit_app/data/album_data_source.dart';
import 'package:unit_app/domain/album.dart';
import 'package:unit_app/domain/album_repository.dart';

import 'album_builder.dart';
import 'fetch_album_test.mocks.dart';

// En las pruebas unitarias, es crucial simular las dependencias externas como APIs
// o servicios de datos. Utilizamos mocks para reemplazar esas dependencias y
// controlar su comportamiento durante las pruebas. Esto nos permite:
// 1. Asegurarnos de que las pruebas sean confiables y no dependan de servicios
//    externos que pueden fallar o ser lentos.
// 2. Simular distintas respuestas de la API (éxito, errores, etc.) y garantizar
//    que nuestro código maneja correctamente cada escenario.
// 3. Aislar la lógica de nuestro código, enfocándonos en probarlo de manera pura,
//    sin la influencia de otros sistemas externos.
// En este caso, estamos simulando tanto el 'http.Client' como el 'AlbumDataSource'
// para probar diferentes respuestas de la API sin hacer solicitudes reales.

@GenerateMocks([http.Client, AlbumDataSource])
//Es necesario ejecutar dart 'run build_runner build' para generar los mocks
// La anotación @GenerateMocks se utiliza para generar clases mock que simulan
// el comportamiento de las dependencias listadas, en este caso, 'http.Client' y
// 'AlbumDataSource'. Estos mocks nos permiten simular respuestas y errores
// durante las pruebas unitarias sin realizar llamadas reales a la API o interactuar
// con fuentes de datos externas. Esto asegura que las pruebas sean rápidas,
// predecibles y estén aisladas del comportamiento externo.

void main() {
  //Tests para  el AlbumDatasource
  group('AlbumDataSource', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();
      final dataSource = AlbumDataSource(client: client);

      // Usar Mockito para devolver una respuesta exitosa
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"id": 1, "title": "Test Album"}', 200));

      final album = await dataSource.fetchAlbum();

      expect(album, isA<Album>());
      expect(album.id, 1);
      expect(album.title, 'Test Album');
    });

    test('throws an exception if the http call fails', () async {
      final client = MockClient();
      final dataSource = AlbumDataSource(client: client);

      // Usar Mockito para devolver una respuesta fallida
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(dataSource.fetchAlbum(), throwsException);
    });
  });

  //Tests para  el AlbumRepository

  group('AlbumRepository', () {
    test('returns an Album from the dataSource', () async {
      final dataSource = MockAlbumDataSource();
      final repository = AlbumRepository(dataSource: dataSource);

      // Usar Mockito para devolver un Album desde el DataSource
      when(dataSource.fetchAlbum()).thenAnswer(
        (_) async =>
            //Damos a uso a nuestro AlbumBuilder
            AlbumBuilder().build(),
      );

      final album = await repository.getAlbum();

      expect(album, isA<Album>());
      expect(album.id, 1);
      expect(album.title, 'Test Album');
    });

    test('throws an exception if the dataSource fails', () async {
      final dataSource = MockAlbumDataSource();
      final repository = AlbumRepository(dataSource: dataSource);

      // Usar Mockito para simular un fallo en el DataSource
      when(dataSource.fetchAlbum())
          .thenThrow(Exception('Failed to load album'));

      expect(repository.getAlbum(), throwsException);
    });
  });
}
