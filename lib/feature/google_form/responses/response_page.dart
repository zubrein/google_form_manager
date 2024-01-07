import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/cubit/form_cubit.dart';
import 'package:google_form_manager/feature/google_form/responses/summary/summary_tab.dart';

class ResponsePage extends StatefulWidget {
  final FormCubit formCubit;

  const ResponsePage({
    super.key,
    required this.formCubit,
  });

  @override
  State<ResponsePage> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FormCubit, EditFormState>(
      bloc: widget.formCubit,
      builder: (context, state) {
        if (state is FormListUpdateState) {
          return Column(
            children: [
              _buildTabBar(),
              _buildTabBarView(),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: TabBar(
        controller: _tabController,
        indicator: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 2.0))),
        labelColor: Colors.black,
        tabs: const [
          Tab(text: 'Summary'),
          Tab(text: 'Questions'),
          Tab(text: 'Individual'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(controller: _tabController, children: [
        SummaryTab(formCubit: widget.formCubit),
        SummaryTab(formCubit: widget.formCubit),
        SummaryTab(formCubit: widget.formCubit),
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
