import 'package:flutter/material.dart';

class ProjectNotes extends StatefulWidget {

  static const routeName = 'project_notes';

  @override
  _ProjectNotesState createState() => _ProjectNotesState();
}

class _ProjectNotesState extends State<ProjectNotes> {

  // The entire multilevel list displayed by this app. (fake data)
  List<Entry> data = <Entry>[
    Entry('General Notes',
      <Entry>[
        Entry('General Note 1 long long long long long long long long long long long long long long long long note'),
        Entry('General Note 2'),
        Entry('General Note 3'),
      ],
    ),
    Entry('Room Notes',
      <Entry>[
        Entry('Room #1 Name',
          <Entry>[
            Entry('Room #1 Note 1',[],[{'key': 'object A', 'value': 224}, {'key': 'object B', 'value': 12.12}]),
            Entry('Room #1 Note 2'),
          ],
        ),
        Entry('Room #2 Name',
          <Entry>[
            Entry('Room #2 Note 1'),
            Entry('Room #2 Note 2',[],[{'key': 'object E', 'value': 20}, {'key': 'object F', 'value': 60}]),
          ],
        ),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Notes'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/note.png'), fit: BoxFit.fill))
          ),
          ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return EntryItem(data[index], index, delete);
            }
          ),
        ],
      )
    );
  }

  //the delete function
  void delete(int index, int roomIndex, int noteIndex) {
    setState(() {
      if(index == 0) {
        data[index].children.removeAt(noteIndex);
      } else {
        data[index].children[roomIndex].children.removeAt(noteIndex);
        if(data[index].children[roomIndex].children.isEmpty) {
          data[index].children.removeAt(roomIndex);
        }
      }
    });
  }
}

// One entry in the multilevel list displayed by this app. (fake data unit)
class Entry {
  Entry(this.title, [this.children = const <Entry>[], this.estimateItem = const <Map<String,dynamic>>[]]); //optional parameter, if no children parameter, the default is an empty list
  final String title;
  final List<Entry> children;
  final List<Map<String,dynamic>> estimateItem;
  int roomIndex = -99; //for tracking room index
  int noteIndex = -99; //for tracking each note item
}

// Displays one Entry. If the entry has children then it's displayed with an ExpansionTile.
class EntryItem extends StatelessWidget {
  EntryItem(this.entry, this.index, this.delete);
  int index;
  final Entry entry;
  Function(int, int, int) delete;

  //there three kinds of indexes are used to track each item in the data
  int roomIndex = -2; //for tracking room index
  int roomIndexKeep = -99; //for helping restarting noteIndex for each room
  int noteIndex = -1; //for tracking each note item

  @override
  Widget build(BuildContext context) {
    roomIndex = -2;
    noteIndex = -1;
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.brown, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4), 
      child: _buildTiles(entry) 
    );
  }

  Widget _buildTiles(Entry root) {

    //assign index to each entry, so later each item can be tracked
    if (root.children.isEmpty)
    {
      if(index == 0) { //index: 0 means "General Note" area, index:1 means "Room Note" area
        noteIndex++;
        root.noteIndex = noteIndex;
      } else {
        if(roomIndex != roomIndexKeep) { //if these two type of indexes are not the same, restart the coutn of noteIndex
          noteIndex = -1;
          roomIndexKeep = roomIndex;
        }
        noteIndex++;
        root.noteIndex = noteIndex;
        root.roomIndex = roomIndex;  
      }

      //Assign layout to each entry object
      if(root.title == "General Notes" || root.title == "Room Notes") 
        return ListTile(title: Text(root.title), trailing:Text('empty', style: TextStyle(color: Colors.red)));
      else if(root.estimateItem.isEmpty)
      {
        return ListTile(title: Text(root.title), trailing: RaisedButton(onPressed: () {
          //print('$index, ${root.roomIndex}, ${root.noteIndex}');
          delete(index, root.roomIndex, root.noteIndex);
        }, child: Text('delete')));
      }
      else
        return CustomTile(title: Text(root.title), items: root.estimateItem, trailing: RaisedButton(onPressed: () {
          //print('$index, ${root.roomIndex}, ${root.noteIndex}');
          delete(index, root.roomIndex, root.noteIndex);
        }, child: Text('delete')));
    }
    roomIndex++;  //for tracking room index
    return ExpansionTile(
      initiallyExpanded: root.title.contains('Room')? true: false, //expand all Room notes initailly
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }
}

class CustomTile extends StatelessWidget {
  final Widget title;
  final List<Map<String,dynamic>> items;
  final Widget trailing;
  CustomTile({Key key, this.title, this.items, this.trailing}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle( //it is used for runtime text change, but here just take advantage of its style change addition
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  duration: kThemeChangeDuration,
                  child: title
                ),
                Table(
                  children: items.map<TableRow>(_buildTableRow).toList()
                  // [
                  //   TableRow(children: [
                  //     Text('test1'), Text('test2')
                  //   ]),
                  //   TableRow(children: [
                  //     Text('test3'), Text('test4')
                  //   ])
                  // ]
                )
              ],
            ),
          ),
          Container(child: trailing)
        ]
      ),
    );
  }
  TableRow _buildTableRow(Map item) {
    return TableRow(children: [
      Text(item['key']), Text("\$${item['value']}")
    ]);
  }
}