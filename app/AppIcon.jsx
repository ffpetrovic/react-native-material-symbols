import { Text } from "react-native";

export const AppIcon = ({
  name,
  style,
  variant = "Rounded",
  weight = 300,
  fill = false,
  opsz = 24,
  ...rest
}) => {
  const fontFamily = `MaterialSymbols-${variant}-${weight}-FILL${fill ? 1 : 0}-OPSZ${opsz}`;

  return (
    <Text
      {...rest}
      style={[{ fontFamily }, style]}
    >
      {name}
    </Text>
  );
};
