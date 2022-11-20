import { Button, ButtonProps } from "@mantine/core";

interface IProps extends ButtonProps {}

export const UiTextButton: React.FC<IProps> = (props) => {
  const {
    children = null,
    color = "organge",
    radius = "md",
    size = "xl",
    ...componentProps
  } = props;

  return (
    <Button {...componentProps} color={color} radius={radius} size={size}>
      {children}
    </Button>
  );
};
UiTextButton.displayName = "UiTextButton";
