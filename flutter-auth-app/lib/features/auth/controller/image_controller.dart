import 'package:flutter/material.dart';
import '../../../services/image_service.dart';

class ImageController extends ChangeNotifier {

  final ImageService _service = ImageService();

  List images = [];

  int page = 1;

  bool isLoading = false;

  bool hasMore = true;

  String? errorMessage;

  Future loadImages() async {

    debugPrint('🔵 [ImageController] loadImages() called - Current page: $page, Images count: ${images.length}, isLoading: $isLoading');

    // Skip if images already loaded (caching)
    if (images.isNotEmpty && page == 1) {
      debugPrint('🟡 [ImageController] Images already loaded, skipping initial API call (cache hit)');
      return;
    }

    // Prevent duplicate requests and stop if no more data
    if (isLoading || !hasMore) {
      debugPrint('🟡 [ImageController] Skipping loadImages - isLoading: $isLoading, hasMore: $hasMore');
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners(); // Notify immediately to show loading state

    debugPrint('🟢 [ImageController] Starting API call for page: $page');

    try {
      final data = await _service.fetchImages(page);

      debugPrint('✅ [ImageController] API call successful - Received ${data.length} images');

      // Check if we've reached the end of available data
      if (data.isEmpty) {
        hasMore = false;
        debugPrint('🔴 [ImageController] No more images available');
      } else {
        images.addAll(data);
        page++;
        debugPrint('📦 [ImageController] Total images now: ${images.length}, Next page: $page');
      }

    } catch (e) {
      errorMessage = 'Failed to load images: ${e.toString()}';
      debugPrint('❌ [ImageController] API call failed: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future refreshImages() async {

    debugPrint('🔄 [ImageController] refreshImages() called - Resetting state');

    page = 1;
    images.clear();
    hasMore = true;
    errorMessage = null;

    await loadImages();

  }

}