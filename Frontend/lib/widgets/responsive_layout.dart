import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.tabletBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= AppConstants.mobileBreakpoint) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    DeviceType deviceType,
  )
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DeviceType deviceType;
        if (constraints.maxWidth >= AppConstants.tabletBreakpoint) {
          deviceType = DeviceType.desktop;
        } else if (constraints.maxWidth >= AppConstants.mobileBreakpoint) {
          deviceType = DeviceType.tablet;
        } else {
          deviceType = DeviceType.mobile;
        }

        return builder(context, constraints, deviceType);
      },
    );
  }
}

enum DeviceType { mobile, tablet, desktop }

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsivePadding =
            padding ?? AppConstants.getResponsivePadding(constraints.maxWidth);
        final containerMaxWidth =
            maxWidth ??
            (constraints.maxWidth > 1200 ? 1200 : constraints.maxWidth);

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: containerMaxWidth),
          padding: responsivePadding,
          child: child,
        );
      },
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? forceColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.forceColumns,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            forceColumns ??
            AppConstants.getResponsiveColumns(constraints.maxWidth);

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            final itemWidth =
                (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            return SizedBox(width: itemWidth, child: child);
          }).toList(),
        );
      },
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double? elevation;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardPadding =
            padding ??
            EdgeInsets.all(
              constraints.maxWidth < AppConstants.mobileBreakpoint ? 12 : 16,
            );

        return Card(
          color: color,
          elevation: elevation,
          child: Padding(padding: cardPadding, child: child),
        );
      },
    );
  }
}
