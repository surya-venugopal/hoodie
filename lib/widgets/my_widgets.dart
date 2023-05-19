import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_action/slide_action.dart';

class MyWidgets {
  static Widget topic(String topic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.black12,
          width: 50,
          height: 3,
        ),
        const SizedBox(width: 20),
        Text(
          topic,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(width: 20),
        Container(
          color: Colors.black12,
          width: 50,
          height: 3,
        )
      ],
    );
  }

  static Widget slideButton(FutureOr<void> Function() action,String text) {
    return SlideAction(
      trackBuilder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black,
          ),
          child: Center(
            child: Text(
              state.isPerformingAction ? "Loading..." : text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
      thumbBuilder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: state.isPerformingAction
                ? const CupertinoActivityIndicator(
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
          ),
        );
      },
      action: action,
    );
  }
}
