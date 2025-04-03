import 'package:flutter/material.dart';
import 'ImageComponent.dart' as ImageComponent;

class CardComponent extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String text1;
  final String text2;
  final String text3;
  final String status;
  final VoidCallback onTap;

  const CardComponent({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.status,
    required this.onTap,
  }) : super(key: key);

  // Método para obtener el color según el estado
  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      case 'unknown':
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double cardWidth = screenSize.width * 0.9;
    final double cardHeight = screenSize.height * 0.2;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Row(
                children: [
                  ImageComponent.Imagecomponent(imageUrl: imageUrl, status: status),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(text1),
                        Text(text2),
                        Text(text3),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 6.0,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}