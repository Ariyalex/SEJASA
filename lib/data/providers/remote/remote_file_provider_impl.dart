import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/domain/providers/remote_file_provider.dart';

class RemoteFileProviderImpl extends RemoteFileProvider {
  final ApiService _apiService;
  RemoteFileProviderImpl(this._apiService);

  @override
  Future<String> uploadFile(File file, String fileName) async {
    final response = await _apiService.uploadFile(
      '/upload',
      file.path,
      fieldName: fileName,
    );
    return response.data['data']['file_url'] as String;
  }

  @override
  Future<File> downloadUploadedFile(String fileUrl) async {
    final tempDir = await getTemporaryDirectory();
    final uri = Uri.parse(fileUrl);
    final fileName = uri.pathSegments.isEmpty
        ? 'file_${DateTime.now().millisecondsSinceEpoch}'
        : uri.pathSegments.last;
    final savePath = '${tempDir.path}/$fileName';

    await _apiService.download(fileUrl, savePath);
    return File(savePath);
  }
}
