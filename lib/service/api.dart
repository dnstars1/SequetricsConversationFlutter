import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth.dart';

class ApiService {
  static final String baseUrl =
      dotenv.env['BACKEND_BASE_URL'] ?? 'http://localhost:8000';
  final AuthService _authService = AuthService();

  void _logRequest(String method, String url, {Map<String, String>? headers, String? body}) {
    print('\n=== REQUEST ===');
    print('$method $url');
    if (headers != null) print('Headers: $headers');
    if (body != null) print('Body: $body');
  }

  void _logResponse(int statusCode, String body, {Map<String, String>? headers}) {
    print('\n=== RESPONSE ===');
    print('Status: $statusCode');
    if (headers != null) print('Headers: $headers');
    print('Body: $body');
    print('================\n');
  }

  void _logError(String endpoint, dynamic error, StackTrace? stackTrace) {
    print('\n=== ERROR ===');
    print('Endpoint: $endpoint');
    print('Error: $error');
    if (stackTrace != null) print('Stack: $stackTrace');
    print('=============\n');
  }

  Future<String> login(String email, String password) async {
    final url = '$baseUrl/auth/login';
    final body = jsonEncode({'email': email, 'password': password});

    _logRequest('POST', url,
        headers: {'Content-Type': 'application/json'},
        body: body
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      _logResponse(response.statusCode, response.body);

      if (response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(error['detail'] ?? 'Login failed');
      }
    } catch (e, stackTrace) {
      _logError('/auth/login', e, stackTrace);
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, String>> register(String email, String password) async {
    final url = '$baseUrl/auth/register';
    final body = jsonEncode({'email': email, 'password': password});

    _logRequest('POST', url,
        headers: {'Content-Type': 'application/json'},
        body: body
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      _logResponse(response.statusCode, response.body);

      if (response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return {
          'access_token': data['access_token'],
          'message': data['message'],
        };
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(error['detail'] ?? 'Registration failed');
      }
    } catch (e, stackTrace) {
      _logError('/auth/register', e, stackTrace);
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<VoiceTranscript> voiceToText(File audioFile) async {
    final token = await _authService.getToken();
    if (token == null) throw ApiException('Not authenticated');

    final url = '$baseUrl/voice-to-text';

    _logRequest('POST', url,
        headers: {'Authorization': 'Bearer ${token.substring(0, 20)}...'},
        body: 'Multipart: audio file ${audioFile.path}'
    );

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse(response.statusCode, response.body);

      if (response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return VoiceTranscript.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(error['detail'] ?? 'Voice to text failed');
      }
    } catch (e, stackTrace) {
      _logError('/voice-to-text', e, stackTrace);
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<List<VoiceTranscript>> getHistory({
    int offset = 0,
    int limit = 5,
  }) async {
    final token = await _authService.getToken();
    if (token == null) throw ApiException('Not authenticated');

    final uri = Uri.parse('$baseUrl/history').replace(
      queryParameters: {
        'offset': offset.toString(),
        'limit': limit.toString(),
      },
    );

    _logRequest('GET', uri.toString(),
        headers: {'Authorization': 'Bearer ${token.substring(0, 20)}...'}
    );

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      _logResponse(response.statusCode, response.body);

      if (response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => VoiceTranscript.fromJson(item)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(error['detail'] ?? 'Failed to load history');
      }
    } catch (e, stackTrace) {
      _logError('/history', e, stackTrace);
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}

class VoiceTranscript {
  final int id;
  final String transcript;
  final String summary;
  final DateTime createdAt;

  VoiceTranscript({
    required this.id,
    required this.transcript,
    required this.summary,
    required this.createdAt,
  });

  factory VoiceTranscript.fromJson(Map<String, dynamic> json) {
    return VoiceTranscript(
      id: json['id'],
      transcript: json['transcript'],
      summary: json['summary'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
