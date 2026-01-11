/// Add Source Modal for Project 2359
///
/// Modal for uploading and adding new source materials.
/// Supports file picking, URL input, and various source types.
library;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../core/core.dart';

class AddSourceModal extends StatefulWidget {
  /// Callback when a source is successfully added
  final void Function(Source source)? onSourceAdded;

  const AddSourceModal({super.key, this.onSourceAdded});

  @override
  State<AddSourceModal> createState() => _AddSourceModalState();
}

class _AddSourceModalState extends State<AddSourceModal> {
  static const _uuid = Uuid();
  final _urlController = TextEditingController();
  final _storageService = SourceStorageService();
  final _indexingService = SourceIndexingService();

  SourceType? _selectedType;
  List<PlatformFile> _selectedFiles = [];
  bool _isUploading = false;
  String? _uploadError;
  double _uploadProgress = 0.0;

  // File type filters for each source type
  static const _fileExtensions = {
    SourceType.pdf: ['pdf'],
    SourceType.audio: ['mp3', 'wav', 'aac', 'm4a', 'ogg', 'flac'],
    SourceType.video: ['mp4', 'mov', 'avi', 'mkv', 'webm'],
    SourceType.image: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'],
  };

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      List<String>? allowedExtensions;
      FileType fileType = FileType.any;

