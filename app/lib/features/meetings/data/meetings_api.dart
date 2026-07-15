import 'package:dio/dio.dart';
import 'package:app/features/meetings/domain/meeting.dart';

class MeetingsApi {
  MeetingsApi(this._dio);

  final Dio _dio;

  Future<List<dynamic>> list(int unitId) async {
    final response = await _dio.get('/api/meetings/', queryParameters: {'unit': unitId});
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> create(MeetingDraft draft) async {
    final response = await _dio.post('/api/meetings/', data: draft.toJson());
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> update(int id, MeetingDraft draft) async {
    final response = await _dio.patch('/api/meetings/$id/', data: draft.toJson());
    return response.data as Map<String, dynamic>;
  }

  Future<void> delete(int id) async {
    await _dio.delete('/api/meetings/$id/');
  }
}
