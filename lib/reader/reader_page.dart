import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/book_service.dart';

class ReaderPage extends StatefulWidget {
  final int startPage;
  ReaderPage({required this.startPage});

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  List<dynamic> sections = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadBook();
    currentPage = widget.startPage;
  }

  Future<void> _loadBook() async {
    final data = await BookService.loadFilteredSections();
    setState(() => sections = data);
  }

  Future<void> _saveProgress(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastPage', page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lecture"),
        backgroundColor: Colors.green[800],
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.green[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[800]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.menu_book, size: 50, color: Colors.amber[700]),
                  SizedBox(height: 10),
                  Text(
                    "Menu",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ...sections.map(
              (section) => ListTile(
                title: Text(
                  section['title'],
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    currentPage = sections.indexOf(section);
                    _saveProgress(currentPage);
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body:
          sections.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5DC),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sections[index]['title'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              sections[index]['content'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
