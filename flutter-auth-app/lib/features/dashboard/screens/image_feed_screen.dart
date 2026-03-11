import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../features/auth/controller/image_controller.dart';

class ImageFeedScreen extends StatefulWidget {
  const ImageFeedScreen({super.key});

  @override
  State<ImageFeedScreen> createState() => _ImageFeedScreenState();
}

class _ImageFeedScreenState extends State<ImageFeedScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    debugPrint('🔷 [ImageFeedScreen] initState() called');

    final imageController =
        Provider.of<ImageController>(context, listen: false);

    debugPrint('🔷 [ImageFeedScreen] Calling loadImages() from initState');
    imageController.loadImages();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        debugPrint(
            '🔷 [ImageFeedScreen] Scroll reached bottom, triggering pagination');
        imageController.loadImages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Feed"),
      ),
      body: RefreshIndicator(
        onRefresh: imageController.refreshImages,
        child: Column(
          children: [
            // Error message banner
            if (imageController.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.red.shade100,
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        imageController.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            // Grid view
            Expanded(
              child: GridView.builder(
                controller: controller,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: imageController.images.length +
                    (imageController.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator at the end
                  if (index >= imageController.images.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  final image = imageController.images[index]["download_url"];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullImageViewer(
                            images: imageController.images,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 32),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom loading indicator (alternative position)
            if (imageController.isLoading && imageController.images.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: const CircularProgressIndicator(),
              ),

            // End of list message
            if (!imageController.hasMore && imageController.images.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'No more images to load',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// class FullImageViewer extends StatelessWidget {

//   final String imageUrl;

//   const FullImageViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       backgroundColor: Colors.black,

//       body: Stack(

//         children: [

//           /// background image
//           Positioned.fill(
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               fit: BoxFit.cover,
//             ),
//           ),

//           /// blur effect
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaX: 20,
//                 sigmaY: 20,
//               ),
//               child: Container(
//                 color: Colors.black.withOpacity(0.4),
//               ),
//             ),
//           ),

//           /// main image
//           Center(
//             child: InteractiveViewer(
//               child: CachedNetworkImage(
//                 imageUrl: imageUrl,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),

//           /// close button
//           Positioned(
//             top: 40,
//             right: 20,
//             child: IconButton(
//               icon: const Icon(
//                 Icons.close,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),

//         ],

//       ),

//     );
//   }
// }
class FullImageViewer extends StatefulWidget {
  final List images;
  final int initialIndex;

  const FullImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullImageViewer> createState() => _FullImageViewerState();
}

class _FullImageViewerState extends State<FullImageViewer> {
  late PageController pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// BACKGROUND BLUR
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.images[currentIndex]["download_url"],
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),

          /// IMAGE CAROUSEL
          PageView.builder(
            controller: pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final image = widget.images[index]["download_url"];

              return Center(
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          /// IMAGE COUNTER
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${currentIndex + 1} / ${widget.images.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          /// CLOSE BUTTON
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
