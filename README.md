# i10n_hierarchy_generator

## What is it?
**i10n_generator** is a **command-line app** which helps in translateing
 a Flutter application in an easy, structured and time proven way.  

 It reads key/value pairs from
 Json message files and generates a class helping you to
 translate your Flutter application.  
 The Json structure may be hierarchical.  
 You can group your translations by page or topic or whatever you like.  
 The generated class helps you to find your translation by using code completion.

#### Why I wrote it?
Localization of an application is not the funnies part of programming.  
Since I live in Switzerland an we have four official languages here, I did
a lot of localization in my life. IMHO, the official Flutter way to localize
an application is much to complicated.  
So I wrote my own solution.  
Give it a try. I don't think you will be disappointed.


#### What isn't it?
**i10n_generator** is not a full internationalization package. It supports
only the translation of strings and to some extend the orientation of the translated strings.

It is is a command line application and not a plugin.


## Credits
I have stolen the idea and some code from
[flutter_i18n](https://github.com/long1eu/flutter_i18n).  
Thanks a lot Razvan

## The big picture
Imagine a class hierarchy in OOP. The top level class defines all the available
properties and subclasses can redefine them. Note that a property may contain another
class which may have properties too.

Now you have the big picture :smiley:

The file **messages.arb** is the top level class.  
It contains key/value pairs. A key is always a string. A value may be a
string or another object which consists of key/value pairs.  
**.arb** files have to satisfy the requirement of the Json syntax.

You can override key/value pairs by adding **messages_xx.arb** files which
redefine some or all values from the **messages.arb** file.

### An opiniated view of i10n
**messages.arb** contains what I call the **default translation**. You can choose
any language you like for the default translation. English may be a good choice.

Since Flutter knows nothing about a default language, you have to to tell
Flutter what you did.

Say you opted for english as your default language. The locale
designator for english is **en**. So you have to add the file **messages_en.arb**
which consists of nothing but an empty object.

Now you opt to support another language (which you would, wouldn't you?)  
Add a new messages file which has the proper locale designator appended to
its name. Copy the contents of the default language into it and re translate all values.
Repeat this process until your done with all supported languages.
(That's a fancy job for a programmer, isn't it? :innocent:)

## Quick, how do I use it?

- Create a new Flutter project
- Add **flutter_localizations: sdk: flutter** to the dependencies in your **pubspec.yaml** file.
- Add **i10n_hierarchy_generator** to the dev_dependencies in your **pubspec.yaml** file.
- Open a terminal and run ``flutter packages pub run i10n_hierarchy_generator`` in it.  
You get the file **messages.arb** in the package **res/translations** and the file **i10n_hierarchy.dart** in the package **lib/src/generated**

- Open **messages.arb** and add the following content:
```
    {
      "appTitle": "I10n Demo"
    }
```

- Create the file **messages_en.arb** with the content:
```
    {
      "@@isDefaultLanguage": ""
    }
```

- Now open main.dart and modify your MaterialApp:

<pre style="margin-left: 0px;">

<b>// i10n : import the generated localisation class and the flutter support package
import './src/generated/i10n_hierarchy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';</b>

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      <b>// i10n : Prepare App for localization by inserting the following code
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: S.delegate.resolution(),

      // i10n : Use onGenerateTitle: instead of title:
      onGenerateTitle: (context) => S.of(context).appTitle,</b>

      home: StartPage(),
      theme: ThemeData(primarySwatch: Colors.blue,)
    );
  }
}
</pre>

- Rerun ``flutter packages pub run i10n_hierarchy_generator``  in the terminal
- Start an Emulator and watch the Result

Note the use of **S.of(context)** in the onGenerateTitle builder function.
S is the name of the generated translation class, S.of(context) gives you an
instance for the translation.
**S.of(context).appTitle** gives you the actual translation (a String) for the app title.

You should study the code and the README.md given in the example directory for a more elaborated example.

