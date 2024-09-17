import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginLandingScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int loginFlowIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) => orientation == Orientation.portrait
              ? _body(context)
              : _bodyLandscape(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final assetString = 'assets/svg/canvas-parent-login-logo.svg';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Spacer(),
          SvgPicture.asset(
            assetString,
            semanticsLabel: 'Canvas Logo',
          ),
          Spacer(),
          _filledButton(context, 'Find School', () {}),
          SizedBox(height: 16),
          _outlineButton(context, 'Find Another School', () {}),
          SizedBox(height: 32),
          _qrLogin(context),
          SizedBox(height: 32),
          _previousLogins(context),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _bodyLandscape(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final parentWidth = constraints.maxWidth;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: parentWidth * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  SvgPicture.asset(
                    'assets/svg/canvas-parent-login-logo.svg',
                    semanticsLabel: 'Canvas Logo',
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Container(
            width: min(parentWidth * 0.5, 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                _filledButton(context, 'Find School', () {}),
                SizedBox(height: 16),
                _outlineButton(context, 'Find Another School', () {}),
                SizedBox(height: 16),
                _qrLogin(context),
                SizedBox(height: 16),
                _previousLogins(context),
                Spacer(),
              ],
            ),
          ),
          Spacer(),
        ],
      );
    });
  }

  Widget _filledButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _outlineButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          side: BorderSide(
              width: 1, color: Theme.of(context).colorScheme.primary),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _qrLogin(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset('assets/svg/qr-code.svg'),
            SizedBox(width: 8),
            Text(
              'Login with QR Code',
            ),
          ],
        ),
      ),
    );
  }

  Widget _previousLogins(BuildContext context) {
    final itemHeight = 72.0;
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: double.infinity,
          child: Column(
            key: Key('previous-logins'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Previous Logins',
                ),
              ),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Divider(height: 1),
              ),
              AnimatedContainer(
                curve: Curves.easeInOutBack,
                padding: const EdgeInsets.symmetric(horizontal: 48),
                duration: Duration(milliseconds: 400),
                height: min(itemHeight * 2, itemHeight),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  itemCount: 1, // Placeholder with one previous login
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text('John Doe'),
                      subtitle: Text(
                        'example.domain.com',
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(Icons.clear),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
