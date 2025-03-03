// lib/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_assignment_1/shimmer_loading.dart';
import 'package:project_assignment_1/user_bloc.dart';
import 'package:project_assignment_1/user_model.dart';
import 'package:project_assignment_1/userdetail_screen.dart';

import 'add_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUsers(page: 1));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isSearching) return;

    if (_isBottom) {
      final state = context.read<UserBloc>().state;
      if (state is UsersLoaded && !state.hasReachedMax) {
        context.read<UserBloc>().add(LoadUsers(page: state.currentPage + 1));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
    
    if (query.isEmpty) {
      context.read<UserBloc>().add(LoadUsers(page: 1));
    } else {
      context.read<UserBloc>().add(SearchUsers(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,  // Add this line to remove back button
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration:const InputDecoration(
                  hintText: 'Search users...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color.fromARGB(179, 5, 5, 5)),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 11, 11, 11)),
                onChanged: _performSearch,
                autofocus: true,
              )
            : Text('Users Directory'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _performSearch('');
                }
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    if (_isSearching) {
                      context.read<UserBloc>().add(SearchUsers(query: _searchQuery));
                    } else {
                      context.read<UserBloc>().add(LoadUsers(page: 1));
                    }
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserInitial || state is UserLoading && state is! UsersLoaded) {
            return UserListShimmer();
          } else if (state is UsersLoaded) {
            return _buildUsersList(state.users, state.hasReachedMax);
          } else if (state is UsersSearched) {
            return _buildUsersList(state.users, true);
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something went wrong'),
                  ElevatedButton(
                    onPressed: () => context.read<UserBloc>().add(LoadUsers(page: 1)),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          );
          
          if (result == true) {
            // Refresh the list after adding a new user
            context.read<UserBloc>().add(LoadUsers(page: 1));
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add New User',
      ),
    );
  }

  Widget _buildUsersList(List<UserModel> users, bool hasReachedMax) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isSearching ? 'No users matching "$_searchQuery"' : 'No users found',
              style: TextStyle(fontSize: 16),
            ),
            if (!_isSearching)
              ElevatedButton(
                onPressed: () => context.read<UserBloc>().add(LoadUsers(page: 1)),
                child: Text('Refresh'),
              ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      controller: _scrollController,
      itemCount: users.length + (hasReachedMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (index >= users.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final user = users[index];
        return Hero(
          tag: 'user-${user.id}',
          child: Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.email),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsScreen(userId: user.id),
                  ),
                );
                
                if (result == true) {
                  // Refresh the list if user was updated
                  context.read<UserBloc>().add(LoadUsers(page: 1));
                }
              },
            ),
          ),
        );
      },
    );
  }
}