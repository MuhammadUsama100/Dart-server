import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class GSOCUsers {
  var users = [
    {"Name": "Muhammad Usama", "Age": "20", "Dis": "CS Student"},
    {"Name": "jonas", "Age": "23", "Dis": "Teacher"}
  ];
  Router get router_get {
    final router = Router();
    router.get('/list', (Request request) {
      var data = json.encode(users);
      return Response.ok(data.toString());
    });
    return router;
  }

  Router get router_post {
    final router = Router();
    router.post('/create', (Request request) async {
      var body = await request.readAsString();
      print(body);
      var user = json.decode(body);
      users.add({"Name": user["Name"], "Age": user["Age"], "Dis": user["Dis"]});

      return Response.ok(users.toString());
    });
    return router;
  }
}
