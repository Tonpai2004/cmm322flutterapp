import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../controllers/question_controller.dart';

class OptionQuiz extends StatelessWidget {
  final String text;
  final int index;
  final VoidCallback press;

  const OptionQuiz({
    super.key,
    required this.text,
    required this.index,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      init: QuestionController(),
      builder: (controller) {
        Color getTheRightColor() {
          if (controller.isAnswered) {
            if (index == controller.correctAns) {
              return kLightPrimaryColor;
            } else if (index == controller.selectedAns &&
                controller.selectedAns != controller.correctAns) {
              return kRedColor;
            }
          }
          return kDarkPrimaryColor;
        }

        IconData getTheRightIcon() {
          return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
        }

        return GestureDetector(
          onTap: press,
          child: Container(
            margin: EdgeInsets.only(top: kPadding),
            padding: EdgeInsets.all(kPadding),
            decoration: BoxDecoration(
              color: getTheRightColor(), // เปลี่ยนสีของ Container ตามคำตอบ
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: getTheRightColor()),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${index + 1}. $text",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color:
                        getTheRightColor() == kDarkPrimaryColor
                            ? Colors.transparent
                            : getTheRightColor(),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: getTheRightColor()),
                  ),
                  child:
                      getTheRightColor() == kDarkPrimaryColor
                          ? null
                          : Icon(
                            getTheRightIcon(),
                            size: 20,
                            color: Colors.white,
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
