import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';

class PickerDialogStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
  });
}

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final bool isCountryPicker;

  CountryPickerDialog({
    Key? key,
    required this.searchText,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    required this.isCountryPicker,
    this.style,
  }) : super(key: key);

  @override
  _CountryPickerDialogState createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;
  final focusNode = FocusNode();

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries;
    if (!focusNode.hasFocus) focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: widget.style?.backgroundColor ?? Theme.of(context).dialogBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: widget.style?.padding ?? EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredCountries.length,
                    itemBuilder: (ctx, index) => Column(
                      children: <Widget>[
                        ListTile(
                          dense: true,
                          leading: Image.asset(
                            'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
                            package: 'intl_phone_field',
                            width: 32,
                          ),
                          // contentPadding: widget.style?.listTilePadding ?? EdgeInsets.symmetric(vertical: 5),
                          title: Text(
                            _filteredCountries[index].name,
                            // style: widget.style?.countryNameStyle ?? TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: (widget.isCountryPicker)
                              ? null
                              : Text(
                                  '+${_filteredCountries[index].dialCode}',
                                  style: widget.style?.countryCodeStyle ?? TextStyle(fontWeight: FontWeight.w700),
                                ),
                          onTap: () {
                            _selectedCountry = _filteredCountries[index];
                            widget.onCountryChanged(_selectedCountry);
                            Navigator.of(context).pop();
                          },
                        ),
                        widget.style?.listTileDivider ?? Divider(thickness: 1),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: widget.style?.searchFieldPadding ?? EdgeInsets.all(0),
                  child: TextField(
                    focusNode: focusNode,
                    cursorColor: widget.style?.searchFieldCursorColor,
                    decoration: widget.style?.searchFieldInputDecoration ??
                        InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          labelText: widget.searchText,
                        ),
                    onChanged: (value) {
                      _filteredCountries = isNumeric(value)
                          ? widget.countryList.where((country) => country.dialCode.contains(value)).toList()
                          : widget.countryList.where((country) => country.name.toLowerCase().contains(value.toLowerCase())).toList();
                      if (this.mounted) setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
