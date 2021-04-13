import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../src/users.dart';
import 'cors.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

void main(List<String> args) async {
  var app = Router();

  app.mount("/users/", GSOCUsers().router_get);
  app.mount("/users/", GSOCUsers().router_post);

  app.get('/<name|.*>', (Request, String name) {
    final index = File("public/index.html").readAsStringSync();
    return Response.ok(index, headers: {'content-type': 'text/html'});
  });

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app);

  final server = await io.serve(handler, _hostname, 8080);

  print('Serving at http://${server.address}:${server.port}');
}