## Ah OK, but translations of key/value pairs only - that looks a little bit meager
Yep, you're right. But there are several kinds of key/value pairs:

### Simple translations
Simple translations are exactly that, mapping from a key to a translation.  
Simple translations are converted to a getter.
```
    .arb
        "appTitle": "I10n Demo",
    
    .dart
        String get appTitle => 'I10n Demo';
```
### Parametrized translations
Parametrized translations allows you to insert placeholders (parameters)
into your value string.  
Parameters are identifiers inside braces preceded by a $ sign.  
Parametrized translations are converted to functions with parameters.
```
    .arb
        "counter": "You clicked ${count} times",
    
    .dart
        String counter({@required dynamic count}) => 'You clicked ${count} times';
        
    usage:
        S.of(context).counter(1);    
```
You can pass anything as a parameter value and you can use it as you like.  
If the type of the provided parameter does not match at runtime an error is thrown.
```
    .arb
        "today": "It is ${date.month} : ${date.day}",
    
    .dart
        String today({@required dynamic date}) => 'It is ${date.month} : ${date.day}';
```
Note: Dollar signs without braces are just $ signs.

### Plural translations
Plural translations provide keys for quantities.
To define a plural translation you need at least one key which ends with 'Other'.  
You can then provide additional quantities by defining key/value pairs with
the same key, suffixed by one of the following identifiers:
- Zero, One, Two, Few, Many

The corresponding parameter values are:
- 0, 1, 2, 'few', 'many' or 'other'.

Any other value defaults to 'other'
```
    .arb
        "clickZero" : "Are you afraid to click the button?",
        "clickOne"  : "You clicked once",
        "clickTwo"  : "You clicked twice",
        "clickOther": "Clicking is fun, isn't it?"
    
    .dart
        /// - selector in [0, 1, 2, other]
        String click(dynamic selector, ) {
            switch (selector.toString()) {
              case '0': return 'Are you afraid to click the button?';
              case '1': return 'You clicked once';
              case '2': return 'You clicked twice';
              default: return 'Clicking is fun, isn\'t it?';
            }
        }
        
    usage:
        S.of(context).click(1);
        S.of(context).click('many'); // triggers the default case here    
```
Note: Plural translations have a generated documentation which shows the valid parameter values.

Plural translations may have parameters too:
```
    .arb
        "clickZero" : "You haven\'t clicked the button yet",
        "clickOne"  : "You clicked once",
        "clickOther": "You clicked it ${count} times."
    
    .dart
        /// - selector in [0, 1, other], parameters : {count}
        String click(dynamic selector, {dynamic count}) {
            switch (selector.toString()) {
              case '0': return 'You haven\'t clicked the button yet';
              case '1': return 'You clicked once';
              default: return 'You clicked it ${count} times';
            }
        }
        
    usage:
        int counter = ...;
        S.of(context).click(counter, count: counter);
```

### Gender translations
Nothing new here. Gender translations are plural translations with the suffix:
- Male, Female, Other

The corresponding parameter values are:
- 'male', 'female' or 'other'.

### Compound translations
Compound translation let us define key/value pairs in which the value parts contains
further key/value pairs.

This enables us to define hierarchical translations.
Hierarchical translations enables us to group the translations by page or
by topic. And we can reuse keys too.

Let's make an example:

<pre style="margin-left: 0px;">
    arb:
        {
            "appTitle": "I10n Demo",

            "startPage": {
                "title": "Start Page",
            },

            "overviewPage": {
                "title": "Overview Page",
            }
        }

    dart:
        class S implements WidgetsLocalizations {
            ...
            String get <b>appTitle</b> => 'I10n Demo';

            final $defLang_StartPage <b>startPage</b> = $defLang_StartPage();
            final $defLang_OverviewPage <b>overviewPage</b> = $defLang_OverviewPage();
        }

        class $defLang_StartPage {
            String get <b>title</b> => 'Start Page';
        }

        class $defLang_OverviewPage {
            String get <b>title</b> => 'Start Page';
        }

    usage:
        S.of(context).appTitle;
        S.of(context).startPage.title;

