import 'package:flutter/material.dart';

class EmailVerificationSentPage extends StatelessWidget {
  final String email;

  const EmailVerificationSentPage({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bandera de Ecuador + email icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFD100),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF003893).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(color: const Color(0xFFFFD100)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(color: const Color(0xFF003893)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(color: const Color(0xFFEF3340)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mark_email_unread_rounded,
                        size: 28,
                        color: const Color(0xFF003893),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Título
                Text(
                  '¡Revisa tu correo!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF003893),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Mensaje
                Text(
                  'Hemos enviado un enlace de verificación a:',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Email
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    email,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Instrucciones
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD100).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFD100).withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF003893),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Debes confirmar tu correo electrónico para poder iniciar sesión en la aplicación.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF003893),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Pasos
                _buildStep(
                  context,
                  number: '1',
                  text: 'Abre tu bandeja de entrada',
                  icon: Icons.inbox_rounded,
                ),
                const SizedBox(height: 12),
                _buildStep(
                  context,
                  number: '2',
                  text: 'Busca el correo de Elecciones Ecuador',
                  icon: Icons.search_rounded,
                ),
                const SizedBox(height: 12),
                _buildStep(
                  context,
                  number: '3',
                  text: 'Haz clic en el enlace de verificación',
                  icon: Icons.link_rounded,
                ),
                const SizedBox(height: 40),

                // Botón volver al login
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Ir a Iniciar Sesión'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Nota sobre spam
                Text(
                  '¿No encuentras el correo? Revisa tu carpeta de spam.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String number,
    required String text,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          icon,
          color: theme.colorScheme.primary.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
