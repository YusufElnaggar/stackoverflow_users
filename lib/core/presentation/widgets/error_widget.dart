import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../gen/assets.gen.dart';

class ErrorTextWidget extends StatelessWidget {
  final String errorMassage;
  final AsyncCallback function;
  const ErrorTextWidget(
      {super.key, required this.errorMassage, required this.function});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.images.error.path,
            height: SizerUtil.width * 0.75,
            width: SizerUtil.width * 0.75,
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            errorMassage,
            maxLines: 2,
            softWrap: true,
            minFontSize: 10,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: function,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
