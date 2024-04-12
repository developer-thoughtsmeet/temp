library multi_image_layout;

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:thoughtsmeetapp/utils/check_file_type.dart';
import 'package:thoughtsmeetapp/utils/const_utils.dart';
import 'package:thoughtsmeetapp/utils/enum_utils.dart';
import 'package:thoughtsmeetapp/view/tab_bar/video_player/video_player.dart';
import 'package:thoughtsmeetapp/view/tab_bar/video_player/video_player2.dart';
import 'package:thoughtsmeetapp/view/tab_bar/video_player/youtube_video_player.dart';
import 'package:video_player/video_player.dart';
import '../../utils/color_utils.dart';
import '../../viewModel/home_controller.dart';

class MultiImageViewer extends StatefulWidget {
  const MultiImageViewer({
    Key? key,
    required this.images,
    this.captions,
    this.backgroundColor = Colors.black87,
    this.textStyle = const TextStyle(
      fontSize: 30,
    ),
    this.height = 325,
    this.width,
    this.isPlay,
  }) : super(key: key);

  final Color backgroundColor;
  final TextStyle textStyle;
  final List<String> images;

  final List<String>? captions;
  final double height;
  final double? width;
  final bool? isPlay;

  @override
  State<MultiImageViewer> createState() => _MultiImageViewerState();
}

class _MultiImageViewerState extends State<MultiImageViewer> {
  List<String> extention = [];

  @override
  void initState() {
    super.initState();
    for (var element in widget.images) {
      extention.add(element.toString().split(".").last);
    }
  }

  HomeScreenViewModel homeScreenViewModel = Get.find<HomeScreenViewModel>();

