import 'package:financemanager/components/buttons/custom_action_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? actionButtonText;
  final VoidCallback? actionButtonOnPressed;
  final Widget? appBarButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actionButtonText,
    this.actionButtonOnPressed,
    this.appBarButton,
  }) : super(key: key);

  List<Widget>? actions() {
    if (actionButtonText != null && actionButtonOnPressed != null) {
      return [Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CustomActionButton(
            actionButtonText: actionButtonText!,
            actionButtonOnPressed: actionButtonOnPressed!,
            gradientColors: const [
              Color(0xFF00B686),
              Color(0xFF008A60),
              Color(0xff00573a),
            ],
          ))
      ];
    } else if (appBarButton != null) {
      return [Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: appBarButton!,
      )
      ];
    } else {
      return [const SizedBox()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color.fromRGBO(16, 19, 37, 1),
        leading: IconButton(
          icon: const Icon(Icons.notes, color: Colors.grey, size: 35),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: actions()
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
