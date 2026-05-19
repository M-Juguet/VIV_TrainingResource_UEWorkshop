import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:training_toolkit/theme.dart';
import 'package:training_toolkit/models/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(1280, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const UnrealWindowsApp());
}

class UnrealWindowsApp extends StatelessWidget {
  const UnrealWindowsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Training Toolkit',
      theme: SaasTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const WindowsMainScaffold(),
    );
  }
}

class WindowsMainScaffold extends StatefulWidget {
  const WindowsMainScaffold({super.key});

  @override
  State<WindowsMainScaffold> createState() => _WindowsMainScaffoldState();
}

class _WindowsMainScaffoldState extends State<WindowsMainScaffold> {
  int _selectedSessionIndex = -1;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _mainScrollController = ScrollController();

  bool _isSidebarCollapsed = false;
  static const double _collapsedWidth = 64.0;
  static const double _expandedWidth = 350.0;

  String? _activeFullscreenImage;
  final Set<String> _bookmarkedModuleIds = {};
  String? _targetModuleId;

  List<SessionModel> get _filteredSessions {
    if (_searchQuery.isEmpty) return unrealSessions;
    final allSessions = [...basicsSessions, ...unrealSessions];
    return allSessions
        .where(
          (s) =>
              s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.id.toString() == _searchQuery,
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('unreal_bookmarks_v1');
    if (saved != null) {
      setState(() {
        _bookmarkedModuleIds.clear();
        _bookmarkedModuleIds.addAll(saved);
      });
    }
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'unreal_bookmarks_v1',
      _bookmarkedModuleIds.toList(),
    );
  }

