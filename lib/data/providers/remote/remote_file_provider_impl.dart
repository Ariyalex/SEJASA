import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sejasa/core/config/app_config.dart';
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

    // Construct correct URL using AppConfig.baseUrl instead of AppConfig.baseApiUrl
    String downloadUrl = fileUrl;
    if (!fileUrl.startsWith('http://') && !fileUrl.startsWith('https://')) {
      final baseUrl = AppConfig.baseUrl;
      final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
      final cleanFileUrl = fileUrl.startsWith('/') ? fileUrl : '/$fileUrl';
      downloadUrl = '$cleanBaseUrl$cleanFileUrl';
    } else {
      final apiPrefix = AppConfig.baseApiUrl;
      if (fileUrl.startsWith(apiPrefix)) {
        downloadUrl = fileUrl.replaceFirst(apiPrefix, AppConfig.baseUrl);
      }
    }

    await _apiService.download(downloadUrl, savePath);
    return File(savePath);
  }
}
