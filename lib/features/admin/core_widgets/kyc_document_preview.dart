import 'package:flutter/material.dart';
import 'package:wargago/core/models/KYC/kyc_document_model.dart';
import 'package:wargago/core/services/kyc_service.dart';

/// Widget untuk menampilkan preview KYC document
/// Menggunakan URL yang di-generate on-demand untuk menghindari expired URL
class KYCDocumentPreview extends StatefulWidget {
  final KYCDocumentModel document;
  final VoidCallback? onTap;
  final double height;
  final KYCService? kycService; // Optional: use existing service

  const KYCDocumentPreview({
    super.key,
    required this.document,
    this.onTap,
    this.height = 200,
    this.kycService,
  });

  @override
  State<KYCDocumentPreview> createState() => _KYCDocumentPreviewState();
}

class _KYCDocumentPreviewState extends State<KYCDocumentPreview> {
  late final KYCService _kycService;
  String? _documentUrl;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Use provided service or create new one
    _kycService = widget.kycService ?? KYCService();
    _loadDocumentUrl();
  }

  Future<void> _loadDocumentUrl() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Generate fresh URL dari blob name
      final url = await _kycService.getDocumentUrlFromModel(widget.document);

      if (mounted) {
        setState(() {
          _documentUrl = url;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  bool get _isPdf {
    final blobName = widget.document.blobName.toLowerCase();
    return blobName.endsWith('.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null && _documentUrl != null) {
          widget.onTap!();
        }
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Loading...', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    if (_error != null || _documentUrl == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 32, color: Colors.red),
            SizedBox(height: 4),
            Text('Failed to load', style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            ElevatedButton(
              onPressed: _loadDocumentUrl,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size(60, 30),
              ),
              child: const Text('Retry', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      );
    }

    if (_isPdf) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: 32),
            SizedBox(height: 4),
            Text('PDF', style: TextStyle(fontSize: 12)),
            Text('Tap to view', style: TextStyle(fontSize: 10)),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        _documentUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 32, color: Colors.red),
                SizedBox(height: 4),
                Text(
                  'Load failed',
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                ElevatedButton(
                  onPressed: _loadDocumentUrl,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size(60, 30),
                  ),
                  child: const Text('Retry', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }

  /// Get current document URL (untuk open di browser/viewer)
  String? get documentUrl => _documentUrl;
}
