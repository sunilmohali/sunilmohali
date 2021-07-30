import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/category.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Category category;
  CategoriesCarouselItemWidget({Key key, this.marginLeft, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context)
            .pushNamed('/Category', arguments: RouteArgument(id: category.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: category.id,
            child: Container(
              margin:
                  EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
              width: 120,
              height: 120,
              // decoration: BoxDecoration(
              //   color: Theme.of(context).primaryColor,
              //   // color: Colors.red,
              //   borderRadius: BorderRadius.all(Radius.circular(5)),
              //   boxShadow: [
              //     BoxShadow(
              //         color: Theme.of(context).focusColor.withOpacity(0.2),
              //         offset: Offset(0, 2),
              //         blurRadius: 7.0)
              //   ],
              // ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: category.image.url.toLowerCase().endsWith('.svg')
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SvgPicture.network(
                          category.image.url,
                          //color: Theme.of(context).accentColor,
                        ),
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: category.image.url,
                          placeholder: (context, url) => Image.asset(
                            'assets/img/loading.gif',
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline),
                        ),
                    ),
              ),
            ),
          ),
          // SizedBox(height: 5),
          // Container(
          //   margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
          //   child: Text(
          //     category.name,
          //     overflow: TextOverflow.ellipsis,
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          // ),
        ],
      ),
    );
  }
}