</pre>

Man I like that. Compound translation are the reason why I wrote this package :smile:





## Oh that's nice, anything else?

### Meta information
If you start a key with two @ sings, the key/value pair is interpreted as
a meta information.  
At the time being, there are meta keys for the **text direction** and the **default language**.

#### Text direction:
- **@@textDirectionLtr** (left to right)
- **@@textDirectionRtl** (right to left)

You may use them to redefine the text direction for your language.  
If you use none of them,**TextDirection.ltr** is used in the S class and
your language subclasses will inherit that.
```
     .arb
        "@@textDirectionRtl": "",

    .dart
        @override TextDirection get textDirection => TextDirection.rtl;
```

#### Default language:
- **@@isDefaultLanguage**

The language file containing this annotation announces that it contains
the translations for all languages not defined by you.

If your default message file contains translation for the english language,
add a file **messages_en.arb** and fill in the following content:
```
  {
    "@@isDefaultLanguage": ""
  }
```
Note: Any messages_xx.arb file can carry this annotation. But you should not
add it to more then one file.

Flutter will only honer your request if you put the line
```
    localeResolutionCallback: S.delegate.resolution(),
```
in your MaterialApp.

### Comments
Comments may be used to clarify what a translation means or to describe
parameters of a translation.

Comments start wit a single @ sign at the beginning of the key.  
Comments belong to the key/value pairs with corresponding keys.  
Comments without a corresponding key/value pair are discarded.  
Comments can not contain new line characters.  
The value part of a comment is written literally as Dart comment before
the translation.
```
    .arb
        "@appTitle": "The application title",
        "appTitle": "I10n Demo",
    
    .dart
        /// The application title
        String get appTitle => 'I10n Demo';    
```

#### Having more than one comment for a key
Since the Json parser eats up redundant key/value pairs, you must use
distinct comment keys if you want to have more than one comment for a key.  
Prepend the key with an underscore and an unique identifier.
```
    .arb
        "@appTitle_1": "The application title",
        "@appTitle_2": "Only shown when the application is suspended",    
        "appTitle": "I10n Demo",
    
    .dart
        /// The application title
        /// Only shown when the application is suspended  
        String get appTitle => 'I10n Demo';    
```

## Tips and Tricks
As I said earlier, localization of an application is not the funnies part of programming.  
Since I live in Switzerland an we have four official languages here, I did a lot of localization in my life.

So, what's the best way to do that?

1. Begin with the default message file only.
2. Never translate it to an other language before you finished the application.
3. Whenever you need a language dependent string, add its definition instantly to the message file, regenerate the translation class S and use the new property in your code.  
Choose the names for your keys carefully. It is not fun to refactor all your message files later on.
4. When you are done with the application, create the message files for each needed language. Copy the content of the default message file into them und send them to your customer for translation.  
Do not translate them by yourself. You don't want to have the burden of maintaining all translations for the rest of your life.
5. If you have to add translations later on (and you will), add the new key/value pairs instantly to **all** language files. Mark the new values in some way as 'not yet translated'.
6. Send them to your customer for re translation. Establish an easy and secure way, to get the translated files back.  
By the way, inform your customer that he must never translate a key which starts wit an @ sign.

## A command line application. How do I tame that beast?
Using the code generator is easy. Open a terminal and type:
```
    flutter packages pub run i10n_hierarchy_generator
```
The first time you use it it will generate all the necessary packages and files for you.
With each subsequent call, the message files are read and the translation class is regenerated.

A useful feature is --watch.
```
    flutter packages pub run i10n_hierarchy_generator --watch
```
Watch listens for file changes und regenerates the translation class on every change of a message file.  
To stop watching, type an **x** in the terminal.

You can change the source and destination packages too. Run
```
    flutter packages pub run i10n_hierarchy_generator help
```
to see how to do it.

