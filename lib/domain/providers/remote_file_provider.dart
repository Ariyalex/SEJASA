import 'dart:io';

abstract class RemoteFileProvider {
  Future<String> uploadFile(File file, String fileName);
  Future<File> downloadUploadedFile(String fileUrl);
}
