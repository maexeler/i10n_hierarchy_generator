///
/// search for '// i10n :' to visit the relevant code
///

import 'package:flutter/material.dart';

// i10n : import the generated localisation class and the flutter support package
import 'package:i10n_pagewise/src/generated/i10n_hierarchy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // i10n : Prepare App for localization by inserting the following code
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: S.delegate.resolution(),

      // i10n : Use onGenerateTitle: instead of title:
      onGenerateTitle: (context) => S.of(context).appTitle,

      home: StartPage(),
      theme: ThemeData(primarySwatch: Colors.purple,), // Your girl friend will like that :-)
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // i10n : Use the actual language for the page
    S i10n = S.of(context);
    Locale actLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${i10n.startPage.title} ($actLocale)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(i10n.startPage.btnOverview),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
                OverviewPage()),
              ),
            ),
            RaisedButton(
              child: Text(i10n.startPage.btnSpecialTranslation),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DirectTranslationPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverviewPage extends StatefulWidget {
  @override _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  int _counter = 0;
  void _incrementCounter() => setState(() { _counter++; });

  @override
  Widget build(BuildContext context) {
    // i10n : Use the actual language for the page
    S i10n = S.of(context);
    Locale actLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${i10n.overviewPage.title} ($actLocale)'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            TranslationWidget(
              description: i10n.overviewPage.simpleTr.dsc,
              value: i10n.overviewPage.simpleTr.tr,
            ),
            TranslationWidget(
              description: i10n.overviewPage.parametrizedTr.dsc,
              value: i10n.overviewPage.parametrizedTr.tr(count: _counter),
            ),
            TranslationWidget(
              description: i10n.overviewPage.pluralTr.dsc,
              value: i10n.overviewPage.pluralTr.tr(_counter),
            ),
            TranslationWidget(
              description: i10n.overviewPage.pluralParamTr.dsc,
                value: i10n.overviewPage.pluralParamTr.tr(_counter, count: _counter),
            ),
            GenderTranslationWidget(),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: i10n.overviewPage.tooltip,
        child: Icon(Icons.add),
      ),
    );
  }
}

class TranslationWidget extends StatelessWidget {
  final String description, value;

  TranslationWidget({this.description, this.value});

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(
      title: Text(value),
      subtitle: Text(description),
    ),);
  }
}

class GenderTranslationWidget extends StatefulWidget {
  @override GenderTranslationState createState() => GenderTranslationState();
}

class GenderTranslationState extends State<GenderTranslationWidget> {
  String _gender = 'male';
  set gender(String value) => setState(() { _gender = value; });

  @override
  Widget build(BuildContext context) {
    // i10n : Use the actual language for the page
    S i10n = S.of(context);
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(i10n.overviewPage.genderTr.tr(_gender)),
            subtitle: Text(i10n.overviewPage.genderTr.dsc),
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('Male'),
                onPressed: () => gender = 'male',
              ),
              FlatButton(
                child: Text('Female'),
                onPressed: () => gender = 'female',
              ),
              FlatButton(
                child: Text('Other'),
                onPressed: () => gender = 'other',
              ),
            ]
          ),
        ],
      ),
    );
  }
}

class DirectTranslationPage extends StatefulWidget {
  @override DirectTranslationState createState() => DirectTranslationState();
}

class DirectTranslationState extends State<DirectTranslationPage> {
  // i10n : Start the quote language with the current language
  S languageForQuote = S.current;

  // i10n : Set the quote language
  setInternalLanguage(String language) {
    setState(() { languageForQuote = S.forLanguage(language); });
  }

  @override
  Widget build(BuildContext context) {
    // i10n : Use the actual language for the page
    S i10n = S.of(context);
    Locale actLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${i10n.directTranslPage.title} ($actLocale)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text(
              // i10n : use the quote language here
              languageForQuote.directTranslPage.quote,
              style: Theme.of(context).textTheme.headline5
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(i10n.directTranslPage.de),
                  onPressed: () => setInternalLanguage('de'),
                ),
                SizedBox(width: 10),
                RaisedButton(
                  child: Text(i10n.directTranslPage.de_CH),
                  onPressed: () => setInternalLanguage('de_CH'),
                ),
                SizedBox(width: 10),
                RaisedButton(
                  child: Text(i10n.directTranslPage.en),
                  onPressed: () => setInternalLanguage('en'),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

}