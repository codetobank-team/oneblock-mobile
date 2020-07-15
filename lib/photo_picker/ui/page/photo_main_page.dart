import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart'; import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:Oneblock/AppEngine.dart';
import 'package:Oneblock/Assets.dart';
import 'package:Oneblock/photo_picker/delegate/badge_delegate.dart';
import 'package:Oneblock/photo_picker/delegate/loading_delegate.dart';
import 'package:Oneblock/photo_picker/engine/lru_cache.dart';
import 'package:Oneblock/photo_picker/entity/options.dart';
import 'package:Oneblock/photo_picker/provider/config_provider.dart';
import 'package:Oneblock/photo_picker/provider/gallery_list_provider.dart';
import 'package:Oneblock/photo_picker/provider/i18n_provider.dart';
import 'package:Oneblock/photo_picker/provider/selected_provider.dart';
import 'package:Oneblock/photo_picker/ui/dialog/change_gallery_dialog.dart';
import 'package:Oneblock/photo_picker/ui/page/photo_preview_page.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoMainPage extends StatefulWidget {
  final ValueChanged<List<AssetEntity>> onClose;
  final Options options;

  const PhotoMainPage({
    Key key,
    this.onClose,
    this.options,
  }) : super(key: key);

  @override
  _PhotoMainPageState createState() => _PhotoMainPageState();
}

