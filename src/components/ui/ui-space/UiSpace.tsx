import { Text, Space, SpaceProps } from "@mantine/core";

interface IProps extends SpaceProps {}

export const UiSpace: React.FC<IProps> = (props) => {
  return <Space {...props} />;
};

UiSpace.displayName = "UiSpace;";