      if (_selectedType != null && _fileExtensions.containsKey(_selectedType)) {
        allowedExtensions = _fileExtensions[_selectedType];
        fileType = FileType.custom;
      }

      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
        withData: false,
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFiles = result.files;
          _uploadError = null;
          // Auto-detect type from first file if not already selected
          _selectedType ??= _detectTypeFromExtension(
            result.files.first.extension,
          );
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _uploadError = 'Failed to pick files: ${e.message}';
      });
    }
  }

  SourceType? _detectTypeFromExtension(String? ext) {
    if (ext == null) return null;
    final lower = ext.toLowerCase();
    for (final entry in _fileExtensions.entries) {
      if (entry.value.contains(lower)) {
        return entry.key;
      }
    }
    return null;
  }

  Future<void> _handleImport() async {
    if (_selectedFiles.isEmpty && _urlController.text.isEmpty) {
      setState(() {
        _uploadError = 'Please select files or enter a URL';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadError = null;
      _uploadProgress = 0.0;
    });

    try {
      if (_selectedFiles.isNotEmpty) {
        await _importFiles();
      } else if (_urlController.text.isNotEmpty) {
        await _importUrl();
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _uploadError = 'Import failed: $e';
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _importFiles() async {
    final total = _selectedFiles.length;
    var completed = 0;

    for (final file in _selectedFiles) {
      if (file.path == null) continue;

      final type =
          _selectedType ??
          _detectTypeFromExtension(file.extension) ??
          SourceType.pdf;

      // Store the file
      final storedPath = await _storageService.storeFile(file.path!, type);

      // Get file size
      final fileInfo = File(storedPath);
      final fileSize = await fileInfo.length();

      // Create source entry
      final source = Source(
        id: _uuid.v4(),
        title: file.name,
        type: type,
        createdAt: DateTime.now(),
        lastAccessedAt: DateTime.now(),
        filePath: storedPath,
        sizeBytes: fileSize,
        isIndexed: false,
      );

      // Index the source (this creates placeholder items for now)
      // TODO: In the future, this will run async in background
      await _indexingService.indexSource(source);

      // Notify parent
      widget.onSourceAdded?.call(source);

      completed++;
      setState(() {
        _uploadProgress = completed / total;
      });
    }
  }

  Future<void> _importUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    // Validate URL
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      throw FormatException('Invalid URL format');
    }

    final source = Source(
      id: _uuid.v4(),
      title: _extractTitleFromUrl(url),
      type: SourceType.link,
      createdAt: DateTime.now(),
      lastAccessedAt: DateTime.now(),
      url: url,
      isIndexed: false,
    );

    // Index the link (placeholder for now)
    await _indexingService.indexSource(source);

    widget.onSourceAdded?.call(source);
  }

  String _extractTitleFromUrl(String url) {
    final uri = Uri.parse(url);
    // Try to get a readable title from the path or host
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.last.isNotEmpty) {
      return uri.pathSegments.last
          .replaceAll('-', ' ')
          .replaceAll('_', ' ')
          .replaceAll('.html', '')
          .replaceAll('.htm', '');
    }
    return uri.host;
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles = List.from(_selectedFiles)..removeAt(index);
    });
  }

  void _selectType(SourceType type) {
    setState(() {
      if (_selectedType == type) {
        _selectedType = null;
      } else {
        _selectedType = type;
        // Clear files if type changed to incompatible
        if (!_fileExtensions.containsKey(type)) {
          _selectedFiles = [];
        }
      }
    });
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _urlController.text = data!.text!;
      setState(() {
        _selectedType = SourceType.link;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildHeader(context),
            Text(
              'Expand your knowledge base.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            _buildUploadArea(),
            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSelectedFiles(context),
            ],
            const SizedBox(height: 24),
            _buildUrlInput(context),
            const SizedBox(height: 24),
            _buildFileTypeSection(context),
            if (_uploadError != null) ...[
              const SizedBox(height: 16),
              _buildError(context),
            ],
            const SizedBox(height: 32),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Add New Source', style: Theme.of(context).textTheme.displaySmall),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildUploadArea() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isUploading ? null : _pickFiles,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: _isUploading
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.white12,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.02),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: _isUploading
                    ? SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          value: _uploadProgress > 0 ? _uploadProgress : null,
                          strokeWidth: 2,
                          color: Colors.blueAccent,
                        ),
                      )
                    : const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.blueAccent,
                        size: 32,
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                _isUploading
                    ? 'Uploading... ${(_uploadProgress * 100).toInt()}%'
                    : 'Tap to Browse',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                _isUploading
                    ? 'Please wait...'
                    : _selectedType != null
                    ? 'Select ${_selectedType!.name.toUpperCase()} files'
                    : 'PDF, Audio, Video, or Images',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFiles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Files (${_selectedFiles.length})',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            TextButton(
              onPressed: () => setState(() => _selectedFiles = []),
              child: Text(
                'Clear All',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 120),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _selectedFiles.length,
            itemBuilder: (context, index) {
              final file = _selectedFiles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getFileIcon(file.extension),
                      color: Colors.white54,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        file.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatFileSize(file.size),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => _removeFile(index),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            color: Colors.white38,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getFileIcon(String? ext) {
    if (ext == null) return Icons.insert_drive_file;
    final lower = ext.toLowerCase();
    if (lower == 'pdf') return Icons.picture_as_pdf;
    if (_fileExtensions[SourceType.audio]!.contains(lower)) {
      return Icons.audio_file;
    }
    if (_fileExtensions[SourceType.video]!.contains(lower)) {
      return Icons.video_file;
    }
    if (_fileExtensions[SourceType.image]!.contains(lower)) {
      return Icons.image;
    }
    return Icons.insert_drive_file;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _buildUrlInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Import from Link', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TextField(
          controller: _urlController,
          style: const TextStyle(color: Colors.white),
          onChanged: (_) {
            if (_selectedType != SourceType.link &&
                _urlController.text.isNotEmpty) {
              setState(() => _selectedType = SourceType.link);
            }
          },
          decoration: InputDecoration(
            hintText: 'Paste YouTube or website URL',
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.surface,
            prefixIcon: const Icon(Icons.link, color: AppColors.textTertiary),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _pasteFromClipboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Paste'),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileTypeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose File Type', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
          children: [
            _FileTypeItem(
              icon: Icons.picture_as_pdf,
              label: 'PDF',
              iconColor: Colors.redAccent,
              isSelected: _selectedType == SourceType.pdf,
              onTap: () => _selectType(SourceType.pdf),
            ),
            _FileTypeItem(
              icon: Icons.link,
              label: 'Link',
              iconColor: Colors.blueAccent,
              isSelected: _selectedType == SourceType.link,
              onTap: () => _selectType(SourceType.link),
            ),
            _FileTypeItem(
              icon: Icons.description,
              label: 'Note',
              iconColor: Colors.orangeAccent,
              isSelected: _selectedType == SourceType.note,
              onTap: () => _selectType(SourceType.note),
            ),
            _FileTypeItem(
              icon: Icons.audio_file,
              label: 'Audio',
              iconColor: Colors.purpleAccent,
              isSelected: _selectedType == SourceType.audio,
              onTap: () => _selectType(SourceType.audio),
            ),
            _FileTypeItem(
              icon: Icons.video_file,
              label: 'Video',
              iconColor: Colors.tealAccent,
              isSelected: _selectedType == SourceType.video,
              onTap: () => _selectType(SourceType.video),
            ),
            _FileTypeItem(
              icon: Icons.image,
              label: 'Image',
              iconColor: Colors.pinkAccent,
              isSelected: _selectedType == SourceType.image,
              onTap: () => _selectType(SourceType.image),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _uploadError!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isUploading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppColors.textTertiary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isUploading ? null : _handleImport,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isUploading
                      ? Icons.hourglass_empty
                      : Icons.file_download_outlined,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(_isUploading ? 'Importing...' : 'Import Selected'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FileTypeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _FileTypeItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: isSelected ? iconColor.withOpacity(0.15) : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? iconColor.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
