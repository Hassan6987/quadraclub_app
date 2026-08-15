import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ProfilePictureWidget({super.key, this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: imagePath != null
                      ? DecorationImage(
                          image: AssetImage(imagePath!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imagePath == null
                    ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9500),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'AddProfilePicture',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
