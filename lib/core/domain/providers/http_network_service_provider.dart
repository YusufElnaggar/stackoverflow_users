import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/remote/http_network_service.dart';

final httpNetworkServiceProvider = Provider<HttpNetworkService>(
  (ref) {
    final http.Client httpClient = http.Client();
    return HttpNetworkService(httpClient);
  },
);