  void _toggleBookmark(String moduleId) {
    setState(() {
      if (_bookmarkedModuleIds.contains(moduleId)) {
        _bookmarkedModuleIds.remove(moduleId);
      } else {
        _bookmarkedModuleIds.add(moduleId);
      }
    });
    _saveBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _closeFullscreen,
      },
      child: Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                _buildModernSidebar(),
                Expanded(
                  child: Container(
                    color: SaasTheme.background,
                    child: SingleChildScrollView(
                      controller: _mainScrollController,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(60, 110, 60, 60),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              layoutBuilder:
                                  (
                                    Widget? currentChild,
                                    List<Widget> previousChildren,
                                  ) {
                                    return Stack(
                                      alignment: Alignment.topCenter,
                                      children: <Widget>[
                                        ...previousChildren,
                                        if (currentChild != null) currentChild,
                                      ],
                                    );
                                  },
                              child: _buildMainContent(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildWindowsTopBar(),
            if (_activeFullscreenImage != null) _buildFullscreenOverlay(),
          ],
        ),
      ),
    );
  }

  void _closeFullscreen() async {
    if (_activeFullscreenImage != null) {
      if (await windowManager.isFullScreen()) {
        await windowManager.setFullScreen(false);
      }
      setState(() => _activeFullscreenImage = null);
    }
  }

  Widget _buildFullscreenOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.95),
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: _closeFullscreen,
                child: Hero(
                  tag: _activeFullscreenImage!,
                  child: InteractiveViewer(
                    maxScale: 4.0,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      child: _buildImageOrPlaceholder(_activeFullscreenImage!),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Row(
                children: [
                  _hudButton(Icons.fullscreen_rounded, "Immersion", () async {
                    bool isFull = await windowManager.isFullScreen();
                    windowManager.setFullScreen(!isFull);
                  }),
                  const SizedBox(width: 12),
                  _hudButton(
                    Icons.close_rounded,
                    "Fermer (Échap)",
                    _closeFullscreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hudButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white24,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildImageOrPlaceholder(String path) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.broken_image_rounded,
                  color: Colors.white24,
                  size: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  'Image non trouvée',
                  style: const TextStyle(color: Colors.white38),
                ),
                Text(
                  path,
                  style: const TextStyle(color: Colors.white12, fontSize: 10),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return _getContentWidget();
  }

  Widget _getContentWidget() {
    if (_selectedSessionIndex == -1) {
      return DashboardBentoView(
        key: const ValueKey('dashboard'),
        sessions: _filteredSessions,
        onSelect: (id) {
          setState(() {
            _selectedSessionIndex = id - 1;
            _targetModuleId = null;
          });
          if (_mainScrollController.hasClients) {
            _mainScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            );
          }
        },
      );
    } else if (_selectedSessionIndex == -50) {
      return ProgrammeView(
        key: const ValueKey('programme'),
        onNavigate: (sessionId, moduleId) {
          setState(() {
            _selectedSessionIndex = sessionId - 1;
            _targetModuleId = moduleId;
          });
          if (_mainScrollController.hasClients) {
            _mainScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            );
          }
        },
      );
    } else if (_selectedSessionIndex == -99) {
      return BookmarksListView(
        bookmarkedIds: _bookmarkedModuleIds,
        onNavigate: (sessionId, moduleId) {
          setState(() {
            _selectedSessionIndex = sessionId - 1;
            _targetModuleId = moduleId;
          });
          if (_mainScrollController.hasClients) {
            _mainScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            );
          }
        },
      );
    } else if (_selectedSessionIndex >= 1000 &&
        _selectedSessionIndex < 1000 + basicsSessions.length) {
      final index = _selectedSessionIndex - 1000;
      return SessionShowcaseView(
        key: ValueKey('basics_$index'),
        session: basicsSessions[index],
        onImageTap: (path) => setState(() => _activeFullscreenImage = path),
        bookmarkedIds: _bookmarkedModuleIds,
        onBookmarkToggle: _toggleBookmark,
        targetModuleId: _targetModuleId,
        onTargetReached: () => _targetModuleId = null,
        nextSessionTitle: index < basicsSessions.length - 1
            ? basicsSessions[index + 1].title
            : unrealSessions[0].title,
        onNextChapter: index < basicsSessions.length - 1
            ? () {
                setState(() {
                  _selectedSessionIndex++;
                  _targetModuleId = null;
                });
                if (_mainScrollController.hasClients) {
                  _mainScrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  );
                }
              }
            : () {
                setState(() {
                  _selectedSessionIndex = 0; // Go to first chapter of training
                  _targetModuleId = null;
                });
                if (_mainScrollController.hasClients) {
                  _mainScrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  );
                }
              },
      );
    } else if (_selectedSessionIndex >= 0 &&
        _selectedSessionIndex < unrealSessions.length) {
      return SessionShowcaseView(
        key: ValueKey('session_${_selectedSessionIndex}'),
        session: unrealSessions[_selectedSessionIndex],
        onImageTap: (path) => setState(() => _activeFullscreenImage = path),
        bookmarkedIds: _bookmarkedModuleIds,
        onBookmarkToggle: _toggleBookmark,
        targetModuleId: _targetModuleId,
        onTargetReached: () => _targetModuleId = null,
        nextSessionTitle: _selectedSessionIndex < unrealSessions.length - 1
            ? unrealSessions[_selectedSessionIndex + 1].title
            : null,
        onNextChapter: _selectedSessionIndex < unrealSessions.length - 1
            ? () {
                setState(() {
                  _selectedSessionIndex++;
                  _targetModuleId = null;
                });
                if (_mainScrollController.hasClients) {
                  _mainScrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  );
                }
              }
            : null,
      );
    }
    return _PlaceholderHeroView(
      key: ValueKey('placeholder_${_selectedSessionIndex}'),
      icon: _selectedSessionIndex == -99 ? Icons.bookmark : Icons.settings,
      title: _selectedSessionIndex == -99 ? "Vos Signets" : "Paramètres",
      subtitle: "Cette section sera bientôt disponible.",
    );
  }

  Widget _buildWindowsTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: DragToMoveArea(
        child: Container(
          height: SaasTheme.topBarHeight,
          decoration: BoxDecoration(
            color: SaasTheme.surface.withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(
                color: SaasTheme.border.withValues(alpha: 0.5),
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _isSidebarCollapsed ? Icons.menu_open : Icons.menu,
                  size: 20,
                  color: SaasTheme.textBody,
                ),
                onPressed: () =>
                    setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TRAINING TOOLKIT',
                    style: SaasTheme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 1.5,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Workshop Avancé Unreal Engine',
                    style: SaasTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 10,
                      color: SaasTheme.textMuted,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 300,
                height: 34,
                decoration: BoxDecoration(
                  color: SaasTheme.background,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: SaasTheme.border),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: SaasTheme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher une session...',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 14,
                      color: SaasTheme.textMuted,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _buildWindowControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWindowControls() {
    return Row(
      children: [
        _controlButton(Icons.remove, () => windowManager.minimize()),
        _controlButton(Icons.crop_square, () async {
          if (await windowManager.isMaximized()) {
            windowManager.unmaximize();
          } else {
            windowManager.maximize();
          }
        }),
        _controlButton(Icons.close, () => windowManager.close(), isClose: true),
      ],
    );
  }

  Widget _controlButton(
    IconData icon,
    VoidCallback onTap, {
    bool isClose = false,
  }) {
    return InkWell(
      onTap: onTap,
      hoverColor: isClose ? Colors.red : Colors.black12,
      child: SizedBox(
        width: 46,
        height: SaasTheme.topBarHeight,
        child: Icon(
          icon,
          size: 16,
          color: isClose ? Colors.black : SaasTheme.textBody,
        ),
      ),
    );
  }

  Widget _buildModernSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: _isSidebarCollapsed ? _collapsedWidth : _expandedWidth,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: SaasTheme.surface,
        border: Border(right: BorderSide(color: SaasTheme.border, width: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(8, 70, 8, 20),
      child: Column(
        crossAxisAlignment: _isSidebarCollapsed
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (!_isSidebarCollapsed) _sidebarSection('MENU'),
          _sidebarItem(Icons.home_filled, 'Accueil', -1),
          _sidebarItem(Icons.assignment_rounded, 'Programme', -50),
          _sidebarItem(Icons.bookmark_rounded, 'Mes Signets', -99),
          const SizedBox(height: 32),
          if (!_isSidebarCollapsed) _sidebarSection('LES BASES'),
          ...List.generate(
            basicsSessions.length,
            (index) => _sidebarItem(
              basicsSessions[index].icon,
              basicsSessions[index].title,
              1000 + index,
            ),
          ),
          const SizedBox(height: 32),
          if (!_isSidebarCollapsed) _sidebarSection('FORMATION'),
          Expanded(
            child: ListView.builder(
              itemCount: unrealSessions.length,
              itemBuilder: (context, index) => _sidebarItem(
                unrealSessions[index].icon,
                unrealSessions[index].title,
                index,
              ),
            ),
          ),
          const Divider(),
          _sidebarItem(Icons.help_outline, 'Aide & Docs', -9999),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData? icon, String title, int index) {
    bool isSelected = _selectedSessionIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSessionIndex = index;
            _targetModuleId = null;
          });
          if (_mainScrollController.hasClients) {
            _mainScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            );
          }
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? SaasTheme.primary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: _isSidebarCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? SaasTheme.primary : SaasTheme.textMuted,
                ),
              if (!_isSidebarCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: SaasTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      fontSize: 13,
                      color: isSelected
                          ? SaasTheme.primary
                          : SaasTheme.textBody,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sidebarSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        title,
        style: SaasTheme.textTheme.labelLarge?.copyWith(
          fontSize: 9,
          color: SaasTheme.textMuted,
        ),
      ),
    );
  }
}

