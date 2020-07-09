import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/bloc/authentication/user_bloc.dart';
import 'package:mutuuze/bloc/property/agent_property.dart';
import 'package:mutuuze/models/user_object.dart';
import 'package:mutuuze/ui/favourites/favourite_property_card.dart';
import 'package:mutuuze/ui/manager_property/add_property.dart';

class ManagerProperty extends StatefulWidget {
  @override
  _ManagerPropertyState createState() => _ManagerPropertyState();
}

class _ManagerPropertyState extends State<ManagerProperty> {
  final _searchController = TextEditingController();
  final agentPropertyBloc = AgentPropertyBloc();
  final userBloc = UserBloc();

  @override
  void initState() {
    userBloc.loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddProperty())),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 7.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            queryInputBox(_searchController, size, context),
            Expanded(
              child: StreamBuilder<UserObject>(
                stream: userBloc.userStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    agentPropertyBloc.loadPropertyByAgentId(snapshot.data.user.id);
                    return StreamBuilder(
                      stream: agentPropertyBloc.agentPropertyStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.isEmpty) {
                            return Container(child: Text("Hello"),);
                          } else {
                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  Divider(
                                    color: Color(0xFF333333), height: 2.0,
                                  ),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return FavouritePropertyCard(
                                    size, snapshot.data[index]);
                              },
                            );
                      }
                      }
                        return
                        Container
                        (
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget queryInputBox(_searchController, size, context) {
  goToSearchPage(String query) {
    if (query.length > 0) {
//      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> GeneralSearchPage(query)));
    }
  }

  return Container(
    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Material(
              borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
              elevation: 10.0,
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (v) => goToSearchPage(v),
                keyboardType: TextInputType.multiline,
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  fillColor: Colors.transparent,
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  hintText: "      Search",
                ),
              ),
            ),
          ),
        ),
        RawMaterialButton(
          onPressed: () => goToSearchPage(_searchController.text.toString()),
          elevation: 10.0,
          fillColor: Color(0xFFff8000),
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(7.0),
          shape: CircleBorder(),
        ),
      ],
    ),
  );
}
