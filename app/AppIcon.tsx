import { Text, type TextProps, type TextStyle } from "react-native";
import type { MaterialSymbolsIconName } from "./material-symbols-icon-name";

export type AppIconProps = {
  name: MaterialSymbolsIconName;
  weight?: 100 | 200 | 300 | 400 | 500 | 600 | 700;
  variant?: "Rounded" | "Sharp" | "Outlined";
  fill?: boolean;
  opsz?: 20 | 24 | 48;
} & Omit<TextProps, "children">;

export const AppIcon = ({
  name,
  style,
  variant = "Rounded",
  weight = 300,
  fill = false,
  opsz = 24,
  ...rest
}: AppIconProps) => {
  const fontFamily = `MaterialSymbols-${variant}-${weight}-FILL${
    fill ? 1 : 0
  }-OPSZ${opsz}`;

  return (
    <Text {...rest} style={[{ fontFamily }, style as TextStyle]}>
      {name}
    </Text>
  );
};
