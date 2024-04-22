import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/services/configs_service.dart';

class ButtonSwitchBrightness extends StatelessWidget {
  const ButtonSwitchBrightness({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigsService configsProvider =
        Provider.of<ConfigsService>(context, listen: true);
    return IconButton(
      onPressed: configsProvider.invertDarkMode,
      icon: Icon(
        configsProvider.isDark
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}
