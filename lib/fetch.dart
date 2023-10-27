import 'package:js/js.dart';
import 'package:edge_runtime/edge_runtime.dart' as runtime;
import 'package:js/js_util.dart';

typedef Promise = Object;

@JS("fetch")
external Promise fetch(String url, List<Map<String, dynamic>>? options);

@JS("Promise.resolve")
external runtime.Response resolve(Promise promise);

@JS("console.log")
external void log(Object msg);

@JS("JSON.stringify")
external String stringify(Object json);

class Http {
  static Future<String> get(String url, List<Map<String, dynamic>>? options) async {
    final promise = fetch(url, []);

    final response = resolve(promise);
    final then = callMethod(response, 'then', []);
    final result = await promiseToFuture(then);
    final json = await promiseToFuture(callMethod(result, 'json', []));

    return Future.value(stringify(json));
  }
}
