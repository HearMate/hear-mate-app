part of '../echo_parse_home_page.dart';

class _NavigationBar extends StatelessWidget {
  final EchoParseState state;

  const _NavigationBar({required this.state});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.save), label: 'Saved files'),
      ],
      selectedIndex: state.navigationDestinationSelected,
      onDestinationSelected: (index) {
        context.read<EchoParseBloc>().add(
              EchoParseNavigationDestinationSelected(destination: index),
            );
      },
    );
  }
}