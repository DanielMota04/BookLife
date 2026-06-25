import 'package:book_life/features/settings/models/app_info.dart';
import 'package:book_life/features/settings/viewmodels/about_viewmodel.dart';
import 'package:flutter/material.dart';

class LicensesSection extends StatelessWidget {
  final AppInfo? _appInfo;
  final AboutViewModel _viewModel;

  const LicensesSection(this._appInfo, this._viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.description),
      title: const Text('Licenças'),
      enabled: _appInfo != null,
      onTap: () {
        if (_appInfo == null) return;
        _viewModel.openLicenses(context, _appInfo);
      },
    );
  }
}