  @override
  Widget build(BuildContext context) {
    /// MediaQuery Width
    double defaultWidth = MediaQuery.of(context).size.width;

    if (widget.images.isEmpty) {
      return Container(
          // color: Colors.blue,
          );
    }
    if (widget.isPlay == true) {
      if (!widget.images.contains(ConstUtils.previousVideoLink)) {
        ConstUtils.previousVideoLink = widget.images.first;
        homeScreenViewModel.currentPosition = 0.0;
        homeScreenViewModel.currentYouTubePosition = 0.0;
      }
    }
    if (widget.images.length == 1) {
      return GestureDetector(
          onTap: () {
            openImage(context, 0, widget.images, widget.captions);

            setState(() {});
          },
          child: ConstUtils.imageFormatList
                  .contains(extention[0].toString().toUpperCase())
              ? LimitedBox(
                  maxHeight: 500,
                  child: Image.network(
                    widget.images[0],
                    // fit: BoxFit.fill,
                    // height: null,
                    width: Get.width,
                    fit: BoxFit.fill,
                  ),
                )
              : UrlTypeHelper.getType(widget.images[0]) == MessageTypeEnum.Video
                  ? ForceVideoPlayer(
                      showControls: false,
                      url: widget.images[0],
                      // play: true,
                      initialPosition: 0.0,

                      play: widget.isPlay ?? true,
                    )
                  : widget.images[0].contains('youtube') ||
                          widget.images[0].contains('youtu.be')
                      ? SizedBox(
                          height: 400,
                          child: YoutubePlayerDialogWidget(
                            key: ValueKey(widget.isPlay),
                            hideControl: true,
                            url: widget.images[0],
                            play: widget.isPlay ?? false,
                            mute: false,
                            showIndicator: false,
                          ),
                        )
                      : widget.images[0].contains("media")
                          ? LimitedBox(
                              maxHeight: 500,
                              child: Image.network(
                                widget.images[0],
                                // fit: BoxFit.fill,
                                // height: null,
                                width: Get.width,
                                fit: BoxFit.fill,
                              ),
                            )
                          : const SizedBox());
    } else if (widget.images.length == 2) {
      return SizedBox(
        // height: widget.height,
        width: widget.width ?? defaultWidth,
        child: Row(children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(right: 1),
                child:
                    UrlTypeHelper.getType(extention[0]) == MessageTypeEnum.Video
                        ? GestureDetector(
                            onTap: () => openImage(
                                context, 0, widget.images, widget.captions),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                              child: Container(
                                height: widget.height,
                                width: widget.width == null
                                    ? defaultWidth / 2
                                    : widget.width! / 2,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5))),
                                child: ForceVideoPlayer(
                                  showControls: false,
                                  url: widget.images[0],
                                  // play: true,
                                  play: widget.isPlay ?? true,
                                ),
                              ),
                            ),
                          )
                        : widget.images.contains('youtube')
                            ? YoutubePlayerDialogWidget(
                                key: ValueKey(widget.isPlay),
                                url: widget.images[0],
                                play: widget.isPlay ?? false,
                              )
                            : GestureDetector(
                                onTap: () => openImage(
                                    context, 0, widget.images, widget.captions),
                                child: Container(
                                  height: 200,
                                  width: widget.width == null
                                      ? defaultWidth / 2
                                      : widget.width! / 2,
                                  decoration: BoxDecoration(
                                      color: widget.backgroundColor,
                                      image: DecorationImage(
                                          image: NetworkImage(widget.images[0]),
                                          fit: BoxFit.fill),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5))),
                                ),
                              )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 1),
              child: GestureDetector(
                onTap: () =>
                    openImage(context, 1, widget.images, widget.captions),
                child:
                    UrlTypeHelper.getType(extention[1]) == MessageTypeEnum.Video
                        ? Container(
                            height: widget.height,
                            width: widget.width == null
                                ? defaultWidth / 2
                                : widget.width! / 2,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                            child: ForceVideoPlayer(
                              showControls: false,
                              url: widget.images[1],
                              // play: true,
                              play: widget.isPlay ?? true,
                            ),
                          )
                        : Container(
                            height: 200,
                            width: widget.width == null
                                ? defaultWidth / 2
                                : widget.width! / 2,
                            decoration: BoxDecoration(
                                color: widget.backgroundColor,
                                image: DecorationImage(
                                    image: NetworkImage(widget.images[1]),
                                    fit: BoxFit.fill),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5))),
                          ),
              ),
            ),
          ),
        ]),
      );
    } else if (widget.images.length == 3) {
      return SizedBox(
        height: widget.height,
        width: widget.width ?? defaultWidth,
        child: Row(children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2, bottom: 2),
                    child: GestureDetector(
                        onTap: () {
                          openImage(context, 0, widget.images, widget.captions);
                        },
                        child: ConstUtils.imageFormatList
                                .contains(extention[0].toString().toUpperCase())
                            ? Container(
                                height: widget.height,
                                width: widget.width ?? defaultWidth,
                                decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.images[0]),
                                      fit: BoxFit.fill),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              )
                            : extention[0].endsWith('.png')
                                ? Container(
                                    height: widget.height,
                                    width: widget.width ?? defaultWidth,
                                    decoration: BoxDecoration(
                                      color: widget.backgroundColor,
                                      image: DecorationImage(
                                          image: NetworkImage(widget.images[0]),
                                          fit: BoxFit.fill),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                  )
                                : UrlTypeHelper.getType(widget.images[0]) ==
                                        MessageTypeEnum.Video
                                    ? SizedBox(
                                        height: widget.height,
                                        width: widget.width ?? defaultWidth,
                                        child: ForceVideoPlayer(
                                          showControls: false,
                                          url: widget.images[0],
                                          play: true,
                                        ),
                                      )
                                    : widget.images[0].contains('youtube')
                                        ? SizedBox(
                                            height: widget.height,
                                            width: widget.width ?? defaultWidth,
                                            child: YoutubePlayerDialogWidget(
                                              key: ValueKey(widget.isPlay),
                                              hideControl: true,
                                              url: widget.images[0],
                                              play: widget.isPlay ?? false,
                                              mute: false,
                                              showIndicator: false,
                                            ),
                                          )
                                        : Container(
                                            height: widget.height,
                                            width: widget.width ?? defaultWidth,
                                            decoration: BoxDecoration(
                                              color: widget.backgroundColor,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      widget.images[0]),
                                                  fit: BoxFit.fill),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                          )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: GestureDetector(
                        onTap: () => openImage(
                            context, 1, widget.images, widget.captions),
                        child: ConstUtils.imageFormatList
                                .contains(extention[1].toString().toUpperCase())
                            ? Container(
                                width: widget.width == null
                                    ? defaultWidth / 2
                                    : widget.width! / 2,
                                decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.images[1]),
                                      fit: BoxFit.fill),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              )
                            : UrlTypeHelper.getType(extention[1]) ==
                                    MessageTypeEnum.Video
                                ? Container(
                                    width: widget.width == null
                                        ? defaultWidth / 2
                                        : widget.width! / 2,
                                    decoration: BoxDecoration(
                                      color: widget.backgroundColor,
                                      image: DecorationImage(
                                          image: NetworkImage(widget.images[1]),
                                          fit: BoxFit.fill),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                  )
                                : UrlTypeHelper.getType(widget.images[1]) ==
                                        MessageTypeEnum.Video
                                    ? SizedBox(
                                        width: widget.width == null
                                            ? defaultWidth / 2
                                            : widget.width! / 2,
                                        child: ForceVideoPlayer(
                                          showControls: false,
                                          url: widget.images[1],
                                          play: true,
                                        ),
                                      )
                                    : widget.images[1].contains('youtube')
                                        ? SizedBox(
                                            width: widget.width == null
                                                ? defaultWidth / 2
                                                : widget.width! / 2,
                                            child: YoutubePlayerDialogWidget(
                                              key: ValueKey(widget.isPlay),
                                              hideControl: true,
                                              url: widget.images[1],
                                              play: widget.isPlay ?? false,
                                              mute: false,
                                              showIndicator: false,
                                            ),
                                          )
                                        : Container(
                                            width: widget.width == null
                                                ? defaultWidth / 2
                                                : widget.width! / 2,
                                            decoration: BoxDecoration(
                                              color: widget.backgroundColor,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      widget.images[1]),
                                                  fit: BoxFit.fill),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                          )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: GestureDetector(
                  onTap: () =>
                      openImage(context, 2, widget.images, widget.captions),
                  child: ConstUtils.imageFormatList
                          .contains(extention[2].toString().toUpperCase())
                      ? Container(
                          width: widget.width == null
                              ? defaultWidth / 2
                              : widget.width! / 2,
                          decoration: BoxDecoration(
                            color: widget.backgroundColor,
                            image: DecorationImage(
                                image: NetworkImage(widget.images[2]),
                                fit: BoxFit.fill),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        )
                      : extention[2].endsWith('.png')
                          ? Container(
                              width: widget.width == null
                                  ? defaultWidth / 2
                                  : widget.width! / 2,
                              decoration: BoxDecoration(
                                color: widget.backgroundColor,
                                image: DecorationImage(
                                    image: NetworkImage(widget.images[2]),
                                    fit: BoxFit.fill),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            )
                          : UrlTypeHelper.getType(widget.images[2]) ==
                                  MessageTypeEnum.Video
                              ? SizedBox(
                                  width: widget.width == null
                                      ? defaultWidth / 2
                                      : widget.width! / 2,
                                  child: ForceVideoPlayer(
                                    showControls: false,
                                    url: widget.images[2],
                                    play: true,
                                  ),
                                )
                              : widget.images[2].contains('youtube')
                                  ? SizedBox(
                                      width: widget.width == null
                                          ? defaultWidth / 2
                                          : widget.width! / 2,
                                      child: YoutubePlayerDialogWidget(
                                        key: ValueKey(widget.isPlay),
                                        hideControl: true,
                                        url: widget.images[2],
                                        play: widget.isPlay ?? false,
                                        mute: false,
                                        showIndicator: false,
                                      ),
                                    )
                                  : Container(
                                      width: widget.width == null
                                          ? defaultWidth / 2
                                          : widget.width! / 2,
                                      decoration: BoxDecoration(
                                        color: widget.backgroundColor,
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(widget.images[2]),
                                            fit: BoxFit.fill),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                    )),
            ),
          ),
        ]),
      );
    } else if (widget.images.length == 4) {
      return SizedBox(
        height: widget.height,
        width: widget.width ?? defaultWidth,
        child: Row(children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2, bottom: 2),
                    child: GestureDetector(
                      onTap: () =>
                          openImage(context, 0, widget.images, widget.captions),
                      child: UrlTypeHelper.getType(extention[0]) ==
                              MessageTypeEnum.Video
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                )),
                                child: ForceVideoPlayer(
                                  showControls: false,
                                  url: widget.images[0],
                                  // play: true,
                                  play: widget.isPlay ?? true,
                                ),
                              ),
                            )
                          : Container(
                              // width: width == null ? defaultWidth / 2 : width! / 2,
                              decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.images[0]),
                                      fit: BoxFit.fill),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5))),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: GestureDetector(
                      onTap: () =>
                          openImage(context, 1, widget.images, widget.captions),
                      child: UrlTypeHelper.getType(extention[1]) ==
                              MessageTypeEnum.Video
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                              ),
                              child: Container(
                                width: widget.width == null
                                    ? defaultWidth / 2
                                    : widget.width! / 2,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                )),
                                child: ForceVideoPlayer(
                                  showControls: false,
                                  url: widget.images[1],
                                  // play: true,
                                  play: widget.isPlay ?? true,
                                ),
                              ),
                            )
                          : Container(
                              width: widget.width == null
                                  ? defaultWidth / 2
                                  : widget.width! / 2,
                              decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.images[1]),
                                      fit: BoxFit.fill),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(5))),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, bottom: 2),
                    child: GestureDetector(
                      onTap: () =>
                          openImage(context, 2, widget.images, widget.captions),
                      child: UrlTypeHelper.getType(extention[2]) ==
                              MessageTypeEnum.Video
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                              ),
                              child: Container(
                                width: widget.width == null
                                    ? defaultWidth / 2
                                    : widget.width! / 2,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                )),
                                child: AspectRatio(
                                  aspectRatio: widget.width == null
                                      ? defaultWidth / 2
                                      : widget.width! / 2,
                                  child: ForceVideoPlayer(
                                    showControls: false,
                                    url: widget.images[2],
                                    // play: true,
                                    play: widget.isPlay ?? true,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: widget.width == null
                                  ? defaultWidth / 2
                                  : widget.width! / 2,
                              decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.images[2]),
                                      fit: BoxFit.fill),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5))),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: GestureDetector(
                      onTap: () =>
                          openImage(context, 3, widget.images, widget.captions),
                      child: UrlTypeHelper.getType(extention[3]) ==
                              MessageTypeEnum.Video
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                              ),
                              child: Container(
                                width: widget.width == null
                                    ? defaultWidth / 2
                                    : widget.width! / 2,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                )),
                                child: ForceVideoPlayer(
                                  showControls: false,
                                  url: widget.images[3],
                                  // play: true,
                                  play: widget.isPlay ?? true,
                                ),
                              ),
                            )
                          : Container(
                              width: widget.width == null
                                  ? defaultWidth / 2
                                  : widget.width! / 2,
                              decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.images[3]),
                                      fit: BoxFit.fill),
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(5))),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    } else if (widget.images.length > 4) {
      return SizedBox(
        height: widget.height,
        width: widget.width ?? defaultWidth,
        child: Row(children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2, bottom: 2),
                    child: GestureDetector(
                      onTap: () =>
                          openImage(context, 0, widget.images, widget.captions),
                      child: UrlTypeHelper.getType(extention[0]) ==
                              MessageTypeEnum.Video
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5)),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5))),
                                child: FlickVideoPlayer(
                                    flickManager: FlickManager(
                                  autoPlay: true,
                                  autoInitialize: true,
                                  videoPlayerController:
                                      VideoPlayerController.networkUrl(
                                          Uri.parse(widget.images[0])),
                                )),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.images[0]),
                                      fit: BoxFit.fill),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5))),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: GestureDetector(
                      onTap: () =>
                          openImage(context, 1, widget.images, widget.captions),
                      child: UrlTypeHelper.getType(extention[1]) ==
                              MessageTypeEnum.Video
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                              ),
                              child: Container(
                                width: widget.width == null
                                    ? defaultWidth / 2
                                    : widget.width! / 2,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                  ),
                                ),
                                child: FlickVideoPlayer(
                                    flickManager: FlickManager(
                                  autoPlay: true,
                                  autoInitialize: true,
                                  videoPlayerController:
                                      VideoPlayerController.networkUrl(
                                          Uri.parse(widget.images[1])),
                                )),
                              ),
                            )
                          : Container(
                              width: widget.width == null
                                  ? defaultWidth / 2
                                  : widget.width! / 2,
                              decoration: BoxDecoration(
                                color: widget.backgroundColor,
                                image: DecorationImage(
                                    image: NetworkImage(widget.images[1]),
                                    fit: BoxFit.fill),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, bottom: 2),
                    child: GestureDetector(
                      onTap: () =>
                          openImage(context, 2, widget.images, widget.captions),
                      child: UrlTypeHelper.getType(extention[2]) ==
                              MessageTypeEnum.Video
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                              ),
                              child: Container(
                                  width: widget.width == null
                                      ? defaultWidth / 2
                                      : widget.width! / 2,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: ForceVideoPlayer(
                                    showControls: false,
                                    url: widget.images[2], play: true,
                                    // size: widget.width == null
                                    //     ? defaultWidth / 2
                                    //     : widget.width! / 2,
                                    initialPosition:
                                        homeScreenViewModel.currentPosition,
                                  )),
                            )
                          : Container(
                              width: widget.width == null
                                  ? defaultWidth / 2
                                  : widget.width! / 2,
                              decoration: BoxDecoration(
                                color: widget.backgroundColor,
                                image: DecorationImage(
                                    image: NetworkImage(widget.images[2]),
                                    fit: BoxFit.fill),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: GestureDetector(
                      onTap: () =>
                          openImage(context, 3, widget.images, widget.captions),
                      child: UrlTypeHelper.getType(extention[3]) ==
                              MessageTypeEnum.Video
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(5),
                                  ),
                                  child: Container(
                                    width: widget.width == null
                                        ? defaultWidth / 2
                                        : widget.width! / 2,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(5),
                                      ),
                                    ),
                                    child: FlickVideoPlayer(
                                        flickVideoWithControls:
                                            const FlickVideoWithControls(

                                                // videoFit: BoxFit.fitWidth,
                                                ),
                                        flickManager: FlickManager(
                                          autoPlay: true,
                                          autoInitialize: true,
                                          videoPlayerController:
                                              VideoPlayerController.networkUrl(
                                                  Uri.parse(widget.images[3])),
                                        )),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                          "+${widget.images.length - 4}",
                                          style: widget.textStyle)),
                                ),
                              ],
                            )
                          : Container(
                              width: widget.width == null
                                  ? defaultWidth / 2
                                  : widget.width! / 2,
                              decoration: BoxDecoration(
                                color: widget.backgroundColor,
                                image: DecorationImage(
                                    image: NetworkImage(widget.images[3]),
                                    fit: BoxFit.fill),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                    child: Text("+${widget.images.length - 4}",
                                        style: const TextStyle(
                                            color: ColorUtils.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900))),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    } else {
      return const SizedBox();
    }
  }
}

