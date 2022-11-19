import { PassangersPage } from "../../src/components/page-components/passangers-page/PassangersPage";
import { AppHeader } from "../../src/components/shared/app-header/AppHeader";

export default function Home() {
  return (
    <div>
      <AppHeader />
      <PassangersPage />
    </div>
  );
}
