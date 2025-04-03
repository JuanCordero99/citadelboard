import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _animation,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 4,
                  style: BorderStyle.solid,
                ),
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColorLight,
                  ),
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _controller.value,
                child: const Text(
                  "Cargando información...",
                  style: TextStyle(fontSize: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}