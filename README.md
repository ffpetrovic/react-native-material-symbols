# React Native Material Symbols - Extracted Static Fonts

**TL;DR:** Copy the contents of the `output` folder, update your [font loading](https://docs.expo.dev/versions/latest/sdk/font/#usage) with `app/fontLoading.ts` and use `app/AppIcon.tsx` or `app/AppIcon.jsx` in your app.

---

Neither [Expo](https://docs.expo.dev/guides/icons/), [Google](https://github.com/google/material-design-icons), nor [marella](https://github.com/marella/material-symbols) offer a satisfactory solution for using [Material Symbols](https://fonts.google.com/icons) in React Native, especially with all their ["variable"](https://fonts.google.com/knowledge/using_variable_fonts_on_the_web) features.

Until a "native" solution is provided, we must extract static variants from the variable font files and map to the correct font at runtime. _If you know of a better solution, please let me know._ This repository aims to help with this issue as much as possible.

## Getting Started

Compiled files and their corresponding components are already included in this repository. If they are satisfactory (e.g., up-to-date), you can skip to [Add Material Symbols to Your App](#add-material-symbols-to-your-app). Otherwise, continue to [Updating Files](#updating-files).

## Updating Files

If you'd like to update the fonts and icon names, please download the following files and place them in the `input/` directory:

- [MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf](https://github.com/google/material-design-icons/blob/master/variablefont/MaterialSymbolsOutlined%5BFILL,GRAD,opsz,wght%5D.ttf?raw=true)
- [MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf](https://github.com/google/material-design-icons/blob/master/variablefont/MaterialSymbolsRounded%5BFILL,GRAD,opsz,wght%5D.ttf?raw=true)
- [MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf](https://github.com/google/material-design-icons/blob/master/variablefont/MaterialSymbolsSharp%5BFILL,GRAD,opsz,wght%5D.ttf?raw=true)
- [MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].codepoints](https://github.com/google/material-design-icons/blob/master/variablefont/MaterialSymbolsOutlined%5BFILL,GRAD,opsz,wght%5D.codepoints?raw=true)

If the above links do not work, visit the [Google Material Design Icons variablefont folder](https://github.com/google/material-design-icons/tree/master/variablefont) and download the files manually.

Required files:

1. All variable fonts for each variant (Rounded, Outlined, Sharp).
2. A `.codepoints` file (used to generate the TypeScript string union for all available icon names).

### Build and Run the Container with Docker

After placing the required font and codepoints files in the `input/` directory, you can build and run the container to process the fonts and generate the TypeScript icon names file:

```sh
docker build -t material-symbols-extractor .
```

```sh
docker run --rm -v $(pwd)/output:/app/output material-symbols-extractor
```

The processed font files will be in `output/fonts` and the TypeScript icon names file will be in `output/material-symbol-icon-names.ts`.

## Add Material Symbols to Your App

1. Copy the font files from `/output/fonts` to your app (e.g., `./assets/fonts`).
2. Update your app's [font loading section](https://docs.expo.dev/versions/latest/sdk/font/#usage) to include these fonts.
3. _(TypeScript only)_ Copy the string union type file for icon names from `/output/material-symbols-icon-names.ts`.
4. Copy the `app/AppIcon.ts` or `app/AppIcon.js` component file to your app. **Ensure the import for `IconNames` is correct.**

## Using the `AppIcon` Component

The `AppIcon` component maps to the correct static font when you provide `weight`, `variant`, and `fill`. All three are optional, as they have default values.

You will have full type support and IntelliSense when using this component (in TypeScript).

```tsx
<AppIcon name="sos" weight={300} filled variant="Rounded" />
```

## TODO

- Add GitHub Action
- Support `fontWeight` from `TextStyle`.
- Support ["Grade"](https://m3.material.io/styles/icons/applying-icons#3ad55207-1cb0-43af-8092-fad2762f69f7)
