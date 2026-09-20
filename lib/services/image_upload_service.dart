import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadResult {
  final bool isSuccess;
  final String imageUrl;
  final String? errorMessage;
  final bool isFallback;

  UploadResult({
    required this.isSuccess,
    required this.imageUrl,
    this.errorMessage,
    this.isFallback = false,
  });
}

class ImageUploadService {
  /// Uploads an image [XFile] to a real remote image server.
  /// 
  /// Tries public image hosting API (e.g., tmpfiles.org / freeimage.host),
  /// and falls back gracefully to a base64 Data URL if offline or upon network error.
  static Future<UploadResult> uploadImage(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final filename = imageFile.name.isNotEmpty ? imageFile.name : 'upload.jpg';

      // 1. Try public image hosting endpoint (tmpfiles.org API)
      final remoteUrl = await _uploadToTmpFiles(bytes, filename);
      if (remoteUrl != null && remoteUrl.isNotEmpty) {
        return UploadResult(
          isSuccess: true,
          imageUrl: remoteUrl,
        );
      }

      // 2. Fallback: Generate Base64 Data URL for persistent cross-platform rendering
      final mimeType = _getMimeType(filename);
      final base64String = base64Encode(bytes);
      final dataUrl = 'data:$mimeType;base64,$base64String';

      return UploadResult(
        isSuccess: true,
        imageUrl: dataUrl,
        isFallback: true,
      );
    } catch (e) {
      return UploadResult(
        isSuccess: false,
        imageUrl: '',
        errorMessage: e.toString(),
      );
    }
  }

  static Future<String?> _uploadToTmpFiles(Uint8List bytes, String filename) async {
    try {
      final uri = Uri.parse('https://tmpfiles.org/api/v1/upload');
      final request = http.MultipartRequest('POST', uri);

      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
      );

      request.files.add(multipartFile);

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 12),
      );

      if (streamedResponse.statusCode == 200) {
        final responseString = await streamedResponse.stream.bytesToString();
        final jsonResponse = jsonDecode(responseString);

        if (jsonResponse is Map && jsonResponse['status'] == 'success') {
          final rawUrl = jsonResponse['data']?['url'] as String?;
          if (rawUrl != null && rawUrl.contains('tmpfiles.org/')) {
            // Convert page URL to direct download URL (e.g., https://tmpfiles.org/123/img.jpg -> https://tmpfiles.org/dl/123/img.jpg)
            return rawUrl.replaceFirst('tmpfiles.org/', 'tmpfiles.org/dl/');
          }
        }
      }
    } catch (_) {
      // Ignore network errors and allow fallback
    }
    return null;
  }

  static String _getMimeType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }
}
