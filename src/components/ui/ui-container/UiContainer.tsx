import { Container, ContainerProps } from "@mantine/core";

interface IProps extends ContainerProps {}

export const UiContainer: React.FC<IProps> = (props) => {
  const { ...componentProps } = props;

  return <Container {...componentProps} />;
};

UiContainer.displayName = "UiContainer";
