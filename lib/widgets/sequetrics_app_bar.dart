import 'package:flutter/material.dart';

class SequetricsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SequetricsAppBar({
    required this.title,
    this.showBack = false,
    this.showProfile = false,
    super.key,
  });

  final String title;
  final bool showBack;
  final bool showProfile;

  @override
  Size get preferredSize => const Size.fromHeight(112);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://sequetrics.co.uk/wp-content/uploads/2025/03/logo-2.png',
            height: 40,
            errorBuilder: (context, _, __) => const Icon(Icons.radar, size: 40),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        if (showProfile)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
      ],
    );
  }
}