class DashboardBentoView extends StatelessWidget {
  final List<SessionModel> sessions;
  final Function(int) onSelect;
  const DashboardBentoView({
    super.key,
    required this.sessions,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('APERÇU DU PROGRAMME', style: SaasTheme.textTheme.labelLarge),
            const SizedBox(width: 12),
            const Icon(Icons.verified, size: 14, color: SaasTheme.primary),
          ],
        ),
        Text(
          'Maîtrisez Unreal Engine.',
          style: SaasTheme.textTheme.displayLarge,
        ),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 900
                ? 3
                : (constraints.maxWidth > 600 ? 2 : 1);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) => _SessionCard(
                session: sessions[index],
                onTap: () => onSelect(sessions[index].id),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SessionCard extends StatefulWidget {
  final SessionModel session;
  final VoidCallback onTap;
  const _SessionCard({required this.session, required this.onTap});
  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: SaasTheme.surface,
            borderRadius: BorderRadius.circular(SaasTheme.bentoRadius),
            boxShadow: _isHovered ? SaasTheme.subtleShadow : [],
            border: Border.all(
              color: _isHovered ? SaasTheme.primary : SaasTheme.border,
              width: _isHovered ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? SaasTheme.primary.withValues(alpha: 0.1)
                          : SaasTheme.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.session.icon,
                      size: 20,
                      color: _isHovered
                          ? SaasTheme.primary
                          : SaasTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'CHAPITRE ${widget.session.id.toString().padLeft(2, '0')}',
                    style: SaasTheme.textTheme.labelLarge?.copyWith(
                      color: _isHovered
                          ? SaasTheme.primary
                          : SaasTheme.textMuted,
                    ),
                  ),
                  const Spacer(),
                  if (_isHovered)
                    const Icon(
                      Icons.play_circle_fill,
                      size: 24,
                      color: SaasTheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Text(
                  widget.session.title,
                  style: SaasTheme.textTheme.headlineMedium?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'DÉMARRER LE MODULE',
                    style: SaasTheme.textTheme.labelLarge?.copyWith(
                      fontSize: 10,
                      color: _isHovered
                          ? SaasTheme.primary
                          : SaasTheme.textMuted,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: _isHovered ? SaasTheme.primary : SaasTheme.textMuted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionShowcaseView extends StatefulWidget {
  final SessionModel session;
  final Function(String) onImageTap;
  final Set<String> bookmarkedIds;
  final Function(String) onBookmarkToggle;
  final String? targetModuleId;
  final VoidCallback onTargetReached;

  const SessionShowcaseView({
    super.key,
    required this.session,
    required this.onImageTap,
    required this.bookmarkedIds,
    required this.onBookmarkToggle,
    this.targetModuleId,
    required this.onTargetReached,
    this.nextSessionTitle,
    this.onNextChapter,
  });
  final String? nextSessionTitle;
  final VoidCallback? onNextChapter;

  @override
  State<SessionShowcaseView> createState() => _SessionShowcaseViewState();
}

class _SessionShowcaseViewState extends State<SessionShowcaseView> {
  final Map<String, GlobalKey> _moduleKeys = {};

  @override
  void initState() {
    super.initState();
    _checkScrollToTarget();
  }

  @override
  void didUpdateWidget(SessionShowcaseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetModuleId != null &&
        widget.targetModuleId != oldWidget.targetModuleId) {
      _checkScrollToTarget();
    }
  }

  void _checkScrollToTarget() {
    if (widget.targetModuleId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _moduleKeys[widget.targetModuleId];
        if (key != null && key.currentContext != null) {
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            alignment: 0.2, // Offset to not be sticked to top bar
          ).then((_) => widget.onTargetReached());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(widget.session),
          const SizedBox(height: 24),
          Text(widget.session.title, style: SaasTheme.textTheme.displayLarge),
          const SizedBox(height: 12),
          Text(
            widget.session.objective,
            style: SaasTheme.textTheme.bodyLarge?.copyWith(
              color: SaasTheme.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 48),
          if (widget.session.modules.isEmpty)
            _buildLegacyContent(widget.session)
          else
            ...widget.session.modules.map((module) => _renderModule(module)),
          const SizedBox(height: 80),
          _showcaseHeader('PROJET FIL ROUGE'),
          const SizedBox(height: 24),
          _FilRougeCard(content: widget.session.filRouge),
          _buildFooterNavigation(),
        ],
      ),
    );
  }

  Widget _buildFooterNavigation() {
    if (widget.onNextChapter == null || widget.nextSessionTitle == null) {
      return const SizedBox(height: 100);
    }
    return _NextChapterButton(
      nextSessionTitle: widget.nextSessionTitle!,
      onTap: widget.onNextChapter!,
    );
  }

  Widget _renderModule(ContentModule module) {
    bool isBookmarked = widget.bookmarkedIds.contains(module.id);
    _moduleKeys.putIfAbsent(module.id, () => GlobalKey());

    return Padding(
      key: _moduleKeys[module.id],
      padding: const EdgeInsets.only(bottom: 64),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (module is TitleModule) {
                  return _buildSectionTitle(module.title, isMain: true);
                } else if (module is TextModule) {
                  final paragraphs = module.content.split('\n');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (module.title != null) ...[
                        _buildSectionTitle(module.title!),
                        const SizedBox(height: 32),
                      ],
                      ...paragraphs
                          .where((p) => p.trim().isNotEmpty)
                          .map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                p.trim(),
                                style: SaasTheme.textTheme.bodyLarge?.copyWith(
                                  height: 1.7,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                    ],
                  );
                } else if (module is SideBySideModule) {
                  bool isTextLeft = module.layout == ContentLayout.textLeft;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (module.title != null)
                        _buildSectionTitle(module.title!),
                      if (module.title != null) const SizedBox(height: 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isTextLeft)
                            Expanded(
                              child: _buildModuleText(null, module.content),
                            ),
                          if (isTextLeft) const SizedBox(width: 48),
                          Expanded(
                            child: _buildClickableMedia(
                              module.imagePath,
                              height: 350,
                              caption: module.caption,
                            ),
                          ),
                          if (!isTextLeft) const SizedBox(width: 48),
                          if (!isTextLeft)
                            Expanded(
                              child: _buildModuleText(null, module.content),
                            ),
                        ],
                      ),
                    ],
                  );
                } else if (module is FullMediaModule) {
                  return _buildClickableMedia(
                    module.imagePath,
                    height: 450,
                    isFullWidth: true,
                    caption: module.caption,
                  );
                } else if (module is InfoModule) {
                  Color primaryColor;
                  IconData icon;
                  String label;

                  switch (module.type) {
                    case InfoType.idea:
                      primaryColor = Colors.amber.shade700;
                      icon = Icons.lightbulb_outline_rounded;
                      label = "IDÉE";
                      break;
                    case InfoType.tip:
                      primaryColor = Colors.purple.shade400;
                      icon = Icons.auto_awesome_outlined;
                      label = "CONSEIL EXPERT";
                      break;
                    case InfoType.warning:
                      primaryColor = Colors.redAccent.shade400;
                      icon = Icons.warning_amber_rounded;
                      label = "ATTENTION";
                      break;
                    case InfoType.info:
                      primaryColor = Colors.blue.shade600;
                      icon = Icons.info_outline_rounded;
                      label = "INFORMATION";
                      break;
                    case InfoType.objective:
                      primaryColor = const Color(0xFF0052CC); // Deep Blue
                      icon = Icons.track_changes_rounded;
                      label = "OBJECTIF";
                      break;
                    case InfoType.challenge:
                      primaryColor = Colors.orange.shade800;
                      icon = Icons.outlined_flag_rounded;
                      label = "FIL ROUGE / CHALLENGE";
                      break;
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(icon, color: primaryColor, size: 24),
                            const SizedBox(width: 16),
                            Text(
                              '$label :',
                              style: SaasTheme.textTheme.labelLarge?.copyWith(
                                color: primaryColor,
                                fontSize: 13,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 40,
                          ), // 24 (icon) + 16 (gap)
                          child: Text(
                            module.text,
                            style: SaasTheme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (module is ResourceModule) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.cloud_download_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                module.title.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                module.fileName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                module.description,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final uri = Uri.parse(module.downloadUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade800,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            children: [
                              Text('RÉCUPÉRER'),
                              SizedBox(width: 8),
                              Icon(Icons.open_in_new_rounded, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (module is ListModule) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(module.title),
                      const SizedBox(height: 32),
                      if (module.intro != null) ...[
                        Text(
                          module.intro!,
                          style: SaasTheme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      ...module.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 16, left: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: SaasTheme.primary,
                                  size: 12,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item,
                                  style: SaasTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                        fontSize: 16,
                                        height: 1.6,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (module.outro != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          module.outro!,
                          style: SaasTheme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ],
                  );
                } else if (module is QuizModule) {
                  return QuizModuleWidget(module: module);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(width: 32),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: Icon(
                isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_outline_rounded,
                color: isBookmarked
                    ? SaasTheme.primary
                    : SaasTheme.textMuted.withValues(alpha: 0.15),
                size: 18,
              ),
              onPressed: () => widget.onBookmarkToggle(module.id),
              tooltip: isBookmarked
                  ? 'Supprimer le signet'
                  : 'Ajouter un signet',
              padding: EdgeInsets.zero,
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableMedia(
    String path, {
    double height = 200,
    bool isFullWidth = false,
    String? caption,
  }) {
    return Column(
      crossAxisAlignment: isFullWidth
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.zoomIn,
          child: GestureDetector(
            onTap: () => widget.onImageTap(path),
            child: Hero(
              tag: path,
              child: Container(
                height: height,
                width: isFullWidth ? double.infinity : null,
                decoration: BoxDecoration(
                  color: SaasTheme.surface,
                  borderRadius: BorderRadius.circular(isFullWidth ? 24 : 16),
                  border: Border.all(color: SaasTheme.border),
                  boxShadow: isFullWidth ? SaasTheme.subtleShadow : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isFullWidth ? 24 : 16),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: height,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: SaasTheme.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Image manquante',
                              style: SaasTheme.textTheme.bodySmall?.copyWith(
                                color: SaasTheme.textMuted,
                              ),
                            ),
                            Text(
                              path.split('/').last,
                              style: SaasTheme.textTheme.bodySmall?.copyWith(
                                color: SaasTheme.textMuted,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              caption,
              style: const TextStyle(
                color: Color(0xFF94A3B8), // Slate 400 (Muted)
                fontStyle: FontStyle.italic,
                fontSize: 10.5,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title, {bool isMain = false}) {
    if (isMain) {
      return Padding(
        padding: const EdgeInsets.only(top: 60, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: SaasTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: SaasTheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'POINT DE FORMATION',
                style: SaasTheme.textTheme.labelLarge?.copyWith(
                  color: SaasTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: SaasTheme.textTheme.displayLarge?.copyWith(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                letterSpacing: -2.5,
                height: 1.05,
                color: SaasTheme.textBody,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: 100,
              height: 6,
              decoration: BoxDecoration(
                color: SaasTheme.primary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            color: SaasTheme.primary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: SaasTheme.textTheme.displayMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: SaasTheme.textBody.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleText(String? title, String content) {
    final paragraphs = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) _buildSectionTitle(title),
        if (title != null) const SizedBox(height: 32),
        ...paragraphs
            .where((p) => p.trim().isNotEmpty)
            .map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  p.trim(),
                  style: SaasTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: SaasTheme.textBody.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildLegacyContent(SessionModel session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _showcaseHeader('CONTENU TECHNIQUE'),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: session.technicalPoints.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 100,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) =>
              _TechnicalPointCard(title: session.technicalPoints[index]),
        ),
      ],
    );
  }

  Widget _buildBreadcrumb(SessionModel session) {
    return Row(
      children: [
        const Icon(Icons.school_outlined, size: 14, color: SaasTheme.textMuted),
        const SizedBox(width: 8),
        Text(
          'CURRICULUM',
          style: SaasTheme.textTheme.labelLarge?.copyWith(
            color: SaasTheme.textMuted,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, size: 14, color: SaasTheme.textMuted),
        const SizedBox(width: 8),
        Text('CHAPITRE ${session.id}', style: SaasTheme.textTheme.labelLarge),
      ],
    );
  }

  Widget _showcaseHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: SaasTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: SaasTheme.textTheme.labelLarge?.copyWith(
            color: SaasTheme.textBody,
          ),
        ),
      ],
    );
  }
}

class QuizModuleWidget extends StatefulWidget {
  final QuizModule module;
  const QuizModuleWidget({super.key, required this.module});
  @override
  State<QuizModuleWidget> createState() => _QuizModuleWidgetState();
}

class _QuizModuleWidgetState extends State<QuizModuleWidget> {
  final Set<int> _selectedIndices = {};
  bool _isSubmitted = false;

  void _toggleOption(int index) {
    if (_isSubmitted) return;
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect =
        _selectedIndices.length == widget.module.correctIndices.length &&
        _selectedIndices.every((i) => widget.module.correctIndices.contains(i));

    // Theme colors for Dark Card
    const cardBg = Color(0xFF0F172A); // Slate 900
    const optionBg = Color(0xFF1E293B); // Slate 800
    const textPrimary = Colors.white;
    const textSecondary = Color(0xFF94A3B8); // Slate 400

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: SaasTheme.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'AUTO-ÉVALUATION',
                      style: SaasTheme.textTheme.labelLarge?.copyWith(
                        color: SaasTheme.primary,
                        fontSize: 10,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                widget.module.question,
                style: SaasTheme.textTheme.headlineLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),
              ...List.generate(widget.module.options.length, (index) {
                bool isSelected = _selectedIndices.contains(index);
                bool isActuallyCorrect = widget.module.correctIndices.contains(
                  index,
                );

                Color borderColor = Colors.white.withValues(alpha: 0.1);
                Color currentOptionBg = optionBg;

                if (_isSubmitted) {
                  if (isActuallyCorrect) {
                    borderColor = Colors.greenAccent;
                    currentOptionBg = Colors.green.withValues(alpha: 0.1);
                  } else if (isSelected) {
                    borderColor = Colors.redAccent;
                    currentOptionBg = Colors.red.withValues(alpha: 0.1);
                  }
                } else if (isSelected) {
                  borderColor = SaasTheme.primary;
                  currentOptionBg = SaasTheme.primary.withValues(alpha: 0.1);
                }

                return GestureDetector(
                  onTap: () => _toggleOption(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: currentOptionBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? SaasTheme.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? SaasTheme.primary
                                  : Colors.white24,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            widget.module.options[index],
                            style: SaasTheme.textTheme.bodyLarge?.copyWith(
                              color: isSelected ? textPrimary : textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              if (!_isSubmitted)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: _selectedIndices.isEmpty
                          ? null
                          : () => setState(() => _isSubmitted = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedIndices.isEmpty
                            ? Colors.white.withValues(alpha: 0.05)
                            : SaasTheme.primary,
                        foregroundColor: _selectedIndices.isEmpty
                            ? Colors.white24
                            : Colors.white,
                        disabledBackgroundColor: Colors.white.withValues(
                          alpha: 0.05,
                        ),
                        disabledForegroundColor: Colors.white24,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: _selectedIndices.isEmpty
                            ? BorderSide(
                                color: Colors.white.withValues(alpha: 0.05),
                              )
                            : BorderSide.none,
                      ),
                      child: Text(
                        'VÉRIFIER MES RÉPONSES',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: _selectedIndices.isEmpty
                              ? Colors.white24
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              if (_isSubmitted) _buildExplanationBlock(isCorrect),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationBlock(bool isSuccess) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSuccess
              ? Colors.greenAccent.withValues(alpha: 0.2)
              : Colors.orangeAccent.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.help_outline,
                color: isSuccess ? Colors.greenAccent : Colors.orangeAccent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                isSuccess ? 'EXCELLENT !' : 'À REVOIR ...',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: isSuccess ? Colors.greenAccent : Colors.orangeAccent,
                  letterSpacing: 1.5,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.module.explanation,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() {
                _isSubmitted = false;
                _selectedIndices.clear();
              }),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'RECOMMENCER LE QUIZ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookmarksListView extends StatelessWidget {
  final Set<String> bookmarkedIds;
  final Function(int, String) onNavigate;
  const BookmarksListView({
    super.key,
    required this.bookmarkedIds,
    required this.onNavigate,
  });
  @override
  Widget build(BuildContext context) {
    // Find all bookmarked modules across all sessions
    final List<Map<String, dynamic>> bookmarks = [];
    final allSessions = [...basicsSessions, ...unrealSessions];
    for (var session in allSessions) {
      for (var module in session.modules) {
        if (bookmarkedIds.contains(module.id)) {
          bookmarks.add({'session': session, 'module': module});
        }
      }
    }

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MES SIGNETS', style: SaasTheme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(
            'Points techniques favoris.',
            style: SaasTheme.textTheme.displayLarge,
          ),
          const SizedBox(height: 48),
          if (bookmarks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 64,
                    color: SaasTheme.textMuted.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Aucun signet pour le moment',
                    style: SaasTheme.textTheme.headlineMedium?.copyWith(
                      color: SaasTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Marquez des points précis dans les chapitres pour les retrouver ici.',
                    style: SaasTheme.textTheme.bodyMedium?.copyWith(
                      color: SaasTheme.textMuted,
                    ),
                  ),
                ],
              ),
            )
          else
            ...bookmarks.map(
              (b) => _buildBookmarkItem(
                b['session'] as SessionModel,
                b['module'] as ContentModule,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookmarkItem(SessionModel session, ContentModule module) {
    String moduleTitle = "Point technique";

    if (module is TitleModule) {
      moduleTitle = module.title;
    } else if (module is TextModule) {
      final t = module.title;
      if (t != null && t.trim().isNotEmpty) {
        moduleTitle = t;
      } else {
        moduleTitle = module.content.length > 50
            ? "${module.content.substring(0, 47)}..."
            : module.content;
      }
    } else if (module is SideBySideModule) {
      final t = module.title;
      if (t != null && t.trim().isNotEmpty) {
        moduleTitle = t;
      } else {
        moduleTitle = module.content.length > 50
            ? "${module.content.substring(0, 47)}..."
            : module.content;
      }
    } else if (module is FullMediaModule) {
      final c = module.caption;
      moduleTitle = (c != null && c.trim().isNotEmpty) ? c : "Média plein écran";
    } else if (module is InfoModule) {
      String prefix = "Info";
      switch (module.type) {
        case InfoType.idea:
          prefix = "Idée";
          break;
        case InfoType.tip:
          prefix = "Astuce";
          break;
        case InfoType.warning:
          prefix = "Avertissement";
          break;
        case InfoType.info:
          prefix = "Info";
          break;
        case InfoType.objective:
          prefix = "Objectif";
          break;
        case InfoType.challenge:
          prefix = "Défi";
          break;
      }
      final cleanText = module.text.trim();
      moduleTitle = "$prefix : ${cleanText.length > 40 ? "${cleanText.substring(0, 37)}..." : cleanText}";
      if (cleanText.isEmpty) moduleTitle = "$prefix technique";
    } else if (module is ResourceModule) {
      moduleTitle = "Ressource : ${module.title.trim().isNotEmpty ? module.title : module.fileName}";
    } else if (module is ListModule) {
      moduleTitle = module.title.trim().isNotEmpty ? module.title : "Liste de points";
    } else if (module is QuizModule) {
      final q = module.question.trim();
      moduleTitle = "Quiz : ${q.length > 40 ? "${q.substring(0, 37)}..." : q}";
      if (q.isEmpty) moduleTitle = "Quiz technique";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: SaasTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SaasTheme.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: SaasTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(session.icon, color: SaasTheme.primary, size: 20),
        ),
        title: Text(
          moduleTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Chapitre ${session.id} : ${session.title}',
          style: TextStyle(color: SaasTheme.textMuted, fontSize: 13),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        onTap: () => onNavigate(session.id, module.id),
      ),
    );
  }
}

class _TechnicalPointCard extends StatelessWidget {
  final String title;
  const _TechnicalPointCard({required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SaasTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SaasTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SaasTheme.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome_motion_outlined,
              size: 18,
              color: SaasTheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: SaasTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilRougeCard extends StatelessWidget {
  final String content;
  const _FilRougeCard({required this.content});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: SaasTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SaasTheme.primary.withAlpha(40), width: 2),
        boxShadow: SaasTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.assignment_turned_in_rounded,
                color: SaasTheme.primary,
                size: 24,
              ),
              SizedBox(width: 16),
              Text(
                'CHALLENGE DE SESSION',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  fontSize: 13,
                  color: SaasTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            content,
            style: SaasTheme.textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: SaasTheme.textBody,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderHeroView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _PlaceholderHeroView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SECTION', style: SaasTheme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(title, style: SaasTheme.textTheme.displayLarge),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: SaasTheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64, color: SaasTheme.primary),
              ),
              const SizedBox(height: 32),
              Text(
                subtitle,
                style: SaasTheme.textTheme.bodyLarge?.copyWith(
                  color: SaasTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NextChapterButton extends StatefulWidget {
  final String nextSessionTitle;
  final VoidCallback onTap;
  const _NextChapterButton({
    required this.nextSessionTitle,
    required this.onTap,
  });

  @override
  State<_NextChapterButton> createState() => _NextChapterButtonState();
}

class _NextChapterButtonState extends State<_NextChapterButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, bottom: 100, right: 72),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Text(
                  'VOUS AVEZ TERMINÉ CE CHAPITRE',
                  style: SaasTheme.textTheme.labelLarge?.copyWith(
                    color: SaasTheme.textMuted,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      transform: Matrix4.identity()
                        ..scale(_isHovered ? 1.02 : 1.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? SaasTheme.surface
                            : SaasTheme.surface.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isHovered
                              ? SaasTheme.primary
                              : SaasTheme.primary.withValues(alpha: 0.2),
                          width: _isHovered ? 2 : 1.5,
                        ),
                        boxShadow: _isHovered ? SaasTheme.subtleShadow : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PASSER AU SUIVANT',
                                style: SaasTheme.textTheme.labelLarge?.copyWith(
                                  color: _isHovered
                                      ? SaasTheme.primary
                                      : SaasTheme.textMuted,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.nextSessionTitle,
                                style: SaasTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: _isHovered
                                          ? SaasTheme.textBody
                                          : SaasTheme.textBody.withValues(
                                              alpha: 0.8,
                                            ),
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 60),
                          AnimatedPadding(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            padding: EdgeInsets.only(left: _isHovered ? 16 : 0),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: SaasTheme.primary,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgrammeView extends StatelessWidget {
  final Function(int, String?) onNavigate;
  const ProgrammeView({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final chapters = [
      {
        'id': 1,
        'title': 'Fondations & Workflow de Production',
        'objective':
            'Comprendre la philosophie d\'Unreal et structurer son projet.',
        'icon': Icons.architecture_rounded,
        'moduleId': '1_title_p1',
        'points': [
          {'label': 'Interface & Navigation Cinématique', 'id': '1_title_p1'},
          {'label': 'Concepts & Asset Management', 'id': '1_title_p2'},
          {'label': 'Organisation Production Ready', 'id': '1_title_p3'},
          {
            'label': 'Gestion des Levels & Collaboration',
            'id': '1_p4_current_level_info',
          },
          {
            'label': 'Migration & Sécurisation des données',
            'id': '1_p5_path_info',
          },
        ],
      },
      {
        'id': 2,
        'title': 'World Building & Optimisation',
        'objective': 'Créer un décor riche rapidement sans alourdir le moteur.',
        'icon': Icons.landscape_rounded,
        'moduleId': '2_p1_title',
        'points': [
          {
            'label': 'Placement d\'objets & Snapping précis',
            'id': '2_p1_title',
          },
          {'label': 'Landscape Tool & Layer Blends', 'id': '2_p2_title'},
          {'label': 'Instances vs Static Meshes', 'id': '2_p3_title'},
          {'label': 'Foliage Tool & Écosystèmes', 'id': '2_p4_title'},
          {'label': 'Spline Meshes pour câbles et routes', 'id': '2_p5_title'},
          {'label': 'Nanite & Virtual Geometry', 'id': '2_p6_title'},
          {'label': 'Introduction au PCG (Procedural)', 'id': '2_p7_title'},
        ],
      },
      {
        'id': 3,
        'title': 'Shading & Maîtrise des Matériaux',
        'objective': 'Donner l\'intention artistique à travers les surfaces.',
        'icon': Icons.texture_rounded,
        'moduleId': '3_intro',
        'points': [
          {'label': 'Master Materials vs Instances', 'id': '3_master'},
          {'label': 'Effets Fresnel & Transparence', 'id': '3_tip_fresnel'},
          {'label': 'Material Layers & Blending', 'id': '3_layers'},
          {'label': 'Paramétrage dynamique', 'id': '3_quiz_instance'},
        ],
      },
      {
        'id': 4,
        'title': 'Lighting & Atmosphère',
        'objective': 'Sculpter la lumière et l\'espace.',
        'icon': Icons.wb_sunny_rounded,
        'moduleId': '4_lumen',
        'points': [
          {'label': 'Sun & Sky System', 'id': '4_sky'},
          {'label': 'Lighting via HDRI Backdrop', 'id': '4_hdr'},
          {'label': 'Lumen Global Illumination', 'id': '4_lumen'},
          {'label': 'Exponential Height Fog', 'id': '4_fog'},
        ],
      },
      {
        'id': 5,
        'title': 'Sequencer I - Animation & Contraintes',
        'objective': 'Mettre les objets en mouvement.',
        'icon': Icons.movie_filter_rounded,
        'moduleId': '5_intro',
        'points': [
          {'label': 'Timeline, Tracks & Keyframes', 'id': '5_keyframing'},
          {'label': 'Sockets & Attachments d\'objets', 'id': '5_tip_sockets'},
          {'label': 'Spline Follow Path', 'id': '5_intro'},
          {'label': 'Contraintes Look At', 'id': '5_keyframing'},
        ],
      },
      {
        'id': 6,
        'title': 'Sequencer II - Cinématographie & Caméras',
        'objective': 'Maîtriser le langage de la caméra.',
        'icon': Icons.camera_rounded,
        'moduleId': '6_cinecamera',
        'points': [
          {'label': 'Cine Camera Actor', 'id': '6_cinecamera'},
          {'label': 'Focus manuel & Tracking', 'id': '6_focus'},
          {'label': 'Rig Rails & Rig Cranes', 'id': '6_crane'},
          {'label': 'Versioning de plans', 'id': '6_cinecamera'},
        ],
      },
      {
        'id': 7,
        'title': 'Post-Process & Montage Interne',
        'objective': 'Le "Final Look" et la structure narrative.',
        'icon': Icons.auto_awesome_rounded,
        'moduleId': '7_grading',
        'points': [
          {'label': 'Post-Process Volume', 'id': '7_grading'},
          {'label': 'Montage via Camera Cuts', 'id': '7_montage'},
          {'label': 'Transitions narrative', 'id': '7_montage'},
        ],
      },
      {
        'id': 8,
        'title': 'Rendu Technique & Export',
        'objective': 'Sortir les images pour la post-production.',
        'icon': Icons.ios_share_rounded,
        'moduleId': '8_mrq',
        'points': [
          {'label': 'Movie Render Queue (MRQ) Pro', 'id': '8_mrq'},
          {'label': 'Anti-aliasing & Motion Blur', 'id': '8_mrq'},
          {'label': 'Render Passes (Z-Depth)', 'id': '8_passes'},
          {'label': 'Revue finale de l\'animatique', 'id': '8_idea_finish'},
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CURRICULUM COMPLET', style: SaasTheme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(
          'Architecture de la formation.',
          style: SaasTheme.textTheme.displayLarge,
        ),
        const SizedBox(height: 12),
        Text(
          'Huit sessions intensives pour passer de l\'idée au rendu cinématographique final.',
          style: SaasTheme.textTheme.bodyLarge?.copyWith(
            color: SaasTheme.textMuted,
          ),
        ),
        const SizedBox(height: 64),

        // Timeline structure
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            final bool isLast = index == chapters.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vertical Timeline Line
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: SaasTheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: SaasTheme.primary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${chapter['id']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: SaasTheme.primary.withValues(alpha: 0.15),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  // Content Card
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                chapter['icon'] as IconData,
                                size: 20,
                                color: SaasTheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'CHAPITRE ${chapter['id']}',
                                style: SaasTheme.textTheme.labelLarge?.copyWith(
                                  color: SaasTheme.primary,
                                  letterSpacing: 1.5,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => onNavigate(
                                chapter['id'] as int,
                                chapter['moduleId'] as String?,
                              ),
                              child: Text(
                                chapter['title'] as String,
                                style: SaasTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 24,
                                      color: SaasTheme.textBody,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: SaasTheme.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: SaasTheme.primary.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.track_changes_rounded,
                                  size: 14,
                                  color: SaasTheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    chapter['objective'] as String,
                                    style: TextStyle(
                                      color: SaasTheme.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                (chapter['points'] as List<Map<String, String>>)
                                    .map(
                                      (point) => MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () => onNavigate(
                                            chapter['id'] as int,
                                            point['id'],
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: SaasTheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: SaasTheme.border,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .check_circle_outline_rounded,
                                                  size: 14,
                                                  color: SaasTheme.textMuted
                                                      .withValues(alpha: 0.5),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  point['label']!,
                                                  style: SaasTheme
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 40),
        const Divider(),
        const SizedBox(height: 64),

        // Fil Rouge Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [SaasTheme.surface, SaasTheme.background],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: SaasTheme.primary.withValues(alpha: 0.1),
              width: 2,
            ),
            boxShadow: SaasTheme.subtleShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SaasTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.assignment_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXERCICES D\'INTER-SESSIONS',
                        style: SaasTheme.textTheme.labelLarge?.copyWith(
                          color: SaasTheme.primary,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Le Projet Fil Rouge',
                        style: SaasTheme.textTheme.displaySmall?.copyWith(
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Pour assurer la progression, l\'apprenant travaille sur un projet unique de 30 secondes tout au long de la formation.',
                style: SaasTheme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
              const SizedBox(height: 48),
              _buildFilRougeStep(
                1,
                'Créer la structure de dossier "Standard" et importer les assets de base nécessaires.',
              ),
              _buildFilRougeStep(
                2,
                'Monter le layout du décor principal en utilisant au moins une zone générée en PCG.',
              ),
              _buildFilRougeStep(
                3,
                'Créer un "Master Material" paramétrable et l\'appliquer sur les éléments clés du décor.',
              ),
              _buildFilRougeStep(
                4,
                'Créer deux "Lighting Scenarios" différents (jour et orageuse/nuit) pour le même décor.',
              ),
              _buildFilRougeStep(
                5,
                'Animer un véhicule ou un accessoire suivant une trajectoire complexe (Spline) avec contrainte Look At.',
              ),
              _buildFilRougeStep(
                6,
                'Poser les 5 plans caméras principaux du scénario avec des focales variées et gestion du focus.',
              ),
              _buildFilRougeStep(
                7,
                'Appliquer un étalonnage distinct par plan pour renforcer l\'intention dramatique.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildFilRougeStep(int index, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: SaasTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: SaasTheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  color: SaasTheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              description,
              style: SaasTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                height: 1.5,
                color: SaasTheme.textBody.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
