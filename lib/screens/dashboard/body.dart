import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/shared/project_card.dart';
import 'package:progress_app/shared/title_with_more_btn.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        const SizedBox(height: kDefaultPadding),
        TitleWithMoreBtn(title: "Projects", press: () {}),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ProjectCard(size: size),
              ProjectCard(size: size),
              ProjectCard(size: size),
              ProjectCard(size: size),
              ProjectCard(size: size),
              ProjectCard(size: size),
              SizedBox(width: kDefaultPadding)
            ],
          ),
        )
      ],
    );
  }
}
