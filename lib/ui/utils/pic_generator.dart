// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// // import 'package:boring_avatars/boring_avatars.dart';

// var DEFAULT_COLORS = [
//   "#92A1C6",
//   "#146A7C",
//   "#F0AB3D",
//   "#C271B4",
//   "#C20D90",
// ].join(",");
// const DEFAULT_SIZE = 80;
// const DEFAULT_VARIANT = "marble";

// const VALID_VARIANTS = {
//   "marble",
//   "beam",
//   "pixel",
//   "sunset",
//   "ring",
//   "bauhaus",
// };

// List<String> normalizeColors(String colors) {
//   final colorPalette = colors.split(",");
//   return colorPalette.map((color) => color.startsWith("#") ? color : "#$color").toList();
// }

// void main() {
//   final app = HttpServer();

//   app.listen(InternetAddress.anyIPv4, 3000, (server) {
//     print('Server running on ${server.address}:${server.port}');
//   });

//   app.listen((HttpRequest request) {
//     if (request.uri.path == '/favicon.ico') {
//       request.response.statusCode = 204;
//       request.response.close();
//       return;
//     }

//     final variant = request.uri.pathSegments.length > 0 ? request.uri.pathSegments[0] : DEFAULT_VARIANT;
//     final size = request.uri.pathSegments.length > 1 ? int.tryParse(request.uri.pathSegments[1]) : DEFAULT_SIZE;
//     final explicitName = request.uri.pathSegments.length > 2 ? request.uri.pathSegments[2] : null;
//     final name = explicitName ?? Random().nextDouble().toString();
//     final colors = normalizeColors(request.uri.queryParameters['colors'] ?? DEFAULT_COLORS);
//     final square = request.uri.queryParameters.containsKey('square');

//     if (!VALID_VARIANTS.contains(variant)) {
//       request.response.statusCode = 400;
//       request.response.write('Invalid variant');
//       request.response.close();
//       return;
//     }

//     request.response.headers.contentType = ContentType('image', 'svg+xml');

//     if (explicitName != null) {
//       request.response.headers.set('Cache-Control', 'max-age=0, s-maxage=2592000');
//     } else {
//       request.response.headers.set('Cache-Control', 'max-age=0, s-maxage=1');
//     }

//     final svg = renderToString(
//       Avatar(
//         size: size.toDouble(),
//         name: name,
//         variant: variant,
//         colors: colors,
//         square: square,
//       ),
//     );

//     request.response.write(svg);
//     request.response.close();
//   });
// }
