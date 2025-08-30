import 'dart:io';
import 'dart:convert';

void main() async {
  // Implement an [HttpServer] reading and writing to `dummy.txt` file.

  final file = File('dummy.txt');

  // Create file if it doesn't exist
  if (!await file.exists()) {
    await file.writeAsString('Hello, World!\n');
  }

  final server = await HttpServer.bind('localhost', 8080);
  print('Server listening on localhost:8080');
  print('GET / - Read from dummy.txt');
  print('POST / - Write to dummy.txt (send text in request body)');

  await for (HttpRequest request in server) {
    try {
      switch (request.method) {
        case 'GET':
          await handleGet(request, file);
          break;
        case 'POST':
          await handlePost(request, file);
          break;
        default:
          request.response.statusCode = HttpStatus.methodNotAllowed;
          request.response.write('Method not allowed');
          await request.response.close();
      }
    } catch (e) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('Internal server error: $e');
      await request.response.close();
    }
  }
}

Future<void> handleGet(HttpRequest request, File file) async {
  try {
    final content = await file.readAsString();
    request.response.headers.contentType = ContentType.text;
    request.response.write(content);
    await request.response.close();
  } catch (e) {
    request.response.statusCode = HttpStatus.internalServerError;
    request.response.write('Error reading file: $e');
    await request.response.close();
  }
}

Future<void> handlePost(HttpRequest request, File file) async {
  try {
    final content = await utf8.decoder.bind(request).join();
    await file.writeAsString(content);
    request.response.statusCode = HttpStatus.ok;
    request.response.write('Content written to dummy.txt');
    await request.response.close();
  } catch (e) {
    request.response.statusCode = HttpStatus.internalServerError;
    request.response.write('Error writing file: $e');
    await request.response.close();
  }
}
