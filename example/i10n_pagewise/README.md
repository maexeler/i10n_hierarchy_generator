# i10n Pagewise

Shows how to use the i10n_hierarchy_generator to localize a Flutter application.

Only three languages are supported, english (en), german (de) and a
country specific version of german (de_CH).

## Translation Layout
You can find all files in the package [res/translations/](res/translations/)

The file [messages.arb](res/translations/messages.arb) contains the main translation.
Since I decided to used english as the default language for the main translation,
[messages_en.arb](res/translations/messages_en.arb) contains only an empty object.
[messages_de.arb](res/translations/messages_de.arb) contains the german translation
for all keys in messages_en.arb.
[messages_de_CH.arb](res/translations/messages_de.arb) contains only a single
redefinition for the 'quote' key.

You can find the generated code in the file [lib/src/generated/i10n_hierarchy.dart](lib/src/generated/i10n_hierarchy.dart)

## Example Code
You should open main.dart and search for the therm **// i10n** to see all the relevant code.

### Playing around with the example
The Android emulator contains the app **Custom Locale** which let you switch the
actual locale for the device.

Try **en** and **de** to see how the translated strings change.

## Modifying the example
You should read the README.md from the **i10n_hierarchy_generator** package to see
what types of translations exists.

For example, you can
- modify values in any messages file
- add key/value pairs to the messages.arb file and redefine them in the language files
- or add a whole new language file

In either of this cases, you have to rebuild the generated output class.

To do that, open a terminal and enter the following command:

    flutter packages pub run i10n_hierarchy_generator

for a one time compilation,

or

    flutter packages pub run i10n_hierarchy_generator --watch

to recompile the messages files on every change.
Type an **x** in the terminal to stop watching.

If Flutters **hot reload** does not show your changes, try **hot restart**, if not even
this helps, try a cold restart.