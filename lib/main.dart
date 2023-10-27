import 'dart:convert';

import 'package:vercel_edge/vercel_edge.dart';
import 'package:vercel_edge_example/fetch.dart';

void main() async {
  const apiEndpoint = 'https://63f7ba5c833c7c9c608a51a6.mockapi.io/api';

  // CloudflareWorkers(fetch: (request, env, ctx) async {
  VercelEdge(fetch: (request) async {
    if (request.url.toString().contains('favicon.ico')) {
      return Response(null);
    }

    if (request.url.toString().endsWith('/todos')) {
      final response = await Http.get('$apiEndpoint/todos', []);
      return Response.json(jsonDecode(response), status: 200);
    }

    if (request.url.toString().contains(RegExp('^(?!/?todos).+\$'))) {
      final todoId = (request.url.toString().split('/')).last;

      final response = await Http.get('$apiEndpoint/todos/$todoId', []);
      return Response.json(jsonDecode(response));
    }

    return Response.json({'status': 'running...'}, status: 200);
  });
}
