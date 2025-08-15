import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetUserDataEvent());
  }

  String extractFullName(dynamic user) {
    final first =
        (user?.firstName ?? user?.nombres ?? user?.name ?? '').toString();
    final last =
        (user?.lastName ?? user?.apellidos ?? user?.surname ?? '').toString();
    final full = '$first $last'.trim();
    return full.isEmpty ? (user?.email ?? 'Usuario') : full;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        centerTitle: false,
        title: Text(
          'Configuración',
          style: textStyle.titleMedium!.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetInfo) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<AuthBloc>().add(GetUserDataEvent()),
              );
            }

            String displayName = 'Usuario';
            String? avatarUrl;

            if (state is UserInfo) {
              displayName = extractFullName(state.user);
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AuthBloc>().add(GetUserDataEvent());
              },
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  const SizedBox(height: 8),
                  _Header(name: displayName, avatarUrl: avatarUrl),
                  const SizedBox(height: 16),
                  _MenuCard(
                    icon: Icons.shield_outlined,
                    label: 'Seguridad',
                    onTap: () {},
                  ),
                  _MenuCard(
                    icon: Icons.chat_bubble_outline,
                    label: 'Contactenos',
                    onTap: () {},
                  ),
                  _MenuCard(
                    icon: Icons.logout,
                    label: 'Cerrar sesión',
                    destructive: true,
                    onTap: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final String? avatarUrl;

  const _Header({required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
              ? NetworkImage(avatarUrl!)
              : null,
          child: (avatarUrl == null || avatarUrl!.isEmpty)
              ? const Icon(Icons.person, size: 40)
              : null,
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Colors.white;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Icon(icon,
                    size: 22, color: destructive ? Colors.red : Colors.teal),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: destructive ? Colors.red : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
