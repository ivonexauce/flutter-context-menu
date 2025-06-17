# Flutter Context Menu

A reusable custom context menu widget in Flutter that shows "Create", "Edit", and "Remove" on right-click.

## Features
- Appears on right-click
- Stays within screen bounds
- Anchors next to target widget
- Prevents browser context menu on Web
- Responsive to screen resizing

## Demo
[View the app on GitHub Pages](https://ivonexauce.github.io/flutter_context_menu/)

## To Run

```bash
flutter run
```

## To Build for Web

```bash
flutter build web
```

## To Deploy to GitHub Pages

```bash
git checkout -b gh-pages
flutter build web
cp -r build/web/* .
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages --force
```
