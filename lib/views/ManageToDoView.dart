import '../controllers/AlertDialogController.dart';
import '../controllers/TodoController.dart';
import '../models/Todo.dart';
import '../models/CRUD.dart';
import 'CustomShadowTextField.dart';
import 'package:flutter/material.dart';

class ManageToDoView extends StatelessWidget {
  const ManageToDoView({
    super.key,
    required this.todoController,
    required this.alertDialogController,
    required this.tTextController,
    required this.dTextController,
    required this.pageController,
    required this.crud,
    this.todo,
  });

  final TodoController todoController;
  final AlertDialogController alertDialogController;
  final TextEditingController tTextController;
  final TextEditingController dTextController;
  final PageController pageController;
  final CRUD crud;
  final Todo? todo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //Main Title
            Container(
              alignment: Alignment.center,
              child: Text(
                crud == CRUD.C ? "Add Todo" : "Update Todo",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //Title Text Field
            CustomShadowTextField(
              textController: tTextController,
              title: 'Title',
              hintText: 'Ex: To Do',
              maxLines: 1,
            ),
            //Description
            CustomShadowTextField(
                textController: dTextController,
                title: 'Title',
                hintText: 'Ex: To Dp',
                maxLines: 5),
            //Add To do Button
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  if (tTextController.text == "") {
                    alertDialogController.displayAlertDialog(
                        context, crud, "Title cannot be empty");
                    return;
                  }

                  if (dTextController.text == "") {
                    alertDialogController.displayAlertDialog(
                        context, crud, "Description cannot be empty");
                    return;
                  }

                  switch (crud) {
                    case CRUD.C:
                      DateTime now = DateTime.now();
                      int millisecondsSinceEpoch = now.millisecondsSinceEpoch;
                      String epochTime = millisecondsSinceEpoch.toString();
                      var newTodo = Todo(
                        id: '',
                        title: tTextController.text,
                        description: dTextController.text,
                        isCompleted: false,
                        isDescDisplayed: false,
                        timestamp: epochTime,
                      );
                      todoController.addTodo(newTodo);

                      //Hide the keyboard
                      FocusScope.of(context).unfocus();

                      pageController.animateToPage(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      break;
                    case CRUD.U:
                      todo?.title = tTextController.text;
                      todo?.description = dTextController.text;
                      todoController.updateTodo(todo!);
                      Navigator.pop(context);
                      break;
                    default:
                      break;
                  }

                  tTextController.text = "";
                  dTextController.text = "";
                },
                child: Text(crud == CRUD.C ? 'Add Todo' : 'Update Todo'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
