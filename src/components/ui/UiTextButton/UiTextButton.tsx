import { Button, ButtonProps } from '@mantine/core';

interface IProps extends ButtonProps {}

export const UiTextButton: React.FC<IProps> = (props) => {
  const {
    children = null,
    color = 'orange',
    radius = 0,
    size = 'sm',
    ...componentProps
  } = props;

  return (
    <Button {...componentProps} color={color} radius={radius} size={size}>
      {children}
    </Button>
  );
};

UiTextButton.displayName = 'UiTextButton';
