import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/src/elements/ProductsCarouselWidget.dart';
import 'package:markets/src/pages/menu_list.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../controllers/market_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/GalleryCarouselWidget.dart';
import '../elements/ProductItemWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/conversation.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class MarketWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MarketWidget({Key key, this.parentScaffoldKey, this.routeArgument})
      : super(key: key);

  @override
  _MarketWidgetState createState() {
    return _MarketWidgetState();
  }
}

class _MarketWidgetState extends StateMVC<MarketWidget> {
  MarketController _con;

  _MarketWidgetState() : super(MarketController()) {
    _con = controller;
  }

  List<String> selectedCategories;

  @override
  void initState() {
    _con.market = widget.routeArgument.param as Market;
    _con.listenForGalleries(_con.market.id);
    _con.listenForFeaturedProducts(_con.market.id);
    _con.listenForMarketReviews(id: _con.market.id);

    _con.market = widget.routeArgument.param as Market;
    _con.listenForTrendingProducts(_con.market.id);
    _con.listenForCategories(_con.market.id);
    selectedCategories = ['0'];
    _con.listenForProducts(_con.market.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _con.refreshMarket,
        child: _con.market == null
            ? CircularLoadingWidget(height: 500)
            : Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CustomScrollView(
                    primary: true,
                    shrinkWrap: false,
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(0.9),
                        expandedHeight: 300,
                        elevation: 0,
//                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                        automaticallyImplyLeading: false,
                        leading: new IconButton(
                          icon: new Icon(Icons.sort,
                              color: Theme.of(context).primaryColor),
                          onPressed: () => widget.parentScaffoldKey.currentState
                              .openDrawer(),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: Hero(
                            tag: (widget?.routeArgument?.heroTag ?? '') +
                                _con.market.id,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: _con.market.image.url,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, bottom: 10, top: 25),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.market?.name ?? '',
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32,
                                    child: Chip(
                                      padding: EdgeInsets.all(0),
                                      label: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(_con.market.rate,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor))),
                                          Icon(
                                            Icons.star_border,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: _con.market.closed
                                          ? Colors.grey
                                          : Colors.green,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: _con.market.closed
                                      ? Text(
                                          S.of(context).closed,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        )
                                      : Text(
                                          S.of(context).open,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        ),
                                ),
                                SizedBox(width: 10),
                                Expanded(child: SizedBox(height: 0)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: Helper.canDelivery(_con.market)
                                          ? Colors.green
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Text(
                                    Helper.getDistance(
                                        _con.market.distance,
                                        Helper.of(context)
                                            .trans(setting.value.distanceUnit)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .merge(TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Helper.applyHtml(
                                  context, _con.market.description),
                            ),
                            ImageThumbCarouselWidget(
                                galleriesList: _con.galleries),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListTile(
                                dense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.stars_outlined,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).information,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Helper.applyHtml(
                                  context, _con.market.information),
                            ),
                            // TODO: Boton de chat
                            // Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            //   margin: const EdgeInsets.symmetric(vertical: 5),
                            //   color: Theme.of(context).primaryColor,
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: <Widget>[
                            //       Expanded(
                            //         child: Text(
                            //           currentUser.value.apiToken != null ? S.of(context).forMoreDetailsPleaseChatWithOurManagers : S.of(context).signinToChatWithOurManagers,
                            //           overflow: TextOverflow.ellipsis,
                            //           maxLines: 3,
                            //           style: Theme.of(context).textTheme.bodyText1,
                            //         ),
                            //       ),
                            //       SizedBox(width: 10),
                            //       SizedBox(
                            //         width: 42,
                            //         height: 42,
                            //         child: MaterialButton(
                            //           elevation: 0,
                            //           padding: EdgeInsets.all(0),
                            //           disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                            //           onPressed: currentUser.value.apiToken != null
                            //               ? () {
                            //                   Navigator.of(context).pushNamed('/Chat',
                            //                       arguments: RouteArgument(
                            //                           param: new Conversation(
                            //                               _con.market.users.map((e) {
                            //                                 e.image = _con.market.image;
                            //                                 return e;
                            //                               }).toList(),
                            //                               name: _con.market.name)));
                            //                 }
                            //               : null,
                            //           child: Icon(
                            //             Icons.chat_outlined,
                            //             color: Theme.of(context).primaryColor,
                            //             size: 24,
                            //           ),
                            //           color: Theme.of(context).accentColor.withOpacity(0.9),
                            //           shape: StadiumBorder(),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              color: Theme.of(context).primaryColor,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _con.market.address ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: MaterialButton(
                                      elevation: 0,
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            '/Pages',
                                            arguments: new RouteArgument(
                                                id: '1', param: _con.market));
                                      },
                                      child: Icon(
                                        Icons.directions_outlined,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // TODO: Boton de contacto
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 20),
                            //   margin: const EdgeInsets.symmetric(vertical: 5),
                            //   color: Theme.of(context).primaryColor,
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: <Widget>[
                            //       Expanded(
                            //         child: Text(
                            //           '${_con.market.phone} \n${_con.market.mobile}',
                            //           overflow: TextOverflow.ellipsis,
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .bodyText1,
                            //         ),
                            //       ),
                            //       SizedBox(width: 10),
                            //       SizedBox(
                            //         width: 42,
                            //         height: 42,
                            //         child: MaterialButton(
                            //           elevation: 0,
                            //           padding: EdgeInsets.all(0),
                            //           onPressed: () {
                            //             launch("tel:${_con.market.mobile}");
                            //           },
                            //           child: Icon(
                            //             Icons.call_outlined,
                            //             color: Theme.of(context).primaryColor,
                            //             size: 24,
                            //           ),
                            //           color: Theme.of(context)
                            //               .accentColor
                            //               .withOpacity(0.9),
                            //           shape: StadiumBorder(),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // _con.featuredProducts.isEmpty
                            //     ? SizedBox(height: 0)
                            //     : Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 20),
                            //         child: ListTile(
                            //           dense: true,
                            //           contentPadding:
                            //               EdgeInsets.symmetric(vertical: 0),
                            //           leading: Icon(
                            //             Icons.shopping_basket_outlined,
                            //             color: Theme.of(context).hintColor,
                            //           ),
                            //           title: Text(
                            //             S.of(context).featured_products,
                            //             style: Theme.of(context)
                            //                 .textTheme
                            //                 .headline4,
                            //           ),
                            //         ),
                            //       ),
                            // _con.featuredProducts.isEmpty
                            //     ? SizedBox(height: 0)
                            //     : ListView.separated(
                            //         padding:
                            //             EdgeInsets.symmetric(vertical: 10),
                            //         scrollDirection: Axis.vertical,
                            //         shrinkWrap: true,
                            //         primary: false,
                            //         itemCount: _con.featuredProducts.length,
                            //         separatorBuilder: (context, index) {
                            //           return SizedBox(height: 10);
                            //         },
                            //         itemBuilder: (context, index) {
                            //           return ProductItemWidget(
                            //             heroTag: 'details_featured_product',
                            //             product: _con.featuredProducts
                            //                 .elementAt(index),
                            //           );
                            //         },
                            //       ),
                            // Nuevo
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              leading: Icon(
                                Icons.bookmark_outline,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).featured_products,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                S
                                    .of(context)
                                    .clickOnTheProductToGetMoreDetailsAboutIt,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            ProductsCarouselWidget(
                                heroTag: 'menu_trending_product',
                                productsList: _con.trendingProducts),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              leading: Icon(
                                Icons.subject,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).products,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                S
                                    .of(context)
                                    .clickOnTheProductToGetMoreDetailsAboutIt,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            _con.categories.isEmpty
                                ? SizedBox(height: 90)
                                : Container(
                                    height: 90,
                                    child: ListView(
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          _con.categories.length, (index) {
                                        var _category =
                                            _con.categories.elementAt(index);
                                        var _selected = this
                                            .selectedCategories
                                            .contains(_category.id);
                                        return Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 20),
                                          child: RawChip(
                                            elevation: 0,
                                            label: Text(_category.name),
                                            labelStyle: _selected
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor))
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 15),
                                            backgroundColor: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.1),
                                            selectedColor:
                                                Theme.of(context).accentColor,
                                            selected: _selected,
                                            //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                                            showCheckmark: false,
                                            avatar: (_category.id == '0')
                                                ? null
                                                : (_category.image.url
                                                        .toLowerCase()
                                                        .endsWith('.svg')
                                                    ? SvgPicture.network(
                                                        _category.image.url,
                                                        color: _selected
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Theme.of(context)
                                                                .accentColor,
                                                      )
                                                    : CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: _category
                                                            .image.icon,
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          'assets/img/loading.gif',
                                                          fit: BoxFit.cover,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons
                                                                .error_outline),
                                                      )),
                                            onSelected: (bool value) {
                                              setState(() {
                                                if (_category.id == '0') {
                                                  this.selectedCategories = [
                                                    '0'
                                                  ];
                                                } else {
                                                  this
                                                      .selectedCategories
                                                      .removeWhere((element) =>
                                                          element == '0');
                                                }
                                                if (value) {
                                                  this
                                                      .selectedCategories
                                                      .add(_category.id);
                                                } else {
                                                  this
                                                      .selectedCategories
                                                      .removeWhere((element) =>
                                                          element ==
                                                          _category.id);
                                                }
                                                _con.selectCategory(
                                                    this.selectedCategories);
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                            _con.products.isEmpty
                                ? CircularLoadingWidget(height: 250)
                                : ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: _con.products.length,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 10);
                                    },
                                    itemBuilder: (context, index) {
                                      return ProductItemWidget(
                                        heroTag: 'menu_list',
                                        product: _con.products.elementAt(index),
                                      );
                                    },
                                  ),
                            // Nuevo
                            SizedBox(height: 100),
                            _con.reviews.isEmpty
                                ? SizedBox(height: 5)
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 0),
                                      leading: Icon(
                                        Icons.recent_actors_outlined,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      title: Text(
                                        S.of(context).what_they_say,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ),
                            _con.reviews.isEmpty
                                ? SizedBox(height: 5)
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: ReviewsListWidget(
                                      reviewsList: _con.reviews,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 32,
                    right: 20,
                    child: ShoppingCartFloatButtonWidget(
                      iconColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).hintColor,
                      routeArgument: RouteArgument(
                        id: '0',
                        param: _con.market.id,
                        heroTag: 'home_slide',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
