import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> diagnoses;

  const HistoryScreen({super.key, required this.diagnoses});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // A map to cache image URLs to avoid re-fetching them repeatedly
  final Map<String, String> _imageUrlCache = {};

  Future<String?> _fetchImageUrl(String imageKey) async {
    if (_imageUrlCache.containsKey(imageKey)) {
      return _imageUrlCache[imageKey];
    }
    try {
      final GetUrlResult result = await Amplify.Storage.getUrl(key: imageKey);
      _imageUrlCache[imageKey] = result.url.toString();
      return result.url.toString();
    } on StorageException catch (e) {
      debugPrint('Error getting download URL: ${e.message}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnosis History',
          style: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.bold,
            color: Color(0xFF28824D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF28824D)),
      ),
      backgroundColor: Colors.white,
      body: widget.diagnoses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder for an empty history illustration
                  // You can use SvgPicture.asset here if you have one for history
                  const Icon(Icons.history, size: 80, color: Color(0xFF707070)),
                  const SizedBox(height: 16),
                  const Text(
                    'No Diagnosis History Yet!',
                    style: TextStyle(fontSize: 18, color: Color(0xFF4C4C4C), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your past plant diagnoses will appear here.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF707070)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.diagnoses.length,
              itemBuilder: (context, index) {
                final scan = widget.diagnoses[index];
                final imageKey = scan['image_key'] as String?;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the actual image from S3
                        if (imageKey != null && imageKey.isNotEmpty)
                          FutureBuilder<String?>(
                            future: _fetchImageUrl(imageKey),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                );
                              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              } else {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    snapshot.data!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error_outline, color: Colors.red),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          )
                        else
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scan['plantName'] ?? 'Unknown Plant',
                                style: const TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF28824D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                scan['diagnosis'] ?? 'No Diagnosis',
                                style: const TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 16,
                                  color: Color(0xFF4C4C4C),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${scan['date']} • ${scan['time']}',
                                style: const TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 12,
                                  color: Color(0xFF707070),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF838383),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}