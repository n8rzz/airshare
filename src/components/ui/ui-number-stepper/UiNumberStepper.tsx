import { useRef, useState } from "react";
import {
  createStyles,
  NumberInput,
  NumberInputHandlers,
  ActionIcon,
} from "@mantine/core";
import { IconPlus, IconMinus } from "@tabler/icons";
import { useUiNumberStepperStyles } from "./UiNumberStepper.styles";

interface QuantityInputProps {
  min?: number;
  max?: number;
}

export function QuantityInput({ min = 1, max = 10 }: QuantityInputProps) {
  const { classes } = useUiNumberStepperStyles();
  const handlers = useRef<NumberInputHandlers>(null);
  const [value, setValue] = useState<number | undefined>(1);

  return (
    <div className={classes.wrapper}>
      <ActionIcon<"button">
        size={28}
        variant="transparent"
        onClick={() => handlers.current?.decrement()}
        disabled={value === min}
        className={classes.control}
        onMouseDown={(event) => event.preventDefault()}
      >
        <IconMinus size={16} stroke={1.5} />
      </ActionIcon>

      <NumberInput
        variant="unstyled"
        min={min}
        max={max}
        handlersRef={handlers}
        value={value}
        onChange={setValue}
        classNames={{ input: classes.input }}
      />

      <ActionIcon<"button">
        size={28}
        variant="transparent"
        onClick={() => handlers.current?.increment()}
        disabled={value === max}
        className={classes.control}
        onMouseDown={(event) => event.preventDefault()}
      >
        <IconPlus size={16} stroke={1.5} />
      </ActionIcon>
    </div>
  );
}
