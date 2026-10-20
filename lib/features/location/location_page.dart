import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../state/app_state.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.darken,
              ),
              child: const FoodImage('map', fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            bottom: 215,
            child: CustomPaint(painter: _RoutePainter()),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: () => back(context),
                  icon: const Icon(CupertinoIcons.arrow_left),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            CupertinoIcons.location_solid,
                            color: Brand.yellow,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.city == 'Surat'
                                    ? 'Nana Varachha'
                                    : state.city,
                                style: const TextStyle(
                                  color: Brand.yellow,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '${state.address}\n${state.city == 'Surat' ? 'Surat, Gujarat, India' : state.city}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => go(context, Routes.shipping),
                          child: const Text('CHANGE'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      'Confirm Location',
                      onPressed: () {
                        state.onboarded = true;
                        state.save();
                        go(context, Routes.home, root: true);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(size.width * .18, size.height * .78),
      Offset(size.width * .48, size.height * .68),
      Offset(size.width * .46, size.height * .62),
      Offset(size.width * .7, size.height * .62),
      Offset(size.width * .67, size.height * .5),
      Offset(size.width * .77, size.height * .49),
      Offset(size.width * .72, size.height * .37),
      Offset(size.width * .81, size.height * .37),
    ];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Brand.yellow
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(points.first, 7, Paint()..color = Brand.yellow);
    canvas.drawCircle(points.last, 8, Paint()..color = const Color(0xFFFF3434));
    canvas.drawCircle(points.last, 3, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) => false;
}
