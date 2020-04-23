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
            padding: EdgeInsets.only(top: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return EntryItem(data[index]);
            }
          ),
        ],
      )
    );
  }
}

// One entry in the multilevel list displayed by this app. (fake data unit)
class Entry {
  Entry(this.title, [this.children = const <Entry>[], this.estimateItem = const <Map<String,dynamic>>[]]); //optional parameter, if no children parameter, the default is an empty list
  final String title;
  final List<Entry> children;
  final List<Map<String,dynamic>> estimateItem;
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
    {
      if(root.estimateItem.isEmpty)
        return ListTile(title: Text(root.title));
      else
        return CustomTile(title: Text(root.title), items: root.estimateItem);
    }
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
  const CustomTile({Key key, this.title, this.items}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
    );
  }
  TableRow _buildTableRow(Map item) {
    return TableRow(children: [
      Text(item['key']), Text("\$${item['value']}")
    ]);
  }
}