import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart'
    show LicenseEntry, LicenseParagraph, LicenseRegistry;

/// Displays an [ArnaLicensePage], which shows licenses for software used by the application.
///
/// The application arguments correspond to the properties on [ArnaLicensePage].
///
/// The [context] argument is used to look up the [Navigator] for the page.
///
/// The [useRootNavigator] argument is used to determine whether to push the page to the [Navigator] furthest from or
/// nearest to the given [context]. It is `false` by default.
///
/// The licenses shown on the [ArnaLicensePage] are those returned by the [LicenseRegistry] API, which can be used to
/// add more licenses to the list.
void showArnaLicensePage({
  required final BuildContext context,
  final bool useRootNavigator = false,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator).push(
    ArnaPageRoute<void>(
      builder: (final BuildContext context) => const ArnaLicensePage(),
    ),
  );
}

/// A page that shows licenses for software used by the application.
///
/// To show an [ArnaLicensePage], use [showArnaLicensePage].
///
/// The licenses shown on the [ArnaLicensePage] are those returned by the [LicenseRegistry] API, which can be used to
/// add more licenses to the list.
class ArnaLicensePage extends StatelessWidget {
  /// Creates a page that shows licenses for software used by the application.
  ///
  /// The licenses shown on the [ArnaLicensePage] are those returned by the [LicenseRegistry] API, which can be used to
  /// add more licenses to the list.
  const ArnaLicensePage({super.key});

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<_LicenseData>(
      future: LicenseRegistry.licenses
          .fold<_LicenseData>(
            _LicenseData(),
            (final _LicenseData prev, final LicenseEntry license) =>
                prev..addLicense(license),
          )
          .then(
            (final _LicenseData licenseData) => licenseData..sortPackages(),
          ),
      builder: (
        final BuildContext context,
        final AsyncSnapshot<_LicenseData> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data!.packages.isEmpty) {
              return const SizedBox.shrink();
            }
            return ArnaMasterDetailScaffold(
              title: MaterialLocalizations.of(context).licensesPageTitle,
              headerBarLeading: ArnaBackButton(
                onPressed: () => Navigator.pop(context),
              ),
              items: <MasterNavigationItem>[
                ...snapshot.data!.packages
                    .asMap()
                    .entries
                    .map<MasterNavigationItem>(
                        (final MapEntry<int, String> entry) {
                  final String packageName = entry.value;
                  final List<int> bindings =
                      snapshot.data!.packageLicenseBindings[packageName]!;

                  final Iterable<LicenseParagraph> paragraphs = bindings
                      .map((final int i) => snapshot.data!.licenses[i])
                      .toList(growable: false)
                      .first
                      .paragraphs;
                  final List<Widget> details = <Widget>[];

                  for (final LicenseParagraph paragraph in paragraphs) {
                    details.add(
                      Padding(
                        padding: Styles.large,
                        child: Text(
                          paragraph.text,
                          style: ArnaTheme.of(context).textTheme.body,
                          maxLines: 100,
                        ),
                      ),
                    );
                  }

                  return MasterNavigationItem(
                    leading: const Icon(Icons.info_outline),
                    title: packageName,
                    subtitle: MaterialLocalizations.of(context)
                        .licensesPackageDetailText(bindings.length),
                    builder: (final _) => ListView(children: details),
                  );
                }),
              ],
            );
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return DecoratedBox(
              decoration: BoxDecoration(
                color: ArnaColors.backgroundColor.resolveFrom(context),
              ),
              child: const Center(child: ArnaProgressIndicator()),
            );
        }
      },
    );
  }
}

/// This is a collection of licenses and the packages to which they apply.
/// [packageLicenseBindings] records the m+:n+ relationship between the license and packages as a map of package names
/// to license indexes.
class _LicenseData {
  final List<LicenseEntry> licenses = <LicenseEntry>[];
  final Map<String, List<int>> packageLicenseBindings = <String, List<int>>{};
  final List<String> packages = <String>[];

  // Special treatment for the first package since it should be the package for delivered application.
  String? firstPackage;

  /// Add the license.
  void addLicense(final LicenseEntry entry) {
    // Before the license can be added, we must first record the packages to which it belongs.
    for (final String package in entry.packages) {
      _addPackage(package);
      // Bind this license to the package using the next index value. This creates a contract that this license must be
      // inserted at this same index value.
      packageLicenseBindings[package]!.add(licenses.length);
    }
    licenses.add(entry); // Completion of the contract above.
  }

  /// Add a package and initialize package license binding. This is a no-op if the package has been seen before.
  void _addPackage(final String package) {
    if (!packageLicenseBindings.containsKey(package)) {
      packageLicenseBindings[package] = <int>[];
      firstPackage ??= package;
      packages.add(package);
    }
  }

  /// Sort the packages using some comparison method, or by the default manner, which is to put the application package
  /// first, followed by every other package in case-insensitive alphabetical order.
  void sortPackages([final int Function(String a, String b)? compare]) {
    packages.sort(
      compare ??
          (final String a, final String b) {
            // Based on how LicenseRegistry currently behaves, the first package returned is the end user application
            // license. This should be presented first in the list. So here we make sure that first package remains at
            // the front regardless of alphabetical sorting.
            if (a == firstPackage) {
              return -1;
            }
            if (b == firstPackage) {
              return 1;
            }
            return a.toLowerCase().compareTo(b.toLowerCase());
          },
    );
  }
}
