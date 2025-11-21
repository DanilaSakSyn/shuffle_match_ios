import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_info.dart';
import '../models/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    AppSettings.instance.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF3B0A21),
      child: Container(
        color: const Color(0xFF3B0A21),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _SettingsSection(
                        title: 'General',
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: AppSettings.instance.soundsEnabled,
                            builder: (context, soundsEnabled, _) {
                              return _SettingsSwitchRow(
                                label: 'Sounds',
                                value: soundsEnabled,
                                onChanged: (value) {
                                  AppSettings.instance.setSoundsEnabled(value);
                                },
                              );
                            },
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable:
                                AppSettings.instance.hapticsEnabled,
                            builder: (context, hapticsEnabled, _) {
                              return _SettingsSwitchRow(
                                label: 'Haptics',
                                value: hapticsEnabled,
                                onChanged: (value) {
                                  AppSettings.instance.setHapticsEnabled(value);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _SettingsSection(
                        title: 'Privacy',
                        children: [
                          _SettingsNavigationRow(
                            label: 'Privacy Policy',
                            onPressed: () async {
                              await launchUrl(
                                Uri.parse(AppInfo.privacyPolicyUrl),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _SettingsSection(
                        title: 'About',
                        children: [
                          _SettingsInfoRow(
                            label: 'App Name',
                            value: AppInfo.appName,
                          ),
                          _SettingsInfoRow(
                            label: 'Version',
                            value: AppInfo.fullVersion,
                          ),
                          if (AppInfo.appDescription.isNotEmpty)
                            _SettingsInfoRow(
                              label: 'Description',
                              value: AppInfo.appDescription,
                            ),
                          _SettingsInfoRow(
                            label: 'Developer',
                            value: AppInfo.developerName,
                          ),
                          if (AppInfo.developerEmail.isNotEmpty)
                            _SettingsInfoRow(
                              label: 'Email',
                              value: AppInfo.developerEmail,
                              isClickable: true,
                              onTap: () async {
                                final uri = Uri.parse(
                                  'mailto:${AppInfo.developerEmail}',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                            ),
                          if (AppInfo.developerWebsite != null &&
                              AppInfo.developerWebsite!.isNotEmpty)
                            _SettingsInfoRow(
                              label: 'Website',
                              value: AppInfo.developerWebsite!,
                              isClickable: true,
                              onTap: () async {
                                final uri = Uri.parse(
                                  AppInfo.developerWebsite!,
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                            ),
                          _SettingsInfoRow(
                            label: 'Copyright',
                            value:
                                '© ${AppInfo.copyrightYear} ${AppInfo.developerName}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22FF8A38),
                blurRadius: 20,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++)
                Column(
                  children: [
                    if (i != 0)
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    children[i],
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF8A38),
            trackColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}

class _SettingsNavigationRow extends StatelessWidget {
  const _SettingsNavigationRow({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      onPressed: onPressed,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            CupertinoIcons.chevron_forward,
            color: Colors.white.withOpacity(0.5),
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _SettingsInfoRow extends StatelessWidget {
  const _SettingsInfoRow({
    required this.label,
    required this.value,
    this.isClickable = false,
    this.onTap,
  });

  final String label;
  final String value;
  final bool isClickable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isClickable
                    ? const Color(0xFFFF8A38)
                    : Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );

    if (isClickable && onTap != null) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: content,
      );
    }

    return content;
  }
}
