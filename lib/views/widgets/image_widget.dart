import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String url;
  const ImageWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration:
        BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffc2c2c2),
              Color(0xffb7b7b7),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            url,
            fit: BoxFit.cover,
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
        ),
      ),
    );
  }
}