/// View Image(s)
void openImage(
  BuildContext context,
  final int index,
  List<String> unitImages,
  List<String>? captions,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryPhotoViewWrapper(
        galleryItems: unitImages,
        // videoPosition: homeScreenViewModel.currentPosition,
        captions: captions,
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        initialIndex: index,
        scrollDirection: Axis.horizontal,
      ),
    ),
  );
}

// void openVideo(
//   BuildContext context,
//   final int index,
//   List<String> unitVideo,
//   List<String>? captions,
// ) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => GalleryPhotoViewWrapper(
//         galleryItems: unitVideo,
//         // videoPosition: homeScreenViewModel.currentPosition,
//         captions: captions,
//         backgroundDecoration: const BoxDecoration(
//           color: Colors.white,
//         ),
//         initialIndex: index,
//         scrollDirection: Axis.horizontal,
//       ),
//     ),
//   );
// }

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    Key? key,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    this.height = 205,
    this.width,
    required this.galleryItems,
    this.captions,
    this.videoPosition,
    this.scrollDirection = Axis.horizontal,
  })  : pageController = PageController(initialPage: initialIndex!),
        super(key: key);

  final BoxDecoration? backgroundDecoration;
  final List<String>? galleryItems;
  final List<String>? captions;
  final int? initialIndex;
  final dynamic maxScale;
  final dynamic minScale;
  final PageController pageController;
  final Axis scrollDirection;
  final double height;
  final double? width;
  final double? videoPosition;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int? currentIndex;
  bool showCaptions = false;

  TextEditingController replyController = TextEditingController();
  HomeScreenViewModel homeScreenViewModel = Get.find<HomeScreenViewModel>();

  @override
  Widget build(BuildContext context) {
    /// MediaQuery Width
    //
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //   statusBarColor: Colors.black,
    //   statusBarIconBrightness: Brightness.dark,
    //   statusBarBrightness: Brightness.dark,
    // ));
    return Scaffold(
      backgroundColor: ColorUtils.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorUtils.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Swiper(
              itemCount: widget.galleryItems!.length,
              index: widget.initialIndex,
              itemBuilder: (BuildContext context, int index) {
                String item = widget.galleryItems![index];

                return UrlTypeHelper.getType(widget.galleryItems![index]) ==
                        MessageTypeEnum.Video
                    ? PreviewVideoWidget(
                        url: item,
                        showControls: true,
                        play: true,
                        initialPosition: homeScreenViewModel.currentPosition,
                        // updatePosition: homeScreenViewModel.currentPosition,
                      )
                    : widget.galleryItems![index].contains("youtube") ||
                            widget.galleryItems![index].contains("youtu.be")
                        ? Center(
                            child: YoutubePlayerDialogWidget(
                              showIndicator: true,
                              url: item,
                              hideControl: false,
                              mute: false,
                              play: true,
                            ),
                          )
                        : PhotoView(
                            imageProvider: NetworkImage(
                              item,

                              // width: Get
                              //     .width, // Set to the intrinsic width of the image
                              // height: double
                              //     .infinity, // Set to the intrinsic height of the image
                              // fit: BoxFit.fitWidth,
                            ),
                          );
              },
              autoplay: false,
              scrollDirection: widget.scrollDirection,
              loop: false,
              // onIndexChanged: onPageChanged,
            ),
          ),
          SizedBox(
            height: Get.height * 0.05,
          ),
        ],
      ),
    );
  }
}
