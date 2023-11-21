import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/core/loading_hud/loading_hud_cubit.dart';

class Base extends StatefulWidget {
  final LoadingHudCubit loadingHudCubit;
  final Widget child;

  const Base({super.key, required this.child, required this.loadingHudCubit});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<LoadingHudCubit, LoadingHudState>(
            bloc: widget.loadingHudCubit,
            builder: (context, state) {
              return Stack(
                children: [
                  widget.child,
                  _buildBarrier(state),
                  _buildMessageBox(state),
                  _buildAnimation(state),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildBarrier(LoadingHudState state) {
    return Visibility(
      visible: state is ShowError || state is ShowAnimation,
      child: const Opacity(
        opacity: 0.7,
        child: ModalBarrier(
          dismissible: true,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMessageBox(LoadingHudState state) {
    return state is ShowError
        ? _buildErrorMessageBanner(state)
        : const SizedBox();
  }

  Widget _buildAnimation(state) {
    return state is ShowAnimation
        ? const Center(child: CircularProgressIndicator())
        : const SizedBox.shrink();
  }

  Widget _buildErrorMessageBanner(ShowError state) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 50,
        minWidth: double.infinity,
      ),
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildMessageText(state)),
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageText(ShowError state) {
    return Text(
      state.message,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        widget.loadingHudCubit.cancel();
      },
      child: const Icon(
        Icons.cancel_rounded,
        color: Colors.white,
      ),
    );
  }
}
