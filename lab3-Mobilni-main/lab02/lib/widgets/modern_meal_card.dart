import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/firebase_service.dart';

class ModernMealCard extends StatefulWidget {
  final Meal meal;
  final VoidCallback onTap;

  const ModernMealCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  State<ModernMealCard> createState() => _ModernMealCardState();
}

class _ModernMealCardState extends State<ModernMealCard>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final fav = await FirebaseService().isFavorite(widget.meal.idMeal);
    setState(() {
      isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    setState(() => isFavorite = !isFavorite);


    await Future.delayed(const Duration(milliseconds: 100));

    if (isFavorite) {
      await FirebaseService().addFavorite(
        widget.meal.idMeal,
        widget.meal.strMeal,
        widget.meal.strMealThumb,
      );
    } else {
      await FirebaseService().removeFavorite(widget.meal.idMeal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: widget.meal.idMeal,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.meal.strMealThumb,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child: Text(
                      widget.meal.strMeal,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),


                  GestureDetector(
                    onTap: _toggleFavorite,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFavorite),
                        color: Colors.red,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
