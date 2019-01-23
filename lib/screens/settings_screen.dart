import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'package:journal/app.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SettingsList(),
    );
  }
}

class SettingsList extends StatefulWidget {
  @override
  SettingsListState createState() {
    return new SettingsListState();
  }
}

class SettingsListState extends State<SettingsList> {
  @override
  Widget build(BuildContext context) {
    var gitAuthorForm = Form(
      child: TextFormField(
        style: Theme.of(context).textTheme.title,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Who should author the changes?',
          labelText: 'Git Author',
        ),
        validator: (String value) {
          value = value.trim();
          if (value.isEmpty) {
            return 'Please enter a name';
          }
        },
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (String _) {},
        initialValue:
            JournalApp.preferences.getString("gitAuthor") ?? "GitJournal",
      ),
    );

    var gitAuthorEmailForm = Form(
      child: TextFormField(
        style: Theme.of(context).textTheme.title,
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintText: 'Who should author the changes?',
          labelText: 'Git Author Email',
        ),
        validator: (String value) {
          value = value.trim();
          if (value.isEmpty) {
            return 'Please enter an email';
          }
        },
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (String _) {},
        initialValue: JournalApp.preferences.getString("gitAuthorEmail") ??
            "app@gitjournal.io",
      ),
    );

    var listView = ListView(children: <Widget>[
      SettingsHeader("Git Settings"),
      ListTile(title: gitAuthorForm),
      ListTile(title: gitAuthorEmailForm),
      SettingsHeader("Version Info"),
      VersionNumberTile(),
    ]);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: listView,
    );
  }
}

class SettingsHeader extends StatelessWidget {
  final String text;
  SettingsHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline,
      ),
      enabled: false,
    );
  }
}

class VersionNumberTile extends StatefulWidget {
  @override
  VersionNumberTileState createState() {
    return new VersionNumberTileState();
  }
}

class VersionNumberTileState extends State<VersionNumberTile> {
  PackageInfo packageInfo;

  @override
  void initState() {
    super.initState();

    () async {
      PackageInfo info = await PackageInfo.fromPlatform();
      setState(() {
        packageInfo = info;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    var text = "";
    if (packageInfo != null) {
      text = packageInfo.appName +
          " " +
          packageInfo.version +
          "+" +
          packageInfo.buildNumber;

      if (JournalApp.isInDebugMode) {
        text += " (Debug)";
      }
    }

    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.subhead,
        textAlign: TextAlign.left,
      ),
      onTap: () {},
    );
  }
}
