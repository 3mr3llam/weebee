import 'package:flutter/material.dart';
import 'package:ithraashop/constants.dart';

class LogoProgress extends StatelessWidget {
  final double percent;

  const LogoProgress({Key? key, required this.percent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 2500),
        builder: (context, double value, child) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.2,
            child: Stack(
              children: [
                // Container(
                //   color: Colors.amber,
                // )
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [percent, percent],
                        colors: [Theme.of(context).primaryColor, progressColor]).createShader(rect);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset("assets/images/logo-white.png").image,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
