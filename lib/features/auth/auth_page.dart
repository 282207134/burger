import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../core/validators.dart';
import '../../core/widgets.dart';
import '../../state/app_state.dart';

class AuthPage extends StatefulWidget {
  final String mode;
  const AuthPage({super.key, required this.mode});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(),
      name = TextEditingController(),
      password = TextEditingController(),
      phone = TextEditingController();
  final code = List.generate(4, (_) => TextEditingController());
  final focus = List.generate(4, (_) => FocusNode());
  bool obscured = true, initialized = false;
  String region = 'India +91';
  int seconds = 34;
  Timer? timer;
  String get mode => widget.mode;
  bool get isCode => mode == Routes.verify || mode == Routes.forgot;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initialized) {
      return;
    }
    initialized = true;
    final state = AppScope.of(context);
    email.text = state.email;
    name.text = state.name;
    phone.text = state.phone;
    region = state.region;
    if (isCode) {
      startTimer();
    }
  }

  void startTimer() {
    timer?.cancel();
    seconds = 34;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || seconds <= 0) {
        t.cancel();
        return;
      }
      setState(() => seconds--);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final c in [email, name, password, phone, ...code]) {
      c.dispose();
    }
    for (final f in focus) {
      f.dispose();
    }
    super.dispose();
  }

  Widget field(
    String label,
    TextEditingController controller, {
    bool secret = false,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
      obscureText: secret && obscured,
      keyboardType: keyboard,
      validator: validator ?? Validate.required,
      style: const TextStyle(fontSize: 16),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: secret
            ? IconButton(
                tooltip: obscured ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => obscured = !obscured),
                icon: Icon(
                  obscured ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  size: 20,
                ),
              )
            : null,
      ),
    ),
  );

  void submit() {
    if (!(form.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();
    final state = AppScope.of(context);
    if (mode == Routes.signIn) {
      state.email = email.text.trim();
      state.save();
      go(context, Routes.password);
    }
    if (mode == Routes.password) {
      state.onboarded = true;
      state.save();
      go(context, Routes.home, root: true);
    }
    if (mode == Routes.signUp) {
      state.email = email.text.trim();
      state.name = name.text.trim();
      state.save();
      go(context, Routes.phone);
    }
    if (mode == Routes.phone) {
      state.region = region;
      state.phone = phone.text.trim();
      state.save();
      go(context, Routes.verify);
    }
    if (mode == Routes.notifications) {
      state.save();
      if (state.onboarded) {
        back(context);
      } else {
        go(context, Routes.location);
      }
    }
  }

  void checkCode() {
    if (code.map((c) => c.text).join().length != 4) {
      return;
    }
    if (code.map((c) => c.text).join() != '1234') {
      message(context, 'Use demo verification code 1234');
      return;
    }
    FocusScope.of(context).unfocus();
    if (mode == Routes.forgot) {
      go(context, Routes.changePassword, arguments: true);
    } else {
      go(context, Routes.notifications);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final titles = switch (mode) {
      Routes.signIn => ('Sign In', 'Account'),
      Routes.password => ('Enter', 'Your Credentials'),
      Routes.forgot => ('Forgot', 'Password'),
      Routes.signUp => ('Let’s Create', 'Your Account'),
      Routes.phone => ('Set Phone', 'Number'),
      Routes.verify => ('Enter', 'Verification Code'),
      _ => ('Enable', 'Notification'),
    };
    final button = switch (mode) {
      Routes.signIn => 'Continue',
      Routes.password => 'Sign In',
      Routes.signUp => 'Sign Up',
      Routes.phone => 'Save Number',
      _ => 'Save',
    };
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            child: FoodImage('corner_top', width: 166, height: 213),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: FoodImage('corner_bottom', width: 166, height: 213),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, bounds) => SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: bounds.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Form(
                        key: form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 214,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 70,
                                  top: 54,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      titles.$1,
                                      style: const TextStyle(
                                        color: Brand.yellow,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      titles.$2,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    if (mode == Routes.signIn)
                                      GestureDetector(
                                        onTap: () => go(context, Routes.signUp),
                                        child: const Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Text(
                                            'Don’t have an account? Sign up',
                                            style: TextStyle(
                                              color: Brand.yellow,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (mode == Routes.signIn || mode == Routes.signUp)
                              field(
                                'Email Address',
                                email,
                                keyboard: TextInputType.emailAddress,
                                validator: Validate.email,
                              ),
                            if (mode == Routes.signUp) field('Full Name', name),
                            if (mode == Routes.password)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 36),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 26,
                                      child: Icon(
                                        CupertinoIcons.person,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Email Address',
                                            style: TextStyle(
                                              color: Brand.yellow,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            state.email,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (mode == Routes.password ||
                                mode == Routes.signUp)
                              field(
                                'Enter Password',
                                password,
                                secret: true,
                                validator: Validate.password,
                              ),
                            if (mode == Routes.phone) ...[
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: region,
                                dropdownColor: Brand.panel,
                                decoration: const InputDecoration(
                                  labelText: 'Your region',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                items:
                                    [
                                          'India +91',
                                          'China +86',
                                          'Japan +81',
                                          'United States +1',
                                        ]
                                        .map(
                                          (v) => DropdownMenuItem(
                                            value: v,
                                            child: Text(v),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (v) => setState(() => region = v!),
                              ),
                              const SizedBox(height: 24),
                              field(
                                'Enter Phone Number',
                                phone,
                                keyboard: TextInputType.phone,
                                validator: Validate.phone,
                              ),
                            ],
                            if (isCode) ...[
                              Text(
                                mode == Routes.verify
                                    ? 'Enter the code we sent via SMS to\n${state.formattedPhone}'
                                    : 'Enter the code sent to\n${state.email}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.7,
                                ),
                              ),
                              const SizedBox(height: 42),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  4,
                                  (i) => SizedBox(
                                    width: 61,
                                    child: TextField(
                                      controller: code[i],
                                      focusNode: focus[i],
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 25),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        hintText: '–',
                                        semanticCounterText:
                                            'Verification digit ${i + 1}',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Brand.yellow.withValues(
                                              alpha: .7,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Brand.yellow.withValues(
                                              alpha: .7,
                                            ),
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Brand.yellow,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      onChanged: (v) {
                                        if (v.isNotEmpty && i < 3) {
                                          focus[i + 1].requestFocus();
                                        }
                                        checkCode();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => back(context),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Brand.panel,
                                      minimumSize: const Size(100, 46),
                                    ),
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  TextButton(
                                    onPressed: seconds == 0
                                        ? () {
                                            setState(startTimer);
                                            message(
                                              context,
                                              'Demo verification code: 1234',
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      seconds > 0
                                          ? '00:${seconds.toString().padLeft(2, '0')}'
                                          : 'Resend code',
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => message(
                                  context,
                                  'Demo verification code: 1234',
                                ),
                                child: const Text(
                                  'Use demo code',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                            if (mode == Routes.notifications) ...[
                              const Text(
                                'Stay notified about new food,\nmenu updates and your receipts.',
                                style: TextStyle(height: 1.8),
                              ),
                              const SizedBox(height: 54),
                              const Text(
                                'Updates',
                                style: TextStyle(color: Brand.yellow),
                              ),
                              SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'Show Notification',
                                  style: TextStyle(fontSize: 14),
                                ),
                                value: state.notifications,
                                activeTrackColor: Brand.yellow,
                                onChanged: (v) {
                                  state.notifications = v;
                                  state.save();
                                },
                              ),
                            ],
                            const SizedBox(height: 24),
                            const Spacer(),
                            if (!isCode)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                child: PrimaryButton(button, onPressed: submit),
                              ),
                            if (mode == Routes.signIn) ...[
                              const SizedBox(height: 20),
                              const Center(
                                child: Text(
                                  'Or',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  social('f', const Color(0xFF0085FF)),
                                  const SizedBox(width: 20),
                                  social('G+', const Color(0xFFEB2424)),
                                ],
                              ),
                            ],
                            if (mode == Routes.password) ...[
                              const SizedBox(height: 36),
                              TextButton(
                                onPressed: () => go(context, Routes.forgot),
                                child: const Text(
                                  'Reset your password',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton(
                                onPressed: () => go(context, Routes.signIn),
                                child: const Text(
                                  'Sign in to a different account',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            SizedBox(
                              height:
                                  mode == Routes.password ||
                                      mode == Routes.signIn
                                  ? 58
                                  : 150,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget social(String label, Color color) => SizedBox(
    width: 60,
    height: 56,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => message(
        context,
        'Social sign-in requires a connected authentication service. Continue with email to try the demo.',
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
