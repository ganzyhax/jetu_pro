import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jetu/app/resourses/app_colors.dart';
import 'package:jetu/app/resourses/app_icons.dart';


class Avatar extends StatefulWidget {
  final String imageUrl;
  final void Function(Uint8List, String) onUpload;

  const Avatar({
    Key? key,
    required this.imageUrl,
    required this.onUpload,
  }) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  String localSelected = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _upload,
      child: Column(
        children: [
          if (localSelected.isNotEmpty)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: CircleAvatar(
                    backgroundColor: AppColors.black.withOpacity(0.67),
                    backgroundImage: FileImage(File(localSelected)),
                    radius: 67.sp,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    localSelected = '';
                    widget.onUpload(Uint8List(0), '');
                  }),
                  icon: const Icon(Icons.clear),
                )
              ],
            )
          else if (widget.imageUrl.isEmpty)
            CircleAvatar(
              backgroundColor: AppColors.black.withOpacity(0.67),
              backgroundImage: const NetworkImage(AppIcons.avatarUrl),
              radius: 67.sp,
            )
          else
            CircleAvatar(
              backgroundColor: AppColors.black.withOpacity(0.67),
              backgroundImage: NetworkImage(widget.imageUrl),
              radius: 67.sp,
            ),
          TextButton(
            onPressed: _upload,
            child: const Text('Измените фотографию профиля'),
          )
        ],
      ),
    );
  }

  Future<void> _upload() async {
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }

    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    localSelected = imageFile.path;
    setState(() {});
    widget.onUpload(bytes, imageFile.path);
  }
}
