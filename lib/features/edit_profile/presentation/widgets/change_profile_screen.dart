import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/endpoints.dart';
import '../../../../core/values/images_paths.dart';

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({super.key, this.photo, this.onImageSelected});
  final String? photo;
  final ValueChanged<File>? onImageSelected;

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _retrieveLostData();
  }

  Future<void> _retrieveLostData() async {
    final response = await _imagePicker.retrieveLostData();
    if (response.isEmpty || !mounted) return;

    final file = response.file;
    if (file != null) {
      final selectedImage = File(file.path);
      setState(() => _selectedImage = selectedImage);
      widget.onImageSelected?.call(selectedImage);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);

    try {
      final image = await _imagePicker.pickImage(source: source);
      if (image == null || !mounted) return;

      final selectedImage = File(image.path);
      setState(() => _selectedImage = selectedImage);
      widget.onImageSelected?.call(selectedImage);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showImageSourceBottomSheet,
      child: Stack(
        children: [
          Container(
            width: 81,
            height: 81,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            clipBehavior: Clip.antiAlias,
            child: _buildProfileImage(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.lightPink,
              ),
              child: Icon(Icons.camera_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_selectedImage != null) {
      return Image.file(_selectedImage!, fit: BoxFit.cover);
    }

    if (widget.photo != null && widget.photo!.isNotEmpty) {
      return Image.network(
        '${Endpoints.imageBaseUrl}${widget.photo}',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(Assets.defaultProfileImage, fit: BoxFit.cover);
        },
      );
    }

    return Image.asset(Assets.defaultProfileImage, fit: BoxFit.cover);
  }
}
