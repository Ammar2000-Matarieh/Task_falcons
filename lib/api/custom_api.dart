import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  // Get Request Data API :
  getRequest(
    String url, {
    Map<String, String>? queryParams,
  }) async {
    try {
      var uri = Uri.parse(url).replace(
        queryParameters: queryParams,
      );
      var response = await http.get(
        uri,
      );
      log(response.body.toString());
      return _handleResponse(
        response,
      );
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  Map<String, dynamic> _handleResponse(
    http.Response response,
  ) {
    log("Response Status Code: ${response.statusCode}");

    dynamic body;
    try {
      body = jsonDecode(
        response.body,
      );
    } catch (e) {
      log(
        "Error parsing response body: $e",
      );
      return {
        'status': 'error',
        'message': 'Failed to parse response body',
      };
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        if (body is Map<String, dynamic>) {
          if (body.containsKey(
                'SalesMan_Items_Balance',
              ) ||
              body.containsKey(
                'Items_Master',
              )) {
            return {
              'status': 'success',
              'SalesMan_Items_Balance': body['SalesMan_Items_Balance'] ?? [],
              'Items_Master': body['Items_Master'] ?? [],
            };
          }
        }
        return {
          'status': 'error',
          'message': 'Unexpected response format',
        };

      case 400:
        return {
          'status': 'error',
          'message': 'Bad Request: ${body['message'] ?? 'Invalid request'}',
        };

      case 401:
        return {
          'status': 'error',
          'message':
              'Unauthorized: ${body['message'] ?? 'Authentication failed'}',
        };

      case 403:
        return {
          'status': 'error',
          'message': 'Forbidden: ${body['message'] ?? 'Access denied'}',
        };

      case 404:
        return {
          'status': 'error',
          'message': 'Not Found: ${body['message'] ?? 'Resource not found'}',
        };

      case 500:
        return {
          'status': 'error',
          'message':
              'Internal Server Error: ${body['message'] ?? 'Server issue'}',
        };

      case 503:
        return {
          'status': 'error',
          'message':
              'Service Unavailable: ${body['message'] ?? 'Try again later'}',
        };

      default:
        return {
          'status': 'error',
          'message': 'Unhandled status code: ${response.statusCode}',
        };
    }
  }
}
