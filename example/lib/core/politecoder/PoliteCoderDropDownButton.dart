import 'package:flutter/material.dart';

class PoliteCoderDropdownButton<T> extends StatefulWidget {
  final List<T> values;
  final Widget Function(T? value) itemBuilder;
  final PoliteCoderDropdownButtonController<T> controller;
  final ValueChanged? onChanged;
  final bool enabled;
  final String hint;

  PoliteCoderDropdownButton({
    required this.controller,
    required this.values,
    required this.itemBuilder,
    this.onChanged,
    this.enabled = true,
    this.hint = '',
  });

  @override
  _PoliteCoderDropdownButtonState<T> createState() =>
      _PoliteCoderDropdownButtonState<T>();
}

class _PoliteCoderDropdownButtonState<T>
    extends State<PoliteCoderDropdownButton<T>> {
  T? _value;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _value = widget.controller.value;
      widget.controller.addListener(() => setState(() {
            _value = widget.controller.value;
          }));
      widget.onChanged?.call(_value);
    }
  }

  @override
  void dispose() {
    widget.controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      disabledHint: widget.itemBuilder(_value),
      // icon: FaIcon(
      //   FontAwesomeIcons.caretDown,
      //   color: MColors.black,
      //   size: 16,
      // ),
      hint: Container(
        child: Center(
          child: Text(
            '  ${widget.hint}  ',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      value: _value,
      items: widget.values
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Container(child: Center(child: widget.itemBuilder(value))),
            ),
          )
          .toList(),
      underline: SizedBox(),
      isDense: true,
      isExpanded: false,
      onChanged: widget.enabled
          ? (value) {
              if (value == null) return;
              if (widget.controller != null) {
                widget.controller.value = value;
              } else {
                setState(() {
                  _value = value;
                });
              }
              widget.onChanged?.call(value);
            }
          : null,
    );
  }
}

class PoliteCoderDropdownButtonController<T> {
  List<VoidCallback> _listeners = [];
  T? _value;

  PoliteCoderDropdownButtonController(this._value);

  T? get value => _value;

  set value(T? value) {
    _value = value;
    _listeners.forEach((listener) => listener());
  }

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void close() => _listeners.clear();
}
