import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List currencies;

  HomePage({
    this.currencies,
});
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List currencies;
  final List<MaterialColor> _colors = [Colors.blue, Colors.red, Colors.deepOrange];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Borring Cryptomaniac",
        ),
        elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0: 0.5,
      ),
      body: _cryptoWidget(),
    );
  }

  Widget _cryptoWidget() {
    return new Container(
      child: Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              itemCount: widget.currencies.length,
              itemBuilder: (BuildContext context, int i) {
                  final Map currency = widget.currencies[i];
                  final MaterialColor color = _colors[i % _colors.length];

                  return _getListItemUI(currency, color);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  ListTile _getListItemUI(Map currency, MaterialColor color) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        child: new Text(currency['name'][0]),
      ),
      title: new Text(currency["name"], style: new TextStyle(fontWeight: FontWeight.bold),),
      subtitle: _getSubtitleText(currency["price_usd"], currency["percent_change_1h"]),
      isThreeLine: true,
    );
  }

  Widget _getSubtitleText(String priceUSD, String percentageChange){
    TextSpan priceTextWidget = new TextSpan(text: "\$$priceUSD\n", style: new TextStyle(color: Colors.black87));

    String porcentageChangeText = "1 hour: $percentageChange%";
    TextSpan percentageChangeTextWidget;

    if (double.parse(percentageChange) > 0){
      percentageChangeTextWidget = new TextSpan(text: porcentageChangeText,
      style: new TextStyle(color: Colors.green));
    } else {
      percentageChangeTextWidget = new TextSpan(text: porcentageChangeText,
          style: new TextStyle(color: Colors.redAccent));
    }

    return new RichText(
        text: new TextSpan(
          children: [priceTextWidget, percentageChangeTextWidget],
        )
    );
  }

}