class _PhotoMainPageState extends State<PhotoMainPage>
    with SelectedProvider, GalleryListProvider {
  Options get options => widget.options;

  I18nProvider get i18nProvider => ConfigProvider.of(context).provider;

  List<AssetEntity> list = [];

  Color get themeColor => options.themeColor;

  AssetPathEntity _currentPath = AssetPathEntity.all;

  bool _isInit = false;

  AssetPathEntity get currentPath {
    if (_currentPath == null) {
      return null;
    }
    return _currentPath;
  }

  set currentPath(AssetPathEntity value) {
    _currentPath = value;
  }

  GlobalKey scaffoldKey;
  ScrollController scrollController;

  bool isPushed = false;

  @override
  void initState() {
    super.initState();
    _refreshList();
    scaffoldKey = GlobalKey();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scaffoldKey = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    var textStyle = TextStyle(
//      color: options.textColor,
//      fontSize: 14.0,
//    );
    return Scaffold(
      backgroundColor: white,
      /*appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: _cancel,
        ),
        title: Text(
          i18nProvider.getTitleText(options),style: textStyle(true,14,white),
        ),
        actions: <Widget>[
          */ /*FlatButton(
              */ /* */ /*materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,*/ /* */ /*
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: selectedCount == 0?Colors.white:Colors.white.withOpacity(.3),
              onPressed: selectedCount == 0 ? null : sure,
              child: Text(
                i18nProvider.getSureText(options, selectedCount),
                style: selectedCount == 0 ? textStyle.copyWith(color: Colors.blue.withOpacity(.3)) : TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                ),
              ))*/ /*
          FlatButton(
            splashColor: Colors.transparent,
            child: Text(
              i18nProvider.getSureText(options, selectedCount),
              style: selectedCount == 0
                  ? textStyle.copyWith(color: options.disableColor)
                  : textStyle,
            ),
            onPressed: selectedCount == 0 ? null : sure,
          ),
        ],
      ),*/
      body: _buildBody(),
      bottomNavigationBar: _BottomWidget(
        key: scaffoldKey,
        provider: i18nProvider,
        options: options,
        galleryName: currentPath.name,
        onGalleryChange: _onGalleryChange,
        onTapPreview: selectedList.isEmpty ? null : _onTapPreview,
        selectedProvider: this,
        galleryListProvider: this,
      ),
    );
  }

  void _cancel() {
    selectedList.clear();
    widget.onClose(selectedList);
  }

  @override
  bool isUpperLimit() {
    var result = selectedCount == options.maxSelected;
    if (result) _showTip(i18nProvider.getMaxTipText(options));
    return result;
  }

  void sure() {
    widget.onClose?.call(selectedList);
  }

  void _showTip(String msg) {
    if (isPushed) {
      return;
    }
    Scaffold.of(scaffoldKey.currentContext).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: options.textColor,
            fontSize: 14.0,
          ),
        ),
        duration: Duration(milliseconds: 1500),
        //backgroundColor: themeColor.withOpacity(0.7),
      ),
    );
  }

  Future<void> _refreshList() async {
    List<AssetPathEntity> pathList;
    switch (options.pickType) {
      case PickType.onlyImage:
        pathList = await PhotoManager.getImageAsset();
        break;
      case PickType.onlyVideo:
        pathList = await PhotoManager.getVideoAsset();
        break;
      default:
        pathList = await PhotoManager.getAssetPathList();
    }

    if (pathList == null) {
      return;
    }

    options.sortDelegate.sort(pathList);

    galleryPathList.clear();
    galleryPathList.addAll(pathList);

    List<AssetEntity> imageList;

    if (pathList.isNotEmpty) {
      imageList = await pathList[0].assetList;
      _currentPath = pathList[0];
    }

    for (var path in pathList) {
      if (path.isAll) {
        path.name = i18nProvider.getAllGalleryText(options);
      }
    }

    this.list.clear();
    if (imageList != null) {
      this.list.addAll(imageList);
    }
    setState(() {
      _isInit = true;
    });
  }

  Widget _buildBody() {
    if (!_isInit) {
      return _buildLoading();
    }

    return Container(
      //color: options.dividerColor,
      child: Column(
        children: <Widget>[
          addSpace(30),
          new Container(
            width: double.infinity,
            color: white,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                          child: Icon(
                        Icons.keyboard_backspace,
                        color: black,
                        size: 25,
                      )),
                    )),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: new Text(
                    i18nProvider.getTitleText(options),
                    style: textStyle(true, 17, black),
                  ),
                ),
                addSpaceWidth(10),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: blue3,
                    onPressed: selectedCount == 0 ? null : sure,
                    child: Text(
                      "OK",
                      style: textStyle(true, 14, white),
                    )),
                addSpaceWidth(15)
              ],
            ),
          ),
          addLine(1, black.withOpacity(.1), 0, 0, 0, 0),
          Expanded(
            child: GridView.builder(
              controller: scrollController,
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: options.rowCount,
                childAspectRatio: options.itemRadio,
                crossAxisSpacing: options.padding,
                mainAxisSpacing: options.padding,
              ),
              itemBuilder: _buildItem,
              itemCount: list.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    AssetEntity data = list[index];
    var currentSelected = containsEntity(data);
    return RepaintBoundary(
      child: GestureDetector(
        //onTap: () => _onItemClick(data, index),
        onTap: () {
          if (options.pickType == PickType.onlyVideo ||
              options.maxSelected == 1) {
            addSelectEntity(data);
            sure();
            return;
          }

          changeCheck(!currentSelected, data);
        },
        child: Stack(
          children: <Widget>[
            ImageItem(
              entity: data,
              themeColor: themeColor,
              size: options.thumbSize,
              loadingDelegate: options.loadingDelegate,
              badgeDelegate: options.badgeDelegate,
            ),
            options.pickType == PickType.onlyVideo
                ? Container(
                    color: black.withOpacity(.2),
                    child: Center(
                        child: Icon(
                      Icons.play_circle_filled,
                      size: 20,
                      color: white,
                    )),
                  )
                : _buildMask(containsEntity(data)),
            options.pickType == PickType.onlyVideo || options.maxSelected == 1
                ? Container()
                : _buildSelected(data),
          ],
        ),
      ),
    );
  }

  _buildMask(bool showMask) {
    return IgnorePointer(
      child: AnimatedContainer(
        color: showMask ? Colors.black.withOpacity(0.5) : Colors.transparent,
        duration: Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildSelected(AssetEntity entity) {
    var currentSelected = containsEntity(entity);
    return Positioned(
      right: 0.0,
      width: 36.0,
      height: 36.0,
      child: GestureDetector(
        onTap: () {
          changeCheck(!currentSelected, entity);
        },
        behavior: HitTestBehavior.translucent,
        child: _buildText(entity),
      ),
    );
  }

  Widget _buildText(AssetEntity entity) {
    var isSelected = containsEntity(entity);
    Widget child;
    BoxDecoration decoration;
    if (isSelected) {
      child = Text(
        (indexOfSelected(entity) + 1).toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.0,
          color: options.textColor,
        ),
      );
      decoration = BoxDecoration(color: themeColor);
    } else {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        border: Border.all(
          color: themeColor,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: decoration,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  void changeCheck(bool value, AssetEntity entity) {
    if (value) {
      addSelectEntity(entity);
    } else {
      removeSelectEntity(entity);
    }
    setState(() {});
  }

  void _onGalleryChange(AssetPathEntity value) {
    _currentPath = value;

    _currentPath.assetList.then((v) {
      list.clear();
      list.addAll(v);
      scrollController.jumpTo(0.0);
      setState(() {});
    });
  }

  void _onItemClick(AssetEntity data, int index) {
    var result = new PhotoPreviewResult();
    isPushed = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return ConfigProvider(
            provider: ConfigProvider.of(context).provider,
            options: options,
            child: PhotoPreviewPage(
              selectedProvider: this,
              list: List.of(list),
              initIndex: index,
              changeProviderOnCheckChange: true,
              result: result,
            ),
          );
        },
      ),
    ).then((v) {
      if (handlePreviewResult(v)) {
        Navigator.pop(context, v);
        return;
      }
      isPushed = false;
      setState(() {});
    });
  }

  void _onTapPreview() async {
    var result = new PhotoPreviewResult();
    isPushed = true;
    var v = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ConfigProvider(
              provider: ConfigProvider.of(context).provider,
              options: options,
              child: PhotoPreviewPage(
                selectedProvider: this,
                list: List.of(selectedList),
                changeProviderOnCheckChange: false,
                result: result,
              ),
            ),
      ),
    );
    if (handlePreviewResult(v)) {
      // print(v);
      Navigator.pop(context, v);
      return;
    }
    isPushed = false;
    compareAndRemoveEntities(result.previewSelectedList);
  }

  bool handlePreviewResult(List<AssetEntity> v) {
    if (v == null) {
      return false;
    }
    if (v is List<AssetEntity>) {
      return true;
    }
    return false;
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            padding: const EdgeInsets.all(5.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(themeColor),
              strokeWidth: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              i18nProvider.loadingText(),
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class _BottomWidget extends StatefulWidget {
  final ValueChanged<AssetPathEntity> onGalleryChange;

  final Options options;

  final I18nProvider provider;

  final SelectedProvider selectedProvider;

  final String galleryName;

  final GalleryListProvider galleryListProvider;
  final VoidCallback onTapPreview;

  const _BottomWidget({
    Key key,
    this.onGalleryChange,
    this.options,
    this.provider,
    this.selectedProvider,
    this.galleryName = "",
    this.galleryListProvider,
    this.onTapPreview,
  }) : super(key: key);

  @override
  __BottomWidgetState createState() => __BottomWidgetState();
}

class __BottomWidgetState extends State<_BottomWidget> {
  Options get options => widget.options;

  I18nProvider get i18nProvider => widget.provider;

  @override
  Widget build(BuildContext context) {
    //var textStyle = TextStyle(fontSize: 14.0);
    const textPadding = const EdgeInsets.symmetric(horizontal: 16.0);
    return Container(
      color: options.themeColor,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Container(
          height: 52.0,
          child: Row(
            children: <Widget>[
              FlatButton(
                onPressed: _showGallerySelectDialog,
                splashColor: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  height: 44.0,
                  padding: textPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_drop_down,
                        color: white.withOpacity(.5),
                        size: 30,
                      ),
                      //addSpaceWidth(5),
                      Text(
                        widget.galleryName,
                        style: textStyle(true, 12, white),
                      ),
                    ],
                  ),
                ),
              ),
              /*Expanded(
                child: Container(),
              ),
              FlatButton(
                onPressed: widget.onTapPreview,
                textColor: options.textColor,
                splashColor: Colors.transparent,
                disabledTextColor: options.disableColor,
                child: Container(
                  height: 44.0,
                  alignment: Alignment.center,
                  child: Text(
                    i18nProvider.getPreviewText(options, widget.selectedProvider),
                    style: textStyle,
                  ),
                  padding: textPadding,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  void _showGallerySelectDialog() async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => ChangeGalleryDialog(
            galleryList: widget.galleryListProvider.galleryPathList,
          ),
    );

    if (result != null) widget.onGalleryChange?.call(result);
  }
}

class ImageItem extends StatelessWidget {
  final AssetEntity entity;

  final Color themeColor;

  final int size;

  final LoadingDelegate loadingDelegate;

  final BadgeDelegate badgeDelegate;

  const ImageItem({
    Key key,
    this.entity,
    this.themeColor,
    this.size = 64,
    this.loadingDelegate,
    this.badgeDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var thumb = ImageLruCache.getData(entity, size);
    if (thumb != null) {
      return _buildImageItem(context, thumb);
    }

    return FutureBuilder<Uint8List>(
      future: entity.thumbDataWithSize(size, size),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        var futureData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done &&
            futureData != null) {
          ImageLruCache.setData(entity, size, futureData);
          return _buildImageItem(context, futureData);
        }
        return Center(
          child: loadingDelegate.buildPreviewLoading(
            context,
            entity,
            themeColor,
          ),
        );
      },
    );
  }

  Widget _buildImageItem(BuildContext context, Uint8List data) {
    var image = Image.memory(
      data,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
    // FutureBuilder()
    var badge = FutureBuilder<Duration>(
//      future: entity.videoDuration,
      builder: (ctx, snapshot) {
        if (snapshot.hasData && snapshot != null) {
          var buildBadge =
              badgeDelegate?.buildBadge(context, entity.type, snapshot.data);
          if (buildBadge == null) {
            return Container();
          } else {
            return buildBadge;
          }
        } else {
          return Container();
        }
      },
    );

    return Stack(
      children: <Widget>[
        image,
        /*IgnorePointer(
          child: badge,
        ),*/
      ],
    );
  }
}
