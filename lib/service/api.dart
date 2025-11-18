import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth.dart';

class ApiService {
  static final String baseUrl = dotenv.env['BACKEND_BASE_URL'] ?? 'http://localhost:8000';
  final AuthService _authService = AuthService();

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      final error = jsonDecode(response.body);
      throw ApiException(error['detail'] ?? 'Login failed');
    }
  }

  Future<Map<String, String>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

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
  }

  Future<VoiceTranscript> voiceToText(File audioFile) async {
    final token = await _authService.getToken();
    if (token == null) throw ApiException('Not authenticated');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/voice-to-text'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath('audio', audioFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return VoiceTranscript.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw ApiException(error['detail'] ?? 'Voice to text failed');
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

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => VoiceTranscript.fromJson(item)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw ApiException(error['detail'] ?? 'Failed to load history');
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
