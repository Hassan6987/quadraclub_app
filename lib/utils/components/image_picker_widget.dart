// lib/utils/components/image_picker_widget.dart

import 'package:image_picker/image_picker.dart';
import 'package:quadraclub_app/app_exports.dart';

class ImagePickerWidget extends StatefulWidget {
  final ValueChanged<List<File>> onImagesSelected;

  const ImagePickerWidget({super.key, required this.onImagesSelected});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
      widget.onImagesSelected(_images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ..._images.map((image) {
            return Padding(
              padding: EdgeInsets.only(right: getProportionateScreenWidth(10)),
              child: Container(
                width: getProportionateScreenWidth(70),
                height: getProportionateScreenHeight(70),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: getProportionateScreenWidth(70),
              height: getProportionateScreenHeight(70),
              decoration: BoxDecoration(
                border: Border.all(color: kTertiaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.photo_camera_outlined,
                color: kTertiaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
