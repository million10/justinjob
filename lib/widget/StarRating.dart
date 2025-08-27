/*import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating; // Rating value
  final int maxRating; // Maximum rating (e.g., 5)

  StarRating({
    required this.rating,
    this.maxRating = 5,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(maxRating, (index) {
      if (index < rating.floor()) {
        return Icon(Icons.star, color: Colors.amber, size: 16);
      } else if (index < rating) {
        return Icon(Icons.star_half, color: Colors.amber, size: 16);
      } else {
        return Icon(Icons.star_border, color: Colors.amber, size: 16);
      }
    });

    return Row(
      children: [
        ...stars,
        SizedBox(width: 4),
        Text('${rating.toStringAsFixed(1)}'),
      ],
    );
  }
}*/
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating; // Rating value
  final int maxRating; // Maximum rating (e.g., 5)

  StarRating({
    required this.rating,
    this.maxRating = 5,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(maxRating, (index) {
      if (index < rating.floor()) {
        return Icon(Icons.star, color: Colors.black, size: 16); // Full star
      } else if (index < rating) {
        return Icon(Icons.star_half,
            color: Colors.black, size: 16); // Half star
      } else {
        return Icon(Icons.star_border,
            color: Colors.black, size: 16); // Empty star
      }
    });

    return Center(
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // To center the row content within its parent
        children: [
          ...stars, // Spreads the stars list into the Row's children
          SizedBox(width: 4), // Spacing between stars and the text
          /*Text('${rating.toStringAsFixed(1)}'),*/
        ],
      ),
    );
  }
}
