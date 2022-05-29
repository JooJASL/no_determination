import 'dart:io';

/// Returns False if a violation has been found.
Future<bool> checkViolations(List<String> websitesToBlock,
    {String hostsPath = "/etc/hosts", redirectTo = "127.0.0.1"}) async {
  final hostsFile = File(hostsPath);

  if (await hostsFile.exists() == false) {
    throw StateError("Specified hosts does not exist");
  }

  final fuckMe = await hostsFile.readAsString();

  for (final website in websitesToBlock) {
    if (fuckMe.contains(website) == false) {
      return false;
    }
  }

  return true;
}

Future<void> updateHosts(
  List<String> websitesToBlock, {
  String hostsPath = "/etc/hosts",
  redirectTo = "127.0.0.1",
}) async {
  final file = File(hostsPath);

  if (await file.exists() == false) {
    throw (StateError("Specified hosts does not exist."));
  }

  var assembledString = <String>[];
  for (var website in websitesToBlock) {
    assembledString.add("$redirectTo\t$website\n");
  }

  await file.writeAsString(assembledString.join(),
      mode: FileMode.writeOnlyAppend);
}

void restartComputer(
    {String restartReason = "A change in the hosts file has been detected."}) {
  if (Platform.isWindows) {
    // In order: Restart, Forced (no warning), time, now, reason?, stated reason.
    Process.run("shutdown", ["/r", "/f", "/t", "0" "/c", "\"$restartReason\""]);
  } else {
    Process.run("shutdown", ["-r", "now", "\"$restartReason\""]);
  }
}
