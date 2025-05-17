import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/modules/echo_parse/blocs/echo_parse_bloc.dart';
import 'package:hear_mate_app/widgets/hm_app_bar.dart';

class EchoParseSavedFilesPage extends StatelessWidget {
  const EchoParseSavedFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HMAppBar(
        route: ModalRoute.of(context)?.settings.name ?? "",
        title: "Saved files",
      ),
      bottomNavigationBar: BlocBuilder<EchoParseBloc, EchoParseState>(builder: (context, state) {
        return NavigationBar(destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.save), label: 'Saved files')
        ],
        selectedIndex: state.navigationDestinationSelected,
        onDestinationSelected: (destination) {
          context.read<EchoParseBloc>().add(EchoParseNavigationDestinationSelected(destination: destination));
          Navigator.pushReplacementNamed(context, '/echo_parse/saved_files');
        });
      }),
      body: BlocBuilder<EchoParseBloc, EchoParseState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: Column(
                  children: [
                    
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
