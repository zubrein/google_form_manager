import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_form_manager/feature/google_form/edit_form/domain/entities/youtube_data_entity.dart';
import 'package:google_form_manager/feature/google_form/edit_form/ui/cubit/form_cubit.dart';
import 'package:googleapis/youtube/v3.dart';

import 'search_widget.dart';

class VideoWidgetDialog extends StatefulWidget {
  final BuildContext context;
  final FormCubit formCubit;

  const VideoWidgetDialog({
    super.key,
    required this.context,
    required this.formCubit,
  });

  @override
  State<VideoWidgetDialog> createState() => _VideoWidgetDialogState();
}

class _VideoWidgetDialogState extends State<VideoWidgetDialog> {
  TextEditingController controller = TextEditingController();
  List<SearchResult> searchResult = [];
  bool showProgress = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogHeader(context),
          const Gap(8),
          SearchWidget(
            controller: controller,
            focusNode: _focusNode,
          ),
          const Gap(8),
          _buildSearchButton(),
          const Gap(16),
          Expanded(
            child: showProgress
                ? _buildCircularProgressBar()
                : _buildVideoListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoListView() {
    return ListView.separated(
      itemCount: searchResult.length,
      itemBuilder: (context, position) {
        return _buildVideoItem(searchResult[position]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.black,
        );
      },
    );
  }

  Widget _buildCircularProgressBar() {
    return const Center(
        child: SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildSearchButton() {
    return InkWell(
      onTap: () async {
        _focusNode.unfocus();
        showProgress = true;
        setState(() {});
        searchResult = await widget.formCubit.fetchYoutubeList(controller.text);
        showProgress = false;
        setState(() {});
      },
      child: const SizedBox(
        height: 35,
        child: ColoredBox(
          color: Colors.blue,
          child: Center(
            child: Text(
              'Search',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/youtube_logo.png',
          height: 20,
        ),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildVideoItem(SearchResult searchResult) {
    return ListTile(
      onTap: () {
        Navigator.pop(context, [
          YoutubeDataEntity(
              'www.youtube.com/watch?v=${searchResult.id?.videoId}',
              searchResult.snippet?.thumbnails?.medium?.url ?? '')
        ]);
      },
      leading: SizedBox(
        height: 32,
        width: 56,
        child: Image.network(
          '${searchResult.snippet?.thumbnails?.medium?.url}',
          fit: BoxFit.fill,
        ),
      ),
      title: Text(searchResult.snippet?.title ?? ''),
      subtitle: Text(searchResult.snippet?.description ?? ''),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
