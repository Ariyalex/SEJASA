import 'dart:io';

abstract class FileRepository {
  Future<String> uploadImage(File file);
  Future<String> uploadDocument(File file);
  Future<File> downloadUploadedFile(String fileUrl);
}
