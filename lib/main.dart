import 'package:flutter/material.dart';
import 'package:path_morph/path_morph.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  SampledPathData data;
  bool reversed = false;

  String pathLogo1 =
      'M 100, 100 m -75, 0 a 75,75 0 1,0 150,0 a 75,75 0 1,0 -150,0';
  String pathLogo2 =
      'M154.67683,17.32318c0,0 -51.47683,-0.12318 -91.61016,40.01016c-1.85295,1.85295 -3.46634,3.87014 -4.92708,5.95729c-7.11553,-0.56892 -18.0076,-0.38307 -23.58281,5.19583c-13.01467,13.01467 -17.35677,34.71354 -17.35677,34.71354l28.66667,-4.09844v9.83177l17.2,17.2h9.83177l-4.09844,28.66667c0,0 21.69888,-4.34211 34.71354,-17.35677c5.5789,-5.57521 5.76476,-16.46728 5.19583,-23.58281c2.08715,-1.46074 4.10434,-3.07413 5.95729,-4.92708c40.13333,-40.13333 40.01016,-91.61016 40.01016,-91.61016zM108.93333,51.6c6.33533,0 11.46667,5.13133 11.46667,11.46667c0,6.33533 -5.13133,11.46667 -11.46667,11.46667c-6.33533,0 -11.46667,-5.13133 -11.46667,-11.46667c0,-6.33533 5.13133,-11.46667 11.46667,-11.46667zM41.27552,114.64427c-2.17867,0.57333 -4.24329,1.66777 -5.94609,3.37057c-7.83173,7.83173 -6.58437,25.22891 -6.58437,25.22891c0,0 17.28277,1.35056 25.21771,-6.58437c1.7028,-1.70281 2.79724,-3.77863 3.37057,-5.95729l-2.62031,-2.62031c-0.258,0.36693 -0.41773,0.79299 -0.75026,1.11979c-5.59,5.59 -13.975,2.79948 -13.975,2.79948c0,0 -2.79625,-8.385 2.79948,-13.975c0.33253,-0.33253 0.74166,-0.48653 1.10859,-0.75026z';
  int showinglogo = 1;

  AnimationController animationController;

  @override
  void initState() {
    initiateTransition();
    Future.delayed(Duration(seconds: 2))
        .then((value) => animationController.forward());

    super.initState();
  }

  initiateTransition() {
    const scaleRation = 0.8;

    final matrix4 = Matrix4.identity()..scale(scaleRation, scaleRation);
    Path path1 = parseSvgPath(pathLogo1).transform(matrix4.storage);
    Path path2 = parseSvgPath(pathLogo2).transform(matrix4.storage);

    data = PathMorph.samplePaths(path1, path2);

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    PathMorph.generateAnimations(animationController, data, func);
  }

  void func(int i, Offset z) {
    setState(() {
      data.shiftedPoints[i] = z;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff7E99FC),
        body: InkWell(
          onTap: () {
            if (reversed) {
              reversed = false;
              animationController.forward();
            } else {
              reversed = true;
              animationController.reverse();
            }
          },
          child: Stack(
            children: [
              Center(
                child: FittedBox(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: CustomPaint(
                      painter: MyPainter(
                        PathMorph.generatePath(data),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Image.asset(
                    'assets/images/Aviato.png',
                    height: 26,
                    //width: 100,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Path path;
  var myPaint;

  MyPainter(this.path) {
    myPaint = Paint();
    myPaint.color = Colors.white;
    myPaint.strokeWidth = 3.0;
  }

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(path, myPaint);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int showinglogo = 1;

//   @override
//   void initState() {
//     automateTransition();

//     super.initState();
//   }

//   automateTransition() {
//     Future.delayed(Duration(seconds: 3)).then((value) {
//       setState(() {
//         showinglogo = 2;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Color(0xff7E99FC),
//         body: Stack(
//           children: [
//             Center(
//               child: InkWell(
//                 child: AnimatedSwitcher(
//                   duration: Duration(seconds: 2),
//                   child: getImageAsset(showinglogo),
//                 ),
//                 onTap: () {
//                   setState(() {
//                     showinglogo = 1;
//                   });
//                   automateTransition();
//                 },
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 30),
//                 child: Image.asset(
//                   'assets/images/Aviato.png',
//                   height: 26,
//                   //width: 100,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   getImageAsset(int choice) {
//     return Image.asset(
//       choice == 1 ? 'assets/images/logo_1.png' : 'assets/images/logo_2.png',
//       height: 100,
//       width: 100,
//     );
//   }
// }
