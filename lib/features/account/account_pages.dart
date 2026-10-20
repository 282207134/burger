import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../core/validators.dart';
import '../../core/widgets.dart';
import '../../state/app_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return ShopScaffold(
      selected: 3,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Brand.yellow, Color(0xFFDC8D00), Colors.black],
                  stops: [0, .55, 1],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const PageHeader('Profile', darkText: true),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 132,
                    height: 132,
                    child: Stack(
                      children: [
                        const ClipOval(
                          child: FoodImage(
                            'avatar',
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 19,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              tooltip: 'Edit profile',
                              onPressed: () => editProfile(context, state),
                              icon: const Icon(
                                CupertinoIcons.pencil,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    state.name,
                    style: const TextStyle(color: Brand.yellow, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    state.formattedPhone,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFD0D0D0),
                    ),
                  ),
                  const SizedBox(height: 30),
                  group('Account', [
                    tile('Location', () => go(context, Routes.location)),
                    tile(
                      'Change Password',
                      () => go(context, Routes.changePassword),
                    ),
                    tile('Shipping', () => go(context, Routes.shipping)),
                    tile('Payment', () => go(context, Routes.payment)),
                    tile('Logout', () {
                      state.onboarded = false;
                      state.save();
                      go(context, Routes.signIn, root: true);
                    }),
                    tile(
                      'Remove Account',
                      () => confirmRemoval(context, state),
                    ),
                  ]),
                  group('Notification', [
                    toggle('App Notification', state.notifications, (v) {
                      state.notifications = v;
                      state.save();
                    }),
                    toggle('Location Tracking', state.locationTracking, (v) {
                      state.locationTracking = v;
                      state.save();
                    }),
                  ]),
                  group('Other', [
                    tile(
                      'Language',
                      () => showInfo(
                        context,
                        'Language',
                        'English',
                        'This demo follows the English text in the Pixso design.',
                      ),
                      value: 'English',
                    ),
                    tile(
                      'Currency',
                      () => showInfo(
                        context,
                        'Currency',
                        'USD · US Dollar',
                        'Catalog prices follow the USD pricing in the original design.',
                      ),
                      value: 'USD',
                    ),
                  ]),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget group(String label, List<Widget> children) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Brand.yellow, fontSize: 14)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: Brand.radius,
          child: ColoredBox(
            color: Colors.white,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    const Divider(height: 1, color: Color(0xFFDDDDDD)),
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
  Widget tile(String title, VoidCallback onTap, {String? value}) => Material(
    color: Colors.white,
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 45,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              if (value != null)
                Text(
                  value,
                  style: const TextStyle(color: Colors.black54, fontSize: 10),
                ),
              const SizedBox(width: 12),
              const Icon(
                CupertinoIcons.chevron_right,
                color: Colors.black45,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Widget toggle(String label, bool value, ValueChanged<bool> onChanged) =>
      SizedBox(
        height: 48,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            Transform.scale(
              scale: .72,
              child: Switch.adaptive(
                value: value,
                activeTrackColor: Brand.yellow,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      );
  Future<void> editProfile(BuildContext context, AppState state) async {
    final name = TextEditingController(text: state.name),
        phone = TextEditingController(text: state.phone);
    final form = GlobalKey<FormState>();
    await showDialog<void>(
      context: context,
      builder: (dialog) => AlertDialog(
        backgroundColor: Brand.panel,
        title: const Text('Edit profile'),
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: Validate.required,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: Validate.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                state.name = name.text.trim();
                state.phone = phone.text.trim();
                state.save();
                Navigator.pop(dialog);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    // Dialog routes complete before their exit animation has released controllers.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    name.dispose();
    phone.dispose();
  }

  void showInfo(
    BuildContext context,
    String title,
    String choice,
    String description,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Brand.panel,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Brand.yellow, fontSize: 22),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Text(choice)),
                  const Icon(CupertinoIcons.check_mark, color: Brand.yellow),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(color: Brand.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> confirmRemoval(BuildContext context, AppState state) async {
    final remove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Brand.panel,
        title: const Text('Remove local account?'),
        content: const Text(
          'This clears your profile, saved address, favourites and cart from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (remove == true && context.mounted) {
      state.reset();
      go(context, Routes.welcome, root: true);
    }
  }
}

class AccountFormPage extends StatefulWidget {
  final String mode;
  const AccountFormPage({super.key, required this.mode});
  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final form = GlobalKey<FormState>();
  final controllers = List.generate(4, (_) => TextEditingController());
  bool initialized = false, visible = false;
  String get mode => widget.mode;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initialized) {
      return;
    }
    initialized = true;
    if (mode == Routes.shipping) {
      final state = AppScope.of(context);
      final values = [state.city, state.address, state.apartment, state.floor];
      for (var i = 0; i < 4; i++) {
        controllers[i].text = values[i];
      }
    }
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reset = ModalRoute.of(context)?.settings.arguments == true;
    final isPassword = mode == Routes.changePassword,
        isPayment = mode == Routes.payment;
    final state = AppScope.of(context);
    final title = isPassword
        ? 'Change password'
        : isPayment
        ? 'Payment'
        : 'Shipping';
    final labels = isPassword
        ? ['Old Password', 'New Password', 'Confirm Password']
        : isPayment
        ? ['Card Number', 'Holder Name', 'Month/year', 'CVC']
        : ['City', 'Address', 'Apartment', 'Floor'];
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, bounds) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: bounds.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageHeader(
                      title,
                      actions: false,
                      trailing: !isPassword
                          ? TextButton(
                              onPressed: () {
                                for (final c in controllers) {
                                  c.clear();
                                }
                                setState(() {});
                              },
                              child: const Text(
                                'Add New',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(height: isPayment ? 20 : 44),
                    if (isPayment) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PaymentCard(
                          last4: state.cardLast4,
                          holder: state.cardHolder,
                          expiry: state.cardExpiry,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Form(
                        key: form,
                        child: Column(
                          children: [
                            for (
                              var i = reset && isPassword ? 1 : 0;
                              i < labels.length;
                              i++
                            )
                              Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: TextFormField(
                                  controller: controllers[i],
                                  obscureText:
                                      (isPassword || (isPayment && i == 3)) &&
                                      !visible,
                                  keyboardType: isPayment && i != 1
                                      ? TextInputType.number
                                      : TextInputType.text,
                                  inputFormatters:
                                      isPayment && (i == 0 || i == 3)
                                      ? [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(
                                            i == 0 ? 19 : 4,
                                          ),
                                        ]
                                      : null,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: labels[i],
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF757575),
                                      fontSize: 12,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                        color: Brand.yellow,
                                        width: 2,
                                      ),
                                    ),
                                    suffixIcon: isPassword
                                        ? IconButton(
                                            tooltip: visible
                                                ? 'Hide password'
                                                : 'Show password',
                                            onPressed: () => setState(
                                              () => visible = !visible,
                                            ),
                                            icon: Icon(
                                              visible
                                                  ? CupertinoIcons.eye_slash
                                                  : CupertinoIcons.eye,
                                              color: Colors.black54,
                                              size: 17,
                                            ),
                                          )
                                        : null,
                                  ),
                                  validator: (value) {
                                    if (isPassword) {
                                      if (i == 2) {
                                        return value == controllers[1].text
                                            ? Validate.password(value)
                                            : 'Passwords do not match';
                                      }
                                      return Validate.password(value);
                                    }
                                    if (isPayment) {
                                      if (i == 0) {
                                        return Validate.card(value);
                                      }
                                      if (i == 2) {
                                        return Validate.expiry(value);
                                      }
                                      if (i == 3) {
                                        return RegExp(r'^\d{3,4}$')
                                                .hasMatch(value ?? '')
                                            ? null
                                            : 'Enter 3 or 4 digits';
                                      }
                                    }
                                    return i == 3 && !isPayment
                                        ? null
                                        : Validate.required(value);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      child: PrimaryButton(
                        isPassword ? 'Update Password' : 'Update Profile',
                        onPressed: () => save(reset),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 0, 24),
                        child: TextButton(
                          onPressed: () => back(context),
                          child: const Text('Back'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void save(bool reset) {
    if (!form.currentState!.validate()) {
      return;
    }
    final state = AppScope.of(context);
    FocusScope.of(context).unfocus();
    if (mode == Routes.shipping) {
      state.city = controllers[0].text.trim();
      state.address = controllers[1].text.trim();
      state.apartment = controllers[2].text.trim();
      state.floor = controllers[3].text.trim();
      state.save();
      message(context, 'Shipping address saved');
      back(context);
    } else if (mode == Routes.payment) {
      final number = controllers[0].text;
      state.cardLast4 = number.substring(number.length - 4);
      state.cardHolder = controllers[1].text.trim();
      state.cardExpiry = controllers[2].text;
      state.save();
      for (final controller in controllers) {
        controller.clear();
      }
      message(
        context,
        'Demo card saved · only the last four digits are stored',
      );
      back(context);
    } else {
      for (final controller in controllers) {
        controller.clear();
      }
      message(
        context,
        'Demo password validated. Connect an authentication service to change a real password.',
      );
      if (reset) {
        go(context, Routes.signIn, root: true);
      } else {
        back(context);
      }
    }
  }
}

class PaymentCard extends StatelessWidget {
  final String? last4, holder, expiry;
  const PaymentCard({super.key, this.last4, this.holder, this.expiry});
  @override
  Widget build(BuildContext context) => Container(
    height: 190,
    padding: const EdgeInsets.all(23),
    decoration: const BoxDecoration(
      color: Brand.yellow,
      borderRadius: Brand.radius,
    ),
    child: DefaultTextStyle(
      style: const TextStyle(fontFamily: 'Poppins', color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
            width: 70,
            child: Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFED5D43),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 27,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB3CA16).withValues(alpha: .9),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '••••   ••••   ••••   ${last4 ?? '••••'}',
            style: const TextStyle(fontSize: 20, letterSpacing: 1.6),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CARD HOLDER', style: TextStyle(fontSize: 8)),
                    const SizedBox(height: 4),
                    Text(
                      holder?.toUpperCase() ?? '•••• ••••',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('EXP DATE', style: TextStyle(fontSize: 8)),
                  const SizedBox(height: 4),
                  Text(expiry ?? '••/••', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
