import React from "react";
import { UiContainer } from "../../ui/ui-container/UiContainer";
import { UiDatePicker } from "../../ui/ui-date-picker/UiDatePicker";
import { UiFlex } from "../../ui/ui-flex/UiFlex";
import { UiGroup } from "../../ui/ui-group/UiGroup";
import { UiNumberStepper } from "../../ui/ui-number-stepper/UiNumberStepper";
import { UiSegmentedControl } from "../../ui/ui-segmented-control/UiSegmentedControl";
import { UiSpace } from "../../ui/ui-space/UiSpace";
import { UiTextInput } from "../../ui/ui-text-input/UiTextInput";
import { UiComponentSize } from "../../ui/ui.constants";
import { UiTextButton } from "../../ui/UiTextButton/UiTextButton";
import {useSession} from "next-auth/react";

interface IProps {}

export const LandingPage: React.FC<IProps> = (props) => {
  const { data: session } = useSession();

  console.log(session);

  return (
    <div>
      <h2>Airshare.com</h2>
      HERO CONTENT
      <UiSpace h={50} />
      <UiContainer>
        <UiFlex alignItems={"center"}>
          <h3>Search Flights</h3>
          <UiSpace w={10} />
          <UiSegmentedControl data={["Round Trip", "One Way"]} />
        </UiFlex>

        <UiSpace h={10} />

        <UiFlex>
          <UiTextInput label={"Departure City"} />
          <UiSpace w={10} />
          <UiTextInput label={"Arrival City"} />
          <UiSpace w={10} />
          <UiDatePicker clearable={true} label={"Departure Date"} />
        </UiFlex>

        <UiSpace h={10} />

        <UiFlex alignItems={"center"}>
          <UiGroup>
            Adults <UiNumberStepper />
          </UiGroup>
          <UiSpace w={10} />
          <UiGroup>
            Children <UiNumberStepper />
          </UiGroup>
        </UiFlex>

        <UiSpace h={10} />

        <UiTextButton radius={3} size={UiComponentSize.Medium}>
          Search
        </UiTextButton>
      </UiContainer>
    </div>
  );
};

LandingPage.displayName = "LandingPage";
