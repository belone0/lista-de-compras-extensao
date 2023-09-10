import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/shared/components/default_form_field.dart';
import 'package:lista_compras/shared/constants/constants.dart';
import 'package:lista_compras/shared/cubit/cubit.dart';
import 'package:lista_compras/shared/cubit/states.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();
var titleController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();
var formKey = GlobalKey<FormState>();

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
//cubit.titles[cubit.bottomNavigtionIndex],
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
              key: scaffoldKey,
              body: cubit.screens[cubit.bottomNavigtionIndex],
              floatingActionButton: FloatingActionButton(
                backgroundColor: kThemeColorLight,
                child: cubit.floatingButtonIcon,
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit
                          .inserToDatabase(title: titleController.text)
                          .then((value) {
                        Navigator.pop(context);
                        titleController.clear();
                        cubit.changeBottomSheetState(
                            false,
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ));
                      });
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                            (context) => SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          color: Colors.white10,
                                        ),
                                        height: 50,
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 25,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                    color:
                                                        Colors.amber.shade700,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 105,
                                            ),
                                            Text(
                                              'Adicionar Item',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15)),
                                          color: kThemeColorLight,
                                        ),
                                        child: Form(
                                          key: formKey,
                                          child: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(
                                                parent:
                                                    AlwaysScrollableScrollPhysics()),
                                            child: Column(
                                              //mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                DefaultFormField(
                                                  controller: titleController,
                                                  label: 'Novo Item',
                                                  type: TextInputType.text,
                                                  validate: (String? value) {
                                                    if (value!.isEmpty) {
                                                      return 'O titulo não pode estar vazio';
                                                    }
                                                    return null;
                                                  },
                                                  prefix: Icons.title,
                                                ),
                                                SizedBox(
                                                  height: 220,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                            backgroundColor: kThemeColorLight)
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          false, Icon(Icons.edit, color: Colors.white));
                    });

                    cubit.changeBottomSheetState(
                        true, Icon(Icons.add, color: Colors.amber[700]));
                  }
                },
              ),
            );
          }),
    );
  }
}
