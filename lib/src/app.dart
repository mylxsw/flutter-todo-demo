import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/logic/cubit/catalog_cubit.dart';
import 'package:todo/src/logic/cubit/todo_cubit.dart';
import 'package:todo/src/presentation/add_todo_screen.dart';
import 'package:todo/src/presentation/message_box_screen.dart';
import 'package:todo/src/presentation/setting_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _pages = {
    "messageBox": <Widget>[const Text('收件箱'), const MessageBoxScreen()],
    "setting": <Widget>[const Text('设置'), const SettingScreen()],
  };

  String _currentPage = "messageBox";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _pages[_currentPage]?[0],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonTapped,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: buildBottomAppBar(),
      drawer: buildDrawer(),
      body: _pages[_currentPage]?[1],
    );
  }

  void _onBottomMenuItemTapped(String name) {
    setState(() {
      _currentPage = name;
    });
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              icon: const Icon(Icons.today),
              onPressed: () {
                _onBottomMenuItemTapped("messageBox");
              }),
          const SizedBox(),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _onBottomMenuItemTapped("setting");
              }),
        ],
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("TODO",
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "http://t13.baidu.com/it/u=2296451345,460589639&fm=224&app=112&f=JPEG?w=500&h=500",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(width: 10),
                        Text("次奥o(*////▽////*)q",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Text("ciaoxiuxiu@google.com",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text("站内信"),
              onTap: () {}),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text("个人中心"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("退出"),
            onTap: () {},
          )
        ],
      ),
    );
  }

  void _onAddButtonTapped() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(providers: [
          BlocProvider.value(value: context.read<TodoCubit>()),
          BlocProvider.value(value: context.read<CatalogCubit>()),
        ], child: const AddScreen()),
      ),
    );
  }
}
