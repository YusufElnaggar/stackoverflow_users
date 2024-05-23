import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:stackoverflow_users/gen/assets.gen.dart';

class EmptyListWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? widget;
  final double? height;
  const EmptyListWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.widget,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? SizerUtil.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Lottie.asset(
            Assets.lottie.empty,
            height: 350,
            // width: SizerUtil.width,
            fit: BoxFit.fitHeight,
            alignment: Alignment.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                subtitle ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (widget != null) widget!,
        ],
      ),
    );
  }
}
