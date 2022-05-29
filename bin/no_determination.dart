import 'dart:io';

import 'package:no_determination/no_determination.dart' as no_determination;
import 'package:args/args.dart';

var websites = <String>[
  "instagram.com",
  "pornhub.com",
  "xvideos.com",
  "thatpervert.com",
  "nhentai.net",
];

Future<void> main(List<String> arguments) async {
  final parser = ArgParser();

  parser.addOption(
    "websites",
    help: "Additional websites to block (besides the defaults.)",
    abbr: 'w',
    valueHelp: "String of websites separated by spaces.",
    defaultsTo: '',
  );

  parser.addOption(
    "hosts",
    help: "Path to the hosts file you wish to monitor.",
    abbr: 'f',
    valueHelp: "filepath",
    defaultsTo: "/etc/hosts",
  );

  parser.addOption(
    "redirect",
    help: "Where to redirect requests for porn websites to.",
    abbr: 'r',
    valueHelp: "URL",
    defaultsTo: "127.0.0.1",
  );

  parser.addFlag(
    "help",
    help: "Display usage options.",
    abbr: 'h',
  );

  var args = parser.parse(arguments);

  if (args['help'] == true) {
    print(parser.usage);
    return;
  }

  if (args['websites'] != null) {
    websites.addAll(args['websites'].split(' '));
  }

  final hostsPath = Platform.isWindows
      ? r"C:\Windows\System32\drivers\etc\hosts"
      : args['hosts'];

  await no_determination.updateHosts(
    websites,
    hostsPath: hostsPath,
    redirectTo: args['redirect'],
  );

  while (true) {
    final inGoodBehavior = await no_determination.checkViolations(
      websites,
      hostsPath: hostsPath,
      redirectTo: args['redirect'],
    );

    if (inGoodBehavior == false) {
      await no_determination.updateHosts(
        websites,
        hostsPath: hostsPath,
        redirectTo: args['redirect'],
      );

      no_determination.restartComputer();
    }

    sleep(const Duration(minutes: 5));
  }
}
