import { useRef, useState } from 'react';
import {
  NumberInput,
  NumberInputHandlers,
  ActionIcon,
} from '@mantine/core';
import { IconPlus, IconMinus } from '@tabler/icons';
import { useUiNumberStepperStyles } from './UiNumberStepper.styles';

interface IProps {
  /**
   * @optional
   * @default number
   */
  max?: number;
  /**
   * @optional
   * @default number
   */
  maxWidth?: number;
  /**
   * @optional
   * @default number
   */
  min?: number;
  /**
   * @optional
   * @default number
   */
  value?: number;
}

export const UiNumberStepper: React.FC<IProps> = (props) => {
  const handlers = useRef<NumberInputHandlers>(null);
  const [value, setValue] = useState<number | undefined>(props.value || 1);
  const { min = 1, max = 10 } = props;
  const { classes } = useUiNumberStepperStyles();

  return (
    <div className={classes.wrapper}>
      <ActionIcon<'button'>
        className={classes.control}
        disabled={value === min}
        size={28}
        variant={'transparent'}
        onClick={() => handlers.current?.decrement()}
        onMouseDown={(event) => event.preventDefault()}
      >
        <IconMinus size={16} stroke={2} />
      </ActionIcon>

      <NumberInput
        classNames={{ input: classes.input }}
        handlersRef={handlers}
        max={max}
        min={min}
        value={value}
        variant={'unstyled'}
        onChange={setValue}
      />

      <ActionIcon<'button'>
        className={classes.control}
        disabled={value === max}
        size={28}
        variant={'transparent'}
        onClick={() => handlers.current?.increment()}
        onMouseDown={(event) => event.preventDefault()}
      >
        <IconPlus size={16} stroke={2} />
      </ActionIcon>
    </div>
  );
};
