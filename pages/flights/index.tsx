import { FlightsPage } from "../../src/components/page-components/flights-page/FlightsPage";
import { AppHeader } from "../../src/components/shared/app-header/AppHeader";

export default function Home() {
  return (
    <div>
      <AppHeader />
      <FlightsPage />
    </div>
  );
}
