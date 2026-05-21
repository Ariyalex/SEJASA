import 'dart:io';

import 'package:sejasa/domain/providers/remote_file_provider.dart';
import 'package:sejasa/domain/repositories/file_repository.dart';

class FileRepositoryImpl extends FileRepository {
  final RemoteFileProvider _remoteFileProvider;
  FileRepositoryImpl(this._remoteFileProvider);

  @override
  Future<String> uploadDocument(File file) async {
    final response = await _remoteFileProvider.uploadFile(file, 'document');
    return response;
  }

  @override
  Future<String> uploadImage(File file) async {
    final response = await _remoteFileProvider.uploadFile(file, 'image');
    return response;
  }

  @override
  Future<File> downloadUploadedFile(String fileUrl) async {
    final response = await _remoteFileProvider.downloadUploadedFile(fileUrl);
    return response;
  }
}
