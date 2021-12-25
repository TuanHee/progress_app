import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding,
      ),
      width: size.width / 2,
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 30,
                color: kPrimaryColor.withOpacity(0.15)
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding * .5),
                child: Row(
                  children: [
                    Icon(Icons.list_alt_outlined, color: Colors.black54, size: 20),
                    SizedBox(width: 3),
                    Text("1/10"),
                    Spacer(),
                    Icon(Icons.people_alt_outlined, color: Colors.black54, size: 20,),
                    SizedBox(width: 3),
                    CircleAvatar(radius: 10,),
                    CircleAvatar(radius: 10,),
                    CircleAvatar(radius: 10,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding * 0.5),
                child: Text(
                  "2/12/2021",
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
