import { TextInput, TextInputProps } from "@mantine/core";
import { useUiTextInputStyles } from "./UiTextInput.styles";

interface IProps extends TextInputProps {}

export const UiTextInput: React.FC<IProps> = (props) => {
  const { classes } = useUiTextInputStyles();

  return <TextInput {...props} classNames={classes} />;
};
