import 'package:flutter/material.dart';

class ProjectNotes extends StatelessWidget {

  static const routeName = 'project_notes';

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
            itemCount: data.length,
            itemBuilder: (context, index) {
              return EntryItem(data[index]);
            }
          )
        ],
      )
    );
  }
}

// One entry in the multilevel list displayed by this app. (fake data unit)
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]); //optional parameter, if no children parameter, the default is an empty list
  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app. (fake data)
final List<Entry> data = <Entry>[
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
          Entry('Room #1 Note 1'),
          Entry('Room #1 Note 2'),
        ],
      ),
      Entry('Room #2 Name',
        <Entry>[
          Entry('Room #2 Note 1'),
          Entry('Room #2 Note 2'),
        ],
      ),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  @override
  Widget build(BuildContext context) {
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
    if (root.children.isEmpty)
      return ListTile(title: Text(root.title));
    return ExpansionTile(
      initiallyExpanded: root.title.contains('Room')? true: false, //expand all Room notes initailly
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }
}