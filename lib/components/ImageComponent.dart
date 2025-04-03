import 'package:flutter/material.dart';

class Imagecomponent extends StatelessWidget {
  final String imageUrl;
  final String status;

  const Imagecomponent({
    Key? key,
    required this.imageUrl,
    required this.status,
  }) : super(key: key);

  // Método para determinar la opacidad según el estado
  double _getOpacity() {
    switch (status.toLowerCase()) {
      case 'dead':
        return 0.6;
      case 'unknown':
        return 0.8;
      case 'alive':
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double imageWidth = screenSize.width * 0.25;
    final double imageHeight = screenSize.height * 0.2;

    return Opacity(
      opacity: _getOpacity(),
      child: Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: status.toLowerCase() == 'dead'
              ? Colors.grey.withOpacity(0.3)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: imageWidth,
            height: imageHeight,
            color: status.toLowerCase() == 'dead' ? Colors.grey : null,
            colorBlendMode: status.toLowerCase() == 'dead' ? BlendMode.saturation : null,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                '../assets/images/alert.webp',
                fit: BoxFit.cover,
                width: imageWidth,
                height: imageHeight,
              );
            },
          ),
        ),
      ),
    );
  }
}