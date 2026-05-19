import 'package:book_life/features/settings/models/app_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const String _repositoryUrl = 'https://github.com/DanielMota04/BookLife';

class AboutViewModel {
  Future<AppInfo> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(
      appName: info.appName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }

  Future<void> openRepository() async {
    final uri = Uri.parse(_repositoryUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw Exception('Não foi possível abrir o repositório: $_repositoryUrl');
    }
  }

  void openLicenses(BuildContext context, AppInfo info) {
    showLicensePage(
      context: context,
      applicationName: info.appName,
      applicationVersion: info.version,
    );
  }
}
