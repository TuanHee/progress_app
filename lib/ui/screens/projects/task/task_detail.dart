import 'package:flutter/material.dart';
import 'package:progress_app/models/attachment.dart';
import 'package:progress_app/models/task.dart';
import 'package:progress_app/shared/constants.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({ Key? key }) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  
  @override
  Widget build(BuildContext context) {
    final Task task =
        ModalRoute.of(context)!.settings.arguments as Task;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.attachment),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding * .5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CompleteButton(
                        completed: task.completed,
                        onPressed: () {
                          setState(() {
                            task.completed = !task.completed;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * .5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        blurRadius: 10,
                        color: kPrimaryColor.withOpacity(.15)
                      )
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FractionColumnWidth(.3),
                    },
                    children: [
                      TableRow(
                        children: [
                          const TaskTableCeil(value: "Priority"),
                          TaskTableCeil(value: task.priority),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TaskTableCeil(value: "Start Date"),
                          TaskTableCeil(value: task.startAt ?? '-'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TaskTableCeil(value: "Due Date"),
                          TaskTableCeil(value: task.dueAt ?? '-'),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TaskTableCeil(value: "Description"),
                          TaskTableCeil(value: task.description ?? "-"),
                        ],
                      ),
                      if (task.attachments!.isNotEmpty)
                        TableRow(
                          children: [
                            const TaskTableCeil(value: "Attachments"),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * .3),
                              margin: const EdgeInsets.only(bottom: kDefaultPadding * .5),
                              child: Column(
                                children: attachments(task),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(kDefaultPadding * .5),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task.comments!.length} Comments',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ), 
                  ...comments(task)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> attachments(Task task) {
    return task.attachments!.map((attachment) => AttachmentItem(attachment: attachment)).toList();
  }

  List<Widget> comments(Task task) {
    return task.comments!.map((comment) => Padding(
      padding: const EdgeInsets.only(
        bottom: kDefaultPadding * .5,
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              comment.member.user!.profileUrl,
              width: 35,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: comment.member.user!.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kPrimaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: " "+ comment.createdAt,
                        style: const TextStyle(
                          color: Colors.grey,
                        )
                      )
                    ]
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comment.content,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    )).toList();
  } 

}

class TaskTableCeil extends StatelessWidget {
  const TaskTableCeil({
    Key? key, required this.value
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * .3),
      child: Text(value),
    );
  }
}

class CompleteButton extends StatelessWidget {
  const CompleteButton({
    Key? key, required this.completed, required this.onPressed,
  }) : super(key: key);

  final bool completed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Color getForegroundColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };

      if (states.any(interactiveStates.contains)) {
        return Colors.green.shade600;
      }
      return completed == true ? Colors.green.shade600 : Colors.grey.shade600;
    }

    Color getBackgroundColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };

      if (states.any(interactiveStates.contains)) {
        return Colors.greenAccent.shade100;
      }
      return completed == true ? Colors.greenAccent.shade100 : Colors.grey.shade100;
    }

    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(getForegroundColor),
        backgroundColor: MaterialStateProperty.resolveWith(getBackgroundColor),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check,
            size: 18,
          ),
          const SizedBox(width: 5),
          Text(
            completed ? "Completed" : "Mark complete",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class AttachmentItem extends StatelessWidget {
  const AttachmentItem({ Key? key, required this.attachment }) : super(key: key);

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    if (attachment.type == 'url') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * .5),
        child: Row(
          children: [
            const Icon(
              Icons.link,
              size: 20,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                attachment.link,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else if (['jpg', 'png'].contains(attachment.type)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * .5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "http://192.168.0.187:8000"+ attachment.link,
              headers: const {"Connection": "keep-alive"},
              width: 75,
              // loadingBuilder: (context, child, progress) {
              //   return progress == null
              //     ? child
              //     : LinearProgressIndicator(value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null);
              // },
              errorBuilder: (context, object, stackTrace) {
                return const Icon(Icons.error_outline_outlined);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(attachment.name!),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     TextButton(
                  //       child: Text("Download"),
                  //       onPressed: () {},
                  //     ),
                  //     TextButton(
                  //       child: Text("Delete"),
                  //       onPressed: () {},
                  //     ),
                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * .5),
        child: Row(
          children: [
            const Icon(
              Icons.attachment_outlined,
              size: 20,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                attachment.link,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
  }
}