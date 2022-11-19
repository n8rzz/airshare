import { TextInput } from "@mantine/core";
import { useUiTextInputStyles } from "./UiTextInput.styles";

interface IProps extends React.ComponentProps<typeof TextInput> {}

export const UiTextInput: React.FC<IProps> = (props) => {
  const { classes } = useUiTextInputStyles();

  return <TextInput {...props} classNames={classes} />;
};
